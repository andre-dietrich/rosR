#!/usr/bin/r
source(paste(system("rospack find rosR", intern=T), "/lib/ros.R", sep=""), chdir=T)

ros.Init("R_Publisher")

publisher <- ros.Publisher("chatter", "std_msgs/String")

message <- ros.Message("std_msgs/String")

while(ros.OK()){
	message$data <- paste("hello world", ros.TimeNow())

	ros.WriteMessage(publisher, message)
	
	Sys.sleep(0.01)
	
	ros.Info(message$data)
}
