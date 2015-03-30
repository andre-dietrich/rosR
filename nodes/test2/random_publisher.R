#!/usr/bin/r
source(paste(system("rospack find rosR", intern=TRUE), "/lib/ros.R", sep=""), chdir=TRUE)

ros.Init("R_Publisher")

publisher <- ros.Publisher("random", "std_msgs/Float32")

message <- ros.Message("std_msgs/Float32")

while(ros.OK()){
	message$data <- runif(1, 0.5, 3)
	
	ros.WriteMessage(publisher, message)
	
	Sys.sleep(0.05)
	
	print(message$data)
}
