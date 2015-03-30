#include <ros/ros.h>
#include <ros/package.h>
#include <std_msgs/String.h>
#include <topic_tools/shape_shifter.h>

#include "rosR.h"

char* rrosGetParamType		(NodeR* handle, char* param);

bool rrosGetParamBoolean	(NodeR* handle, char* param);
int rrosGetParamInteger		(NodeR* handle, char* param);
double rrosGetParamDouble	(NodeR* handle, char* param);
char* rrosGetParamString	(NodeR*  handle, char* param);

void rrosSetParamBoolean	(NodeR* handle, char* param, bool val);
void rrosSetParamInteger	(NodeR* handle, char* param, int val);
void rrosSetParamDouble 	(NodeR* handle, char* param, double val);
void rrosSetParamString 	(NodeR* handle, char* param, char* val);

void rrosDeleteParam 		(NodeR* handle, char* param);
