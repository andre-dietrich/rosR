load.dynamic.libraries<-function(libnames) {
    for(libname in libnames) {
        found_file=libname;
        for(path in unlist(strsplit(Sys.getenv("LD_LIBRARY_PATH"),":",fixed=TRUE))) {
            try_file <- paste0(path,"/",libname);
            if( file.exists(try_file) ) {
                found_file = try_file;
                break;
            }
        }
        write(paste("Loading :", try_file), stderr())
        dyn.load(found_file);
    }
}

# dyn.load(paste("rosR", .Platform$dynlib.ext, sep=""))
load.dynamic.libraries("rosR.so")
source("rosR.R")
source("std_vector.R")
cacheMetaData(1)

# mandatory option for not loosing precision...
options(digits=22)

rros_base_types <<- list(
		all = c( 	"bool", "string", "int8", "uint8", "int16", "uint16",
				"int32", "uint32", "int64", "uint64", "float32",
				"float64", "duration", "time", "byte", "char" ),
		integer = c(	"int8", "uint8", "int16", "uint16", "int32", "uint32",
				"int64", "uint64", "byte", "char"),
		double = c(	"float32", "float64", "time", "duration" ),
		logical = c(	"bool"),
		character = c(	"string") )

# buffer for storing allready parsed message definitions...
rros_msg_buffer 	<<- list(strType=c(), rosConversions=c(), rosReadExpr=c(), rosWriteExpr=c(), rosTypes=c())
# only once initialized ...
rros_node 		<<- c()

get_msg_def <- function(msg){
	command <- paste("rosmsg show", msg)
	msg_def <- system(command, intern=TRUE)
	return(msg_def)
}

get_msg_md5 <- function(msg){
	command <- paste("rosmsg md5", msg)
	msg_md5 <- system(command, intern=TRUE)
	return(msg_md5)
}

basic_datatype_translation <- function(type, ar, size, constant, value){

	if(type == "time" || type == "duration"){
		type <- "float64"
	} else if(type == "byte" ) {
		type <- "int8"
	} else if(type == "char" || type == "bool") {
		type <- "uint8"
	}

	if(ar==FALSE){
		if(constant == FALSE){
			# standard conversation
			if(is.element(type, rros_base_types$integer)) {
				if(size == 0) 	el <- 0
				else 			el <- list(integer(size))
			} else if(is.element(type, rros_base_types$double)) {
				if(size == 0)	el <- 0.0
				else			el <- list(double(size))
			} else if(is.element(type, rros_base_types$logical)) {
				if(size == 0)	el <- F
				else			el <- list(logical(size))
			} else if(is.element(type, rros_base_types$character)) {
				if(size == 0)	el <- ''
				else			el <- list(character(size))
			} else {
				el <- list()
			}
		} else {
			if(is.element(type, rros_base_types$integer)) {
				el <- strtoi(value)
			} else if(is.element(type, rros_base_types$double)) {
				el <- as.numeric(value)
			} else if(is.element(type, rros_base_types$logical)) {
				el <- as.logical(value)
			} else {
				el <- value
			}
		}
	}
	else{
		el <- rros_vector(type)
	}
	return(el)
}

basic_datatype_conversion <- function(type, ar, size, var="", read=TRUE){

	if(type == "time" || type == "duration"){
		type <- "float64"
	} else if(type == "byte" ) {
		type <- "int8"
	} else if(type == "char" || type == "bool") {
		type <- "uint8"
	}

	el <- ""

	if(read){
		if(ar==FALSE){
			el <- paste("msg$", var,"<-rros_stream_read_", type, "(stream)", sep="")
		} else {
			el <- paste("msg$", var,"@ptr<-rros_stream_read_", type, "_array(stream, ", size,")", sep="")
		}
	} else {
		if(ar==FALSE){
			el <- paste("rros_stream_write_", type, "(stream, msg$", var,")", sep="")
		} else {
			el <- paste("rros_stream_write_", type, "_array(stream, msg$", var,"@ptr)", sep="")
		}
	}
	return(el)
}

get_msg_convertion <- function(msg, msg_def=NaN, space=""){
	if(is.nan(msg_def[1])){
		msg_def <- get_msg_def(msg)
	}
	cls <- c()
	for(i in (1:length(msg_def))){
		isArray    <- c(FALSE, 0)
		isConstant <- FALSE
		valueConstant <- 0
		var <- strsplit(sub("^ +", "", msg_def[i]), " ")[[1]]
		# same number of spaces
		if(grepl(paste("^", space, "[[:alpha:]]", sep=""), msg_def[i])){

			# array ?
			if(grepl("[", var[1], fixed=TRUE)){
				ar <- strsplit(var[1], "[", fixed=TRUE)[[1]]
				var[1] <- ar[1]
				isArray[1] <- TRUE
				isArray[2] <- strtoi(strsplit(ar[2], "]", fixed=TRUE)[[1]])
			}

			# constant ?
			if(grepl("=", var[2], fixed=TRUE)){
				constant <- strsplit(var[2], "=", fixed=TRUE)[[1]]
				var[2] <- constant[1]
				valueConstant <- constant[2]
				isConstant <- TRUE
			}

			if(var[2] == "function"){ var[2] <- "function_"}

			# if it is a final type
			if( is.element(var[1], rros_base_types$all) ){

				el <- list(	element=var[2], datatype=var[1],
							array=isArray[1], array_size=isArray[2],
							constant=isConstant, constant_value=valueConstant)
				cls <- rbind2(cls, el)
			} else{
				sub_cls <- get_msg_convertion(msg, msg_def[i+1:length(msg_def)], paste(space, " "))
				for(j in (1:nrow(sub_cls))){
					sub_cls[j,1] <- paste(var[2], sub_cls[j,1], sep="$")
					cls <- rbind2(cls, sub_cls[j,])
				}
			}
		} else {
			if(nchar(space)>0){
				break
			}
		}
	}
	return(cls)
}
#get_msg_convertion("rosgraph_msgs/Log")

# ros interface functions ...
ros.Init <- function(name){
	rros_node <<- rrosInitNode(name)
}

ros.Logging <- function(str, mode=1){ rrosLog(str, mode) }
ros.Debug <- function(str){ ros.Logging(str,0) }
ros.Info  <- function(str){ ros.Logging(str,1) }
ros.Warn  <- function(str){ ros.Logging(str,2) }
ros.Error <- function(str){ ros.Logging(str,3) }
ros.Fatal <- function(str){ ros.Logging(str,4) }

ros.Subscriber <- function(topic, type=""){
	msg_def <- get_msg_def(type)
	if(length(msg_def)==0) {
		ros.Warn(paste("unknown message format:", type))
	}
	subscriber <- rrosSubscriber(rros_node, topic, type, msg_def, get_msg_md5(type))
	return(subscriber)
}

ros.Publisher <- function(topic, type=""){
	msg_def <- get_msg_def(type)
	if(length(msg_def)==0) {
		ros.Warn(paste("unknown message format:", type))
	}
	publisher <- rrosPublisher(rros_node, topic, type, msg_def, get_msg_md5(type))
	return(publisher)
}

ros.Message <- function(type, convert=0) {
	# was already created ...
	if(is.element(type, rros_msg_buffer$strType)){
		pos <- which(rros_msg_buffer$strType == type)

		msg       <- rros_msg_buffer$rosTypes[[pos]]
		exprRead  <- rros_msg_buffer$rosReadExpr[[pos]]
		exprWrite <- rros_msg_buffer$rosWriteExpr[[pos]]
		conv      <- rros_msg_buffer$rosConversions[[pos]]
	} else {
		rros_msg_buffer$strType <<- append(rros_msg_buffer$strType, type)
		conv 	<- get_msg_convertion(type)
		rros_msg_buffer$rosConversions <<- append(rros_msg_buffer$rosType, list(conv))

		#create msg
		msg <- list()
		for(i in (1:nrow(conv))){
			eval(parse(text=paste("msg$",
						conv[i,1],
						"<-basic_datatype_translation('",conv[i,2],"',", conv[i,3], "," , conv[i,4], "," , conv[i,5],",'" , conv[i,6],"')",
						sep="")))
		}
		rros_msg_buffer$rosTypes <<- append(rros_msg_buffer$rosTypes, list(msg))

		#create read expressions
		exprRead <- c()
		for(i in (1:nrow(conv))){
			if(conv[i,5] == FALSE){
				expr<-parse(text=basic_datatype_conversion(conv[i,2], conv[i,3], conv[i,4], conv[i,1], TRUE) )
				exprRead <- c(exprRead, expr)
			}
		}
		rros_msg_buffer$rosReadExpr <<- append(rros_msg_buffer$rosReadExpr, list(exprRead))

		#create write expressions
		exprWrite <- c()
		for(i in (1:nrow(conv))){
			if(conv[i,5] == FALSE){
				expr<-parse(text=basic_datatype_conversion(conv[i,2], conv[i,3], conv[i,4], conv[i,1], FALSE) )
				exprWrite <- c(exprWrite, expr)
			}
		}
		rros_msg_buffer$rosWriteExpr <<- append(rros_msg_buffer$rosWriteExpr, list(exprWrite))
	}

	if(convert == 1){
		return(exprRead)
	} else if(convert == 2){
		return(exprWrite)
	} else if(convert == 3){
		return(conv)
	} else {
		return(msg)
	}
}

ros.ReadMessage <- function(subscriber){
	type <- rrosSubscriberGetMessageType(subscriber)
	msg <- ros.Message(type)
	conv <- ros.Message(type, convert=1)
	stream <- rrosSubscriberGetMessageStream(subscriber)

	for(expr in conv){
		eval(expr)
	}

	return(msg)
}

ros.WriteMessage <- function(publisher, msg){
	type <- rrosPublisherGetMessageType(publisher)
	conv <- ros.Message(type, convert=2)
	stream <- rrosPublisherGetMessageStream(publisher)
	for(expr in conv){
		eval(expr)
	}
	rrosPublish(publisher)
}
ros.SpinOnce <- function(){
	rrosSpinOnce()
}

ros.TimeNow <- function(){
	rrosTimeNow()
}

ros.SubscriberHasNewMessage <- function(subscriber){
	return(rrosSubscriberHasNewMsg(subscriber))
}

ros.OK <- function(){
	rrosOK()
}

ros.BagRead <- function(filename, topics="", max_size=-1){

	vecTopics <- rros_vector("string")

	for(topic in topics){
		append(vecTopics, topic)
	}

	vecBag <- rrosBagRead(filename, vecTopics@ptr, max_size)

	rros_vector_remove(vecTopics)
	rm(vecTopics)

	topics     <- c()
	data_types <- c()
	messages   <- c()
	time_stamps<- c()

	for(i in (0:(vector_bag_size(vecBag)[1]-1))){
		el <- vector_bag___getitem__(vecBag,i)

		data_type <- BagMessage_datatype_get(el)
		msg  <- ros.Message(data_type)
		conv <- ros.Message(data_type, convert=1)
		stream <- BagMessage_isStream_get(el)
		for(expr in conv){
			eval(expr)
		}

		data_types <- c(data_types, data_type)
		topics <- c(topics, BagMessage_topic_get(el))
		messages <- c(messages, list(msg))
		time_stamps <- c(time_stamps, BagMessage_time_stamp_get(el))
	}

	return( list(topic=topics, data_type=data_types, message=messages, time_stamp=time_stamps) )
}

#ROS_BagRead("/home/andre/2012-12-27-15-49-57.bag")

ros.ParamSet <- function(param, value){
	type <- typeof(value)
	if(type == 'logical'){
		rrosSetParamBoolean(rros_node, param, value)
	} else if(type == 'integer'){
		rrosSetParamInteger(rros_node, param, value)
	} else if(type == 'double'){
		rrosSetParamDouble(rros_node, param, value)
	}else if(type == 'character'){
		rrosSetParamString(rros_node, param, value)
	}
}

ros.ParamGet <- function(param){
	type <- ros.ParamType(param)
	if(type == 'logical'){
		return(rrosGetParamBoolean(rros_node, param))
	} else if(type == 'integer'){
		return(rrosGetParamInteger(rros_node, param))
	} else if(type == 'double'){
		return(rrosGetParamDouble(rros_node, param))
	}else if(type == 'character'){
		return(rrosGetParamString(rros_node, param))
	}

	return(NULL)
}

ros.ParamType <- function(param){
	type <- rrosGetParamType(rros_node, param)

	if(type == "NULL"){
		return(NULL)
	}
	return(type)
}

ros.ParamDelete <- function(param){
	rrosDeleteParam(rros_node, param)
}
