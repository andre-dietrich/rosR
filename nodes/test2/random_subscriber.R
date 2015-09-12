#!/usr/bin/r
source(paste(system("rospack find rosR", intern=TRUE), "/lib/ros.R", sep=""), chdir=TRUE)
X11()
ros.Init("R_Subscriber")
subscriber <- ros.Subscriber("random", "std_msgs/Float32")
x <- rep(NA, 100)
y <- rep(NA, 100)
while(ros.OK()){
	ros.SpinOnce()
	if(ros.SubscriberHasNewMessage(subscriber)){
		message <- ros.ReadMessage(subscriber)
		y <- c(y[-1], message$data)
		x <- c(x[-1], ros.TimeNow())
		
		plot(x, y, t="l")
		print(message$data)
	}
}
