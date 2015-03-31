#include <ros/ros.h>
#include <ros/package.h>
#include <std_msgs/String.h>
#include <topic_tools/shape_shifter.h>

#include "rosR.h"

#ifndef PUBLISHER_H
#define PUBLISHER_H

struct OStreamR : public StreamR
{
	OStreamR(uint8_t* data, uint32_t count) : StreamR(data, count)
	{}

	template<typename T>
	inline void next(const T& t) {
		ros::serialization::serialize(*this, t);
	}

	template<typename T>
	inline OStreamR& operator<<(const T& t) {
		ros::serialization::serialize(*this, t);
		return *this;
	}
};


class PublisheR {
public:
	PublisheR(NodeR* handle, const char* cTopic, const char* cMsgType, const char* cMsgDefinition, const char* cMsgMD5){

		m_rosPublisher = new ros::Publisher();

		topic_tools::ShapeShifter *ss = new topic_tools::ShapeShifter();
		ss->morph(cMsgMD5, cMsgType, cMsgDefinition, "");
		*m_rosPublisher = ss->advertise(*handle->getHandle(), cTopic, 1);

		m_strMsgType		= cMsgType;
		m_strMsgDefinition	= cMsgDefinition;
		m_strMsgMD5			= cMsgMD5;

		m_iBufferSize = 10000000;

		m_ui8Buffer = new boost::shared_array<uint8_t> (new uint8_t[m_iBufferSize]);
		m_osStream  = new OStreamR(m_ui8Buffer->get(), m_iBufferSize);
	};
	~PublisheR() {
		delete m_rosPublisher;
		delete m_osStream;
	};

	const char* getMessageType() {
		return m_strMsgType.c_str(); 	};
	const char* getMessageDefinition() {
		return m_strMsgDefinition.c_str(); };
	const char* getMessageMD5() {
		return m_strMsgMD5.c_str(); };
	const char* getTopic() {
		return m_rosPublisher->getTopic().c_str(); };

	void publish(){
		topic_tools::ShapeShifter ss;
		ss.morph(m_strMsgMD5, m_strMsgType, m_strMsgDefinition, "");

		if(m_osStream->getLength() != m_iBufferSize){
			m_osStream->advance(-(m_iBufferSize-m_osStream->getLength()));
		}

		ros::serialization::OStream ssStream(m_osStream->getData(), m_osStream->getLength());
		ss.read(ssStream);

		m_rosPublisher->publish(ss);
	}

	OStreamR* getMessageStream(){
		if(m_osStream->getLength() != m_iBufferSize){
			m_osStream->advance(-(m_iBufferSize-m_osStream->getLength()));
		}

		return m_osStream;
	}

private:
	ros::Publisher* m_rosPublisher;
	std::string m_strMsgType;
	std::string m_strMsgDefinition;
	std::string m_strMsgMD5;

	boost::shared_array<uint8_t> *m_ui8Buffer;
	int m_iBufferSize;
	OStreamR *m_osStream;
};


PublisheR* rrosPublisher(	NodeR* handle,
				const char* topic,
				const char* type,
				const char* msg_def,
				const char* msg_md5);

const char* rrosPublisherGetTopic(PublisheR* publisher);
const char* rrosPublisherGetMessageType(PublisheR* publisher);
const char* rrosPublisherGetMessageMD5(PublisheR* publisher);
const char* rrosPublisherGetMessageDefinition(PublisheR* publisher);

void rrosPublish(PublisheR* publisher);

OStreamR* rrosPublisherGetMessageStream(PublisheR *publisher);

void rros_stream_write_bool	(OStreamR *s, bool		val);
void rros_stream_write_int8	(OStreamR *s, signed char	val);
void rros_stream_write_uint8	(OStreamR *s, unsigned char	val);
void rros_stream_write_int16	(OStreamR *s, signed short	val);
void rros_stream_write_uint16	(OStreamR *s, unsigned short	val);
void rros_stream_write_int32	(OStreamR *s, signed int	val);
void rros_stream_write_uint32	(OStreamR *s, unsigned int	val);
void rros_stream_write_int64	(OStreamR *s, signed long long	val);
void rros_stream_write_uint64	(OStreamR *s, unsigned long long	val);
void rros_stream_write_float32	(OStreamR *s, float		val);
void rros_stream_write_float64	(OStreamR *s, double		val);
void rros_stream_write_string	(OStreamR *s, char*		val);

void rros_stream_write_int8_array	(OStreamR *s, std::vector<signed char>*		vec);
void rros_stream_write_uint8_array	(OStreamR *s, std::vector<unsigned char>*	vec);
void rros_stream_write_int16_array	(OStreamR *s, std::vector<signed short>*	vec);
void rros_stream_write_uint16_array	(OStreamR *s, std::vector<unsigned short>*	vec);
void rros_stream_write_int32_array	(OStreamR *s, std::vector<signed int>*		vec);
void rros_stream_write_uint32_array	(OStreamR *s, std::vector<unsigned int>*	vec);
void rros_stream_write_int64_array	(OStreamR *s, std::vector<signed long long>*		vec);
void rros_stream_write_uint64_array	(OStreamR *s, std::vector<unsigned long long>*	vec);
void rros_stream_write_float32_array	(OStreamR *s, std::vector<float>*		vec);
void rros_stream_write_float64_array	(OStreamR *s, std::vector<double>*		vec);
void rros_stream_write_string_array	(OStreamR *s, std::vector<std::string>*		vec);

#endif
