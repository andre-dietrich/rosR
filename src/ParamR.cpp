#include "ParamR.h"

char* rrosGetParamType(NodeR* handle, char* param){
	bool 		val_b;
	int 		val_i;
	double 		val_d;
	std::string val_s;

	if(handle->getHandle()->getParam(param, val_b))		return "logical";
	else if(handle->getHandle()->getParam(param, val_d))	return "double";
	else if(handle->getHandle()->getParam(param, val_i))	return "integer";
	else if(handle->getHandle()->getParam(param, val_s))	return "character";
	return "NULL";
}

bool rrosGetParamBoolean(NodeR* handle, char* param){
	bool val;
	handle->getHandle()->getParam(param, val);

	return val;
}
int rrosGetParamInteger(NodeR* handle, char* param){
	int val;
	handle->getHandle()->getParam(param, val);

	return val;
}
double rrosGetParamDouble(NodeR* handle, char* param){
	double val;
	handle->getHandle()->getParam(param, val);

	return val;
}
char* rrosGetParamString(NodeR* handle, char* param){
	std::string val;
	handle->getHandle()->getParam(param, val);

	return const_cast<char*>(val.c_str());
}


void rrosSetParamBoolean(NodeR* handle, char* param, bool val){
	handle->getHandle()->setParam(param, val);
}
void rrosSetParamInteger(NodeR* handle, char* param, int val){
	handle->getHandle()->setParam(param, val);
}
void rrosSetParamDouble (NodeR* handle, char* param, double val){
	handle->getHandle()->setParam(param, val);
}
void rrosSetParamString (NodeR* handle, char* param, char* val){
	std::string val_s = val;
	handle->getHandle()->setParam(param, val_s);
}
void rrosDeleteParam (NodeR* handle, char* param){
	handle->getHandle()->deleteParam(param);
}
