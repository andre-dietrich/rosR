#include "SubscribeR.h"

SubscribeR* rrosSubscriber(	NodeR* handle,
				const char* topic,
				const char* type,
				const char* msg_def,
				const char* msg_md5) {
	return new SubscribeR(handle, topic, type, msg_def, msg_md5);
}

bool rrosSubscriberHasNewMsg(SubscribeR* subscriber){
	return subscriber->hasNewMessage(); }
bool rrosSubscriberHasAnyMsg(SubscribeR* subscriber){
	return subscriber->hasAnyMessage(); }

const char* rrosSubscriberGetPublisher(SubscribeR* subscriber){
	return subscriber->getPublisher(); }
const char* rrosSubscriberGetMessageType(SubscribeR* subscriber){
	return subscriber->getMessageType(); }
const char* rrosSubscriberGetMessageMD5(SubscribeR* subscriber){
	return subscriber->getMessageMD5(); }
const char* rrosSubscriberGetMessageDefinition(SubscribeR* subscriber){
	return subscriber->getMessageDefinition(); }


/***************************************************************/
IStreamR* rrosSubscriberGetMessageStream(SubscribeR* subscriber){
	return subscriber->getMessageStream();
}
bool rros_stream_read_bool(IStreamR *s){
	unsigned char val;
	s->next(val);
	return val; }
signed char rros_stream_read_int8(IStreamR *s){
	signed char val;
	s->next(val);
	return val; }
unsigned char rros_stream_read_uint8(IStreamR *s){
	unsigned char val;
	s->next(val);
	return val; }
signed short rros_stream_read_int16(IStreamR *s){
	signed short val;
	s->next(val);
	return val; }
unsigned short rros_stream_read_uint16(IStreamR *s){
	unsigned short val;
	s->next(val);
	return val; }
signed int rros_stream_read_int32(IStreamR *s){
	signed int val;
	s->next(val);
	return val; }
unsigned int rros_stream_read_uint32(IStreamR *s){
	unsigned int val;
	s->next(val);
	return val; }
signed long rros_stream_read_int64(IStreamR *s){
	signed long val;
	s->next(val);
	return val; }
unsigned long rros_stream_read_uint64(IStreamR *s){
	unsigned long val;
	s->next(val);
	return val; }
float rros_stream_read_float32(IStreamR *s){
	float val;
	s->next(val);
	return val; }
double rros_stream_read_float64(IStreamR *s){
	double val;
	s->next(val);
	return val; }
char* rros_stream_read_string(IStreamR *s){
	std::string val;
	s->next(val);
	return const_cast<char*>(val.c_str()); }

/*--------------------------------------------------------------------*/
std::vector<signed char>* rros_stream_read_int8_array(IStreamR *s, unsigned int size){
	std::vector<signed char> *val = new std::vector<signed char>(size);
	s->next(*val);
	return val; }
std::vector<unsigned char>* rros_stream_read_uint8_array(IStreamR *s, unsigned int size) {
	std::vector<unsigned char> *val = new std::vector<unsigned char>(size);
	s->next(*val);
	return val; }
std::vector<signed short>* rros_stream_read_int16_array(IStreamR *s, unsigned int size){
	std::vector<signed short> *val = new std::vector<signed short>(size);
	s->next(*val);
	return val; }
std::vector<unsigned short>* rros_stream_read_uint16_array(IStreamR *s, unsigned int size){
	std::vector<unsigned short> *val = new std::vector<unsigned short>(size);
	s->next(*val);
	return val; }
std::vector<signed int>* rros_stream_read_int32_array(IStreamR *s, unsigned int size){
	std::vector<signed int> *val = new std::vector<signed int>(size);
	s->next(*val);
	return val; }
std::vector<unsigned int>* rros_stream_read_uint32_array(IStreamR *s, unsigned int size){
	std::vector<unsigned int> *val = new std::vector<unsigned int>(size);
	s->next(*val);
	return val; }
std::vector<signed long>* rros_stream_read_int64_array(IStreamR *s, unsigned int size){
	std::vector<signed long> *val = new std::vector<signed long>(size);
	s->next(*val);
	return val; }
std::vector<unsigned long>* rros_stream_read_uint64_array(IStreamR *s, unsigned int size){
	std::vector<unsigned long> *val = new std::vector<unsigned long>(size);
	s->next(*val);
	return val; }
std::vector<float>* rros_stream_read_float32_array(IStreamR *s, unsigned int size){
	std::vector<float> *val = new std::vector<float>(size);
	s->next(*val);
	return val; }
std::vector<double>* rros_stream_read_float64_array(IStreamR *s, unsigned int size){
	std::vector<double> *val = new std::vector<double>(size);
	s->next(*val);
	return val; }
std::vector<std::string>* rros_stream_read_string_array(IStreamR *s, unsigned int size=0){
	std::vector<std::string> *val = new std::vector<std::string>(size);
	s->next(*val);
	return val; }

