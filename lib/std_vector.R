setClass("rros_vector")

setClass("rros_vector_int8",
	representation(ptr=class(vector_int8())),
	prototype=list(ptr=vector_int8()),
	contains="rros_vector"
)
setClass("rros_vector_uint8",
		representation(ptr=class(vector_uint8())),
		prototype=list(ptr=vector_uint8()),
		contains="rros_vector"
)
setClass("rros_vector_int16",
		representation(ptr=class(vector_int16())),
		prototype=list(ptr=vector_int16())
)
setClass("rros_vector_uint16",
		representation(ptr=class(vector_uint16())),
		prototype=list(ptr=vector_uint16()),
		contains="rros_vector"
)
setClass("rros_vector_int32",
		representation(ptr=class(vector_int32())),
		prototype=list(ptr=vector_int32()),
		contains="rros_vector"
)
setClass("rros_vector_uint32",
		representation(ptr=class(vector_uint32())),
		prototype=list(ptr=vector_uint32()),
		contains="rros_vector"
)
setClass("rros_vector_int64",
		representation(ptr=class(vector_int64())),
		prototype=list(ptr=vector_int64()),
		contains="rros_vector"
)
setClass("rros_vector_uint64",
		representation(ptr=class(vector_uint64())),
		prototype=list(ptr=vector_uint64()),
		contains="rros_vector"
)
setClass("rros_vector_float32",
		representation(ptr=class(vector_float32())),
		prototype=list(ptr=vector_float32()),
		contains="rros_vector"
)
setClass("rros_vector_float64",
		representation(ptr=class(vector_float64())),
		prototype=list(ptr=vector_float64()),
		contains="rros_vector"
)
setClass("rros_vector_string",
		representation(ptr=class(vector_string())),
		prototype=list(ptr=vector_string()),
		contains="rros_vector"
)

setMethod("initialize",
	"rros_vector",
	function(.Object) {
		.Object
	}
)

setMethod("length", "rros_vector",
	function(x) {
		if(class(x@ptr) == class(vector_int8()))		{ size <- vector_int8_size }
		else if(class(x@ptr) == class(vector_uint8()))	{ size <- vector_uint8_size }
		else if(class(x@ptr) == class(vector_int16()))	{ size <- vector_int16_size }
		else if(class(x@ptr) == class(vector_uint16()))	{ size <- vector_uint16_size }
		else if(class(x@ptr) == class(vector_int32()))	{ size <- vector_int32_size }
		else if(class(x@ptr) == class(vector_uint32()))	{ size <- vector_uint32_size }
		else if(class(x@ptr) == class(vector_int64()))	{ size <- vector_int64_size }
		else if(class(x@ptr) == class(vector_uint64()))	{ size <- vector_uint64_size }
		else if(class(x@ptr) == class(vector_float32()))	{ size <- vector_float32_size }
		else if(class(x@ptr) == class(vector_float64()))	{ size <- vector_float64_size }
		else if(class(x@ptr) == class(vector_string()))		{ size <- vector_string_size }
		
		size(x@ptr)[1]
	}
)

setMethod("print", "rros_vector",
	function(x) {
		if(length(x) < getOption("max.print")){
			v <- x[1:length(x)]
		} else {
			v <- x[1:getOption("max.print")]
		}
		print(v)
	}
)

setMethod("show", "rros_vector",
		function(object) {
			print(object)
		}
)

setGeneric("set_ptr",function(object, ptr){standardGeneric("set_ptr")})
setMethod("set_ptr", "rros_vector",
		function(object, ptr) {
			object@ptr <- ptr
		}
)

setMethod("[", "rros_vector",
	function (x, i) {
		
		if(class(x@ptr) == class(vector_int8()))		{ getitem <- vector_int8___getitem__ }
		else if(class(x@ptr) == class(vector_uint8()))	{ getitem <- vector_uint8___getitem__ }
		else if(class(x@ptr) == class(vector_int16()))	{ getitem <- vector_int16___getitem__ }
		else if(class(x@ptr) == class(vector_uint16()))	{ getitem <- vector_uint16___getitem__ }
		else if(class(x@ptr) == class(vector_int32()))	{ getitem <- vector_int32___getitem__ }
		else if(class(x@ptr) == class(vector_uint32()))	{ getitem <- vector_uint32___getitem__ }
		else if(class(x@ptr) == class(vector_int64()))	{ getitem <- vector_int64___getitem__ }
		else if(class(x@ptr) == class(vector_uint64()))	{ getitem <- vector_uint64___getitem__ }
		else if(class(x@ptr) == class(vector_float32()))	{ getitem <- vector_float32___getitem__ }
		else if(class(x@ptr) == class(vector_float64()))	{ getitem <- vector_float64___getitem__ }
		else if(class(x@ptr) == class(vector_string()))		{ getitem <- vector_string___getitem__ }
		
		if(length(x) == 0){
			return(NULL)
		}
		
		res <- vector(length=length(i))
		pos <- 1
		for(el in i) {
			res[pos]<-getitem(x@ptr, el-1)[1]
			pos<-pos+1
		}
		return(res)
	}
)

setReplaceMethod("[", "rros_vector",
	function(x,i,value){
		
		if(class(x@ptr) == class(vector_int8()))		{ setitem <- vector_int8___setitem__ }
		else if(class(x@ptr) == class(vector_uint8()))	{ setitem <- vector_uint8___setitem__ }
		else if(class(x@ptr) == class(vector_int16()))	{ setitem <- vector_int16___setitem__ }
		else if(class(x@ptr) == class(vector_uint16()))	{ setitem <- vector_uint16___setitem__ }
		else if(class(x@ptr) == class(vector_int32()))	{ setitem <- vector_int32___setitem__ }
		else if(class(x@ptr) == class(vector_uint32()))	{ setitem <- vector_uint32___setitem__ }
		else if(class(x@ptr) == class(vector_int64()))	{ setitem <- vector_int64___setitem__ }
		else if(class(x@ptr) == class(vector_uint64()))	{ setitem <- vector_uint64___setitem__ }
		else if(class(x@ptr) == class(vector_float32()))	{ setitem <- vector_float32___setitem__ }
		else if(class(x@ptr) == class(vector_float64()))	{ setitem <- vector_float64___setitem__ }
		else if(class(x@ptr) == class(vector_string()))		{ setitem <- vector_string___setitem__ }
		
		if(length(value) == 1){
			for(el in i) {
				setitem(x@ptr, el-1, value)
			}
		} else {
			for(el in (1:length(i))) {
				setitem(x@ptr, i[el]-1, value[el])
			}
		}
		
		validObject(x)
		return(x)
	}
)

setMethod("append", "rros_vector",
	function(x,values,after){
		
		if(class(x@ptr) == class(vector_int8()))		{ fct <- vector_int8_append }
		else if(class(x@ptr) == class(vector_uint8()))	{ fct <- vector_uint8_append }
		else if(class(x@ptr) == class(vector_int16()))	{ fct <- vector_int16_append }
		else if(class(x@ptr) == class(vector_uint16()))	{ fct <- vector_uint16_append }
		else if(class(x@ptr) == class(vector_int32()))	{ fct <- vector_int32_append }
		else if(class(x@ptr) == class(vector_uint32()))	{ fct <- vector_uint32_append }
		else if(class(x@ptr) == class(vector_int64()))	{ fct <- vector_int64_append }
		else if(class(x@ptr) == class(vector_uint64()))	{ fct <- vector_uint64_append }
		else if(class(x@ptr) == class(vector_float32()))	{ fct <- vector_float32_append }
		else if(class(x@ptr) == class(vector_float64()))	{ fct <- vector_float64_append }
		else if(class(x@ptr) == class(vector_string()))		{ fct <- vector_string_append }
		
		for(el in values) {
			fct(x@ptr, el)
		}
	}
)

setGeneric("push_back",function(x,values){standardGeneric("push_back")})
setMethod("push_back", "rros_vector",
		function(x,values){
			
			if(class(x@ptr) == class(vector_int8()))		{ fct <- vector_int8_push_back }
			else if(class(x@ptr) == class(vector_uint8()))	{ fct <- vector_uint8_push_back }
			else if(class(x@ptr) == class(vector_int16()))	{ fct <- vector_int16_push_back }
			else if(class(x@ptr) == class(vector_uint16()))	{ fct <- vector_uint16_push_back }
			else if(class(x@ptr) == class(vector_int32()))	{ fct <- vector_int32_push_back }
			else if(class(x@ptr) == class(vector_uint32()))	{ fct <- vector_uint32_push_back }
			else if(class(x@ptr) == class(vector_int64()))	{ fct <- vector_int64_push_back }
			else if(class(x@ptr) == class(vector_uint64()))	{ fct <- vector_uint64_push_back }
			else if(class(x@ptr) == class(vector_float32()))	{ fct <- vector_float32_push_back }
			else if(class(x@ptr) == class(vector_float64()))	{ fct <- vector_float64_push_back }
			else if(class(x@ptr) == class(vector_string()))		{ fct <- vector_string_push_back }
			
			for(el in values) {
				fct(x@ptr, el)
			}
		}
)

setGeneric("resize",function(x,size){standardGeneric("resize")})
setMethod("resize", "rros_vector",
		function(x,size){
			
			if(class(x@ptr) == class(vector_int8()))		{ fct <- vector_int8_resize }
			else if(class(x@ptr) == class(vector_uint8()))	{ fct <- vector_uint8_resize }
			else if(class(x@ptr) == class(vector_int16()))	{ fct <- vector_int16_resize }
			else if(class(x@ptr) == class(vector_uint16()))	{ fct <- vector_uint16_resize }
			else if(class(x@ptr) == class(vector_int32()))	{ fct <- vector_int32_resize }
			else if(class(x@ptr) == class(vector_uint32()))	{ fct <- vector_uint32_resize }
			else if(class(x@ptr) == class(vector_int64()))	{ fct <- vector_int64_resize }
			else if(class(x@ptr) == class(vector_uint64()))	{ fct <- vector_uint64_resize }
			else if(class(x@ptr) == class(vector_float32()))	{ fct <- vector_float32_resize }
			else if(class(x@ptr) == class(vector_float64()))	{ fct <- vector_float64_resize }
			else if(class(x@ptr) == class(vector_string()))		{ fct <- vector_string_resize }
			
			fct(x@ptr, size)
		}
)

setGeneric("pop",function(x){standardGeneric("pop")})
setMethod("pop", "rros_vector",
		function(x){
			
			if(class(x@ptr) == class(vector_int8()))		{ fct <- vector_int8_pop }
			else if(class(x@ptr) == class(vector_uint8()))	{ fct <- vector_uint8_pop }
			else if(class(x@ptr) == class(vector_int16()))	{ fct <- vector_int16_pop }
			else if(class(x@ptr) == class(vector_uint16()))	{ fct <- vector_uint16_pop }
			else if(class(x@ptr) == class(vector_int32()))	{ fct <- vector_int32_pop }
			else if(class(x@ptr) == class(vector_uint32()))	{ fct <- vector_uint32_pop }
			else if(class(x@ptr) == class(vector_int64()))	{ fct <- vector_int64_pop }
			else if(class(x@ptr) == class(vector_uint64()))	{ fct <- vector_uint64_pop }
			else if(class(x@ptr) == class(vector_float32()))	{ fct <- vector_float32_pop }
			else if(class(x@ptr) == class(vector_float64()))	{ fct <- vector_float64_pop }
			else if(class(x@ptr) == class(vector_string()))		{ fct <- vector_string_pop }
			
			val <- fct(x@ptr)
			
			return(val[1])
		}
)

setGeneric("pop_back",function(x){standardGeneric("pop_back")})
setMethod("pop_back", "rros_vector",
		function(x){
			
			if(class(x@ptr) == class(vector_int8()))		{ fct <- vector_int8_pop_back }
			else if(class(x@ptr) == class(vector_uint8()))	{ fct <- vector_uint8_pop_back }
			else if(class(x@ptr) == class(vector_int16()))	{ fct <- vector_int16_pop_back }
			else if(class(x@ptr) == class(vector_uint16()))	{ fct <- vector_uint16_pop_back }
			else if(class(x@ptr) == class(vector_int32()))	{ fct <- vector_int32_pop_back }
			else if(class(x@ptr) == class(vector_uint32()))	{ fct <- vector_uint32_pop_back }
			else if(class(x@ptr) == class(vector_int64()))	{ fct <- vector_int64_pop_back }
			else if(class(x@ptr) == class(vector_uint64()))	{ fct <- vector_uint64_pop_back }
			else if(class(x@ptr) == class(vector_float32()))	{ fct <- vector_float32_pop_back }
			else if(class(x@ptr) == class(vector_float64()))	{ fct <- vector_float64_pop_back }
			else if(class(x@ptr) == class(vector_string()))		{ fct <- vector_string_pop_back }
			
			fct(x@ptr)
		}
)

setGeneric("back",function(x){standardGeneric("back")})
setMethod("back", "rros_vector",
		function(x){
			
			if(class(x@ptr) == class(vector_int8()))		{ fct <- vector_int8_back }
			else if(class(x@ptr) == class(vector_uint8()))	{ fct <- vector_uint8_back }
			else if(class(x@ptr) == class(vector_int16()))	{ fct <- vector_int16_back }
			else if(class(x@ptr) == class(vector_uint16()))	{ fct <- vector_uint16_back }
			else if(class(x@ptr) == class(vector_int32()))	{ fct <- vector_int32_back }
			else if(class(x@ptr) == class(vector_uint32()))	{ fct <- vector_uint32_back }
			else if(class(x@ptr) == class(vector_int64()))	{ fct <- vector_int64_back }
			else if(class(x@ptr) == class(vector_uint64()))	{ fct <- vector_uint64_back }
			else if(class(x@ptr) == class(vector_float32()))	{ fct <- vector_float32_back }
			else if(class(x@ptr) == class(vector_float64()))	{ fct <- vector_float64_back }
			else if(class(x@ptr) == class(vector_string()))		{ fct <- vector_string_back }
			
			return(fct(x@ptr))
		}
)

setGeneric("front",function(x){standardGeneric("front")})
setMethod("front", "rros_vector",
		function(x){
			
			if(class(x@ptr) == class(vector_int8()))		{ fct <- vector_int8_front }
			else if(class(x@ptr) == class(vector_uint8()))	{ fct <- vector_uint8_front }
			else if(class(x@ptr) == class(vector_int16()))	{ fct <- vector_int16_front }
			else if(class(x@ptr) == class(vector_uint16()))	{ fct <- vector_uint16_front }
			else if(class(x@ptr) == class(vector_int32()))	{ fct <- vector_int32_front }
			else if(class(x@ptr) == class(vector_uint32()))	{ fct <- vector_uint32_front }
			else if(class(x@ptr) == class(vector_int64()))	{ fct <- vector_int64_front }
			else if(class(x@ptr) == class(vector_uint64()))	{ fct <- vector_uint64_front }
			else if(class(x@ptr) == class(vector_float32()))	{ fct <- vector_float32_front }
			else if(class(x@ptr) == class(vector_float64()))	{ fct <- vector_float64_front }
			else if(class(x@ptr) == class(vector_string()))		{ fct <- vector_string_front }
			
			return(fct(x@ptr))
		}
)

setGeneric("clear",function(x){standardGeneric("clear")})
setMethod("clear", "rros_vector",
		function(x){
			
			if(class(x@ptr) == class(vector_int8()))		{ fct <- vector_int8_clear }
			else if(class(x@ptr) == class(vector_uint8()))	{ fct <- vector_uint8_clear }
			else if(class(x@ptr) == class(vector_int16()))	{ fct <- vector_int16_clear }
			else if(class(x@ptr) == class(vector_uint16()))	{ fct <- vector_uint16_clear }
			else if(class(x@ptr) == class(vector_int32()))	{ fct <- vector_int32_clear }
			else if(class(x@ptr) == class(vector_uint32()))	{ fct <- vector_uint32_clear }
			else if(class(x@ptr) == class(vector_int64()))	{ fct <- vector_int64_clear }
			else if(class(x@ptr) == class(vector_uint64()))	{ fct <- vector_uint64_clear }
			else if(class(x@ptr) == class(vector_float32()))	{ fct <- vector_float32_clear }
			else if(class(x@ptr) == class(vector_float64()))	{ fct <- vector_float64_clear }
			else if(class(x@ptr) == class(vector_string()))		{ fct <- vector_string_clear }
			
			fct(x@ptr)
		}
)

setGeneric("rros_vector_remove",function(x){standardGeneric("rros_vector_remove")})
setMethod("rros_vector_remove", "rros_vector",
		function(x){			
			if(class(x@ptr) == class(vector_int8()))		{ fct <- vector_int8_clear }
			else if(class(x@ptr) == class(vector_uint8()))	{ fct <- vector_uint8_clear }
			else if(class(x@ptr) == class(vector_int16()))	{ fct <- vector_int16_clear }
			else if(class(x@ptr) == class(vector_uint16()))	{ fct <- vector_uint16_clear }
			else if(class(x@ptr) == class(vector_int32()))	{ fct <- vector_int32_clear }
			else if(class(x@ptr) == class(vector_uint32()))	{ fct <- vector_uint32_clear }
			else if(class(x@ptr) == class(vector_int64()))	{ fct <- vector_int64_clear }
			else if(class(x@ptr) == class(vector_uint64()))	{ fct <- vector_uint64_clear }
			else if(class(x@ptr) == class(vector_float32()))	{ fct <- vector_float32_clear }
			else if(class(x@ptr) == class(vector_float64()))	{ fct <- vector_float64_clear }
			else if(class(x@ptr) == class(vector_string()))		{ fct <- vector_string_clear }
			
			fct(x@ptr)
			
			rm(x)
		}
)

#setMethod("rm", "rros_vector",
#		function(list, pos=-1, envir = as.environment(-1), inherits=FALSE){
#			#x <- as.environment(x)
#			print(x)
#			print(pos)
#			print(envir)
##			if(class(x@ptr) == class(vector_int8()))		{ v_clear <- vector_int8_clear }
##			else if(class(x@ptr) == class(vector_uint8()))	{ v_clear <- vector_uint8_clear }
##			else if(class(x@ptr) == class(vector_int16()))	{ v_clear <- vector_int16_clear }
##			else if(class(x@ptr) == class(vector_uint16()))	{ v_clear <- vector_uint16_clear }
##			else if(class(x@ptr) == class(vector_int32()))	{ v_clear <- vector_int32_clear }
##			else if(class(x@ptr) == class(vector_uint32()))	{ v_clear <- vector_uint32_clear }
##			else if(class(x@ptr) == class(vector_int64()))	{ v_clear <- vector_int64_clear }
##			else if(class(x@ptr) == class(vector_uint64()))	{ v_clear <- vector_uint64_clear }
##			else if(class(x@ptr) == class(vector_float32()))	{ v_clear <- vector_float32_clear }
##			else if(class(x@ptr) == class(vector_float64()))	{ v_clear <- vector_float64_clear }
##			else if(class(x@ptr) == class(vector_string()))		{ v_clear <- vector_string_clear }
#			
##			v_clear(x@ptr)
#			
##			rm(x)
#		}
#)

rros_vector <- function(type){
	new(paste("rros_vector_", type, sep=""))
}


#cll <- new("rros_vector_uint8", ptr=list(1,2,3,4,5))
#length(cll)
#cll <- new("rros_vector_uint8", ptr=msg$data)

