#include <ros/ros.h>
#include <ros/package.h>
#include <std_msgs/String.h>
#include <topic_tools/shape_shifter.h>
#include <rosbag/bag.h>
#include <rosbag/view.h>
#include <boost/foreach.hpp>

#include "SubscribeR.h"

typedef struct{
	double time_stamp;
	std::string topic;
	std::string datatype;
	boost::shared_array<uint8_t> ui8Buffer;
	IStreamR *isStream;
} BagMessage;

std::vector<BagMessage>* rrosBagRead(const char *filename, std::vector<std::string> *topics, unsigned int max_size=-1);
