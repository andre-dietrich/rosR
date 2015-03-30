#!/usr/bin/r
source(paste(system("rospack find rosR", intern=TRUE), "/lib/ros.R", sep=""), chdir=TRUE)

ros.Init("R_Subscriber")

subscriber <- ros.Subscriber("chatter", "std_msgs/String")

while(ros.OK()){
	ros.SpinOnce()
	if(ros.SubscriberHasNewMessage(subscriber)){
		message <- ros.ReadMessage(subscriber)
		ros.Error(message$data)
	}
}
