#include <ros/ros.h>
#include <ros/package.h>
#include <std_msgs/String.h>
#include <topic_tools/shape_shifter.h>


#ifndef ROSR_H
#define ROSR_H

//////////////////////////////////////////////////////////////////////////////////////////////////////////
class NodeR {
public:
	NodeR()				{ handle = new ros::NodeHandle; };
	ros::NodeHandle* getHandle()	{ return handle; 		};
public:
	ros::NodeHandle *handle;
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////
struct StreamR
{
	inline uint8_t* getData() { return data_; }

	uint8_t* advance(int32_t len){
		uint8_t* old_data = data_;
		data_ += len;
		return old_data;
	}
	inline int32_t getLength() { return (int32_t)(end_ - data_); }
protected:
	StreamR(uint8_t* _data, uint32_t _count) : data_(_data) , end_(_data + _count)
	{}
private:
	uint8_t* data_;
	uint8_t* end_;
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////
NodeR* rrosInitNode(char *name);

void rrosSpinOnce();
void rrosSpin();
bool rrosOK();
double rrosTimeNow();

void rrosLog(char *message, unsigned char type);

#endif //ROSR_H
