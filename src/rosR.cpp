#include "rosR.h"

void rrosSpinOnce()	{ ros::spinOnce(); 	}
void rrosSpin()		{ ros::spin(); 		}
bool rrosOK() 		{ return ros::ok(); 	}

double rrosTimeNow()	{
	return ros::Time::now().toSec();
}

void rrosLog(char *message, unsigned char type){
	switch(type){
		case 0: { ROS_DEBUG("%s",message); break;}
		case 1: { ROS_INFO("%s",message);  break;}
		case 2: { ROS_WARN("%s",message);  break;}
		case 3: { ROS_ERROR("%s",message); break;}
		case 4: { ROS_FATAL("%s",message); break;}
		default:{ ROS_INFO("%s",message);        }
	}
}

NodeR* rrosInitNode(char *name){
	int argc = 0;
	ros::init(argc, NULL, name);
	return new NodeR();
}
