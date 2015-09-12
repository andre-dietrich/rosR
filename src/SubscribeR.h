#include <ros/ros.h>
#include <ros/package.h>
#include <std_msgs/String.h>
#include <topic_tools/shape_shifter.h>

#ifndef SUBSCRIBER_H
#define SUBSCRIBER_H

#include "rosR.h"

struct IStreamR : public StreamR
{
	IStreamR(uint8_t* data, uint32_t count) : StreamR(data, count)
	{}

	template<typename T>
	inline void next(T& t) {
		ros::serialization::deserialize(*this, t);
	}

	template<typename T>
	inline IStreamR& operator>>(T& t) {
		ros::serialization::deserialize(*this, t);
		return *this;
	}
};

class SubscribeR {
public:
	SubscribeR(NodeR* handle, const char* cTopic, const char* cMsgType, const char* cMsgDefinition, const char* cMsgMD5){
		m_bNewMessage = false;
		m_bAnyMessage = false;
		m_rosSubscriber = (handle->getHandle())->subscribe(cTopic, 1, &SubscribeR::callback, this);

		m_strMsgType		= cMsgType;
		m_strMsgDefinition	= cMsgDefinition;
		m_strMsgMD5			= cMsgMD5;

		m_iBufferSize = 10000000;

		m_ui8Buffer = new boost::shared_array<uint8_t> (new uint8_t[m_iBufferSize]);
		m_isStream  = new IStreamR(m_ui8Buffer->get(), m_iBufferSize);
	};
	~SubscribeR() {
		delete m_isStream;
		delete m_ui8Buffer;
	};

	void callback(const ros::MessageEvent<topic_tools::ShapeShifter const>& event) {
		m_bNewMessage = true;
		m_bAnyMessage = true;

		m_Event = event;

		// uninitialzed
		if(m_strMsgType.size() == 0){
			m_strMsgType = m_Event.getMessage()->getDataType();
			m_strMsgMD5  = m_Event.getMessage()->getMD5Sum();
			m_strMsgDefinition = m_Event.getMessage()->getMessageDefinition();
		}
	};

	bool hasAnyMessage() { return m_bAnyMessage; };
	bool hasNewMessage() { return m_bNewMessage; };

	const char* getPublisher() {
		return m_Event.getPublisherName().c_str(); 	};
	const char* getMessageType() {
		return m_strMsgType.c_str(); 	};
	const char* getMessageDefinition() {
		return m_strMsgDefinition.c_str(); };
	const char* getMessageMD5() {
		return m_strMsgMD5.c_str(); };

	IStreamR * getMessageStream(){
		m_bNewMessage = false;

		if(m_isStream->getLength() != m_iBufferSize){
			m_isStream->advance(-(m_iBufferSize-m_isStream->getLength()));
		}

		m_Event.getMessage()->write(*m_isStream);
		m_isStream->advance(-m_Event.getMessage()->size());

		return m_isStream;
	};

private:
	bool m_bNewMessage;
	bool m_bAnyMessage;

	ros::Subscriber m_rosSubscriber;
	std::string m_strMsgType;
	std::string m_strMsgDefinition;
	std::string m_strMsgMD5;

	ros::MessageEvent<topic_tools::ShapeShifter const> m_Event;

	boost::shared_array<uint8_t> *m_ui8Buffer;
	int m_iBufferSize;
	IStreamR *m_isStream;
};

SubscribeR* rrosSubscriber(	NodeR* handle,
				const char* topic,
				const char* type,
				const char* msg_def,
				const char* msg_md5);

bool rrosSubscriberHasNewMsg(SubscribeR* subscriber);
bool rrosSubscriberHasAnyMsg(SubscribeR* subscriber);

IStreamR* rrosSubscriberGetMessageStream(SubscribeR* subscriber);

const char* rrosSubscriberGetPublisher(SubscribeR* subscriber);
const char* rrosSubscriberGetMessageType(SubscribeR* subscriber);
const char* rrosSubscriberGetMessageMD5(SubscribeR* subscriber);
const char* rrosSubscriberGetMessageDefinition(SubscribeR* subscriber);

bool		rros_stream_read_bool		(IStreamR *s);
signed char	rros_stream_read_int8		(IStreamR *s);
unsigned char 	rros_stream_read_uint8		(IStreamR *s);
signed short	rros_stream_read_int16		(IStreamR *s);
unsigned short	rros_stream_read_uint16		(IStreamR *s);
signed int	rros_stream_read_int32		(IStreamR *s);
unsigned int	rros_stream_read_uint32		(IStreamR *s);
signed long	rros_stream_read_int64		(IStreamR *s);
unsigned long	rros_stream_read_uint64		(IStreamR *s);
float		rros_stream_read_float32	(IStreamR *s);
double		rros_stream_read_float64	(IStreamR *s);
char*		rros_stream_read_string		(IStreamR *s);

std::vector<signed char>*	rros_stream_read_int8_array	(IStreamR *s, unsigned int size=0);
std::vector<unsigned char>*	rros_stream_read_uint8_array	(IStreamR *s, unsigned int size=0);
std::vector<signed short>*	rros_stream_read_int16_array	(IStreamR *s, unsigned int size=0);
std::vector<unsigned short>*	rros_stream_read_uint16_array	(IStreamR *s, unsigned int size=0);
std::vector<signed int>* 	rros_stream_read_int32_array	(IStreamR *s, unsigned int size=0);
std::vector<unsigned int>*	rros_stream_read_uint32_array	(IStreamR *s, unsigned int size=0);
std::vector<signed long>* 	rros_stream_read_int64_array	(IStreamR *s, unsigned int size=0);
std::vector<unsigned long>*	rros_stream_read_uint64_array	(IStreamR *s, unsigned int size=0);
std::vector<float>* 		rros_stream_read_float32_array	(IStreamR *s, unsigned int size=0);
std::vector<double>* 		rros_stream_read_float64_array	(IStreamR *s, unsigned int size=0);
std::vector<std::string>* 	rros_stream_read_string_array	(IStreamR *s, unsigned int size=0);

#endif
