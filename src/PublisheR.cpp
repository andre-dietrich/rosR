#include "PublisheR.h"

PublisheR* rrosPublisher(	NodeR* handle,
				const char* topic,
				const char* type,
				const char* msg_def,
				const char* msg_md5) {
	return new PublisheR(handle, topic, type, msg_def, msg_md5);
}

const char* rrosPublisherGetTopic(PublisheR* publisher)			{ return publisher->getTopic(); 		}
const char* rrosPublisherGetMessageType(PublisheR* publisher)		{ return publisher->getMessageType(); 		}
const char* rrosPublisherGetMessageMD5(PublisheR* publisher)		{ return publisher->getMessageMD5(); 		}
const char* rrosPublisherGetMessageDefinition(PublisheR* publisher)	{ return publisher->getMessageDefinition();	}
OStreamR* rrosPublisherGetMessageStream(PublisheR *publisher)		{ return publisher->getMessageStream(); 	}

void rrosPublish(PublisheR* publisher){ publisher->publish(); }

void rros_stream_write_bool	(OStreamR *s, bool		val) { s->next(val); }
void rros_stream_write_int8	(OStreamR *s, signed char	val) { s->next(val); }
void rros_stream_write_uint8	(OStreamR *s, unsigned char	val) { s->next(val); }
void rros_stream_write_int16	(OStreamR *s, signed short	val) { s->next(val); }
void rros_stream_write_uint16	(OStreamR *s, unsigned short	val) { s->next(val); }
void rros_stream_write_int32	(OStreamR *s, signed int	val) { s->next(val); }
void rros_stream_write_uint32	(OStreamR *s, unsigned int	val) { s->next(val); }
void rros_stream_write_int64	(OStreamR *s, signed long long	val) { s->next(val); }
void rros_stream_write_uint64	(OStreamR *s, unsigned long long	val) { s->next(val); }
void rros_stream_write_float32	(OStreamR *s, float		val) { s->next(val); }
void rros_stream_write_float64	(OStreamR *s, double		val) { s->next(val); }
void rros_stream_write_string	(OStreamR *s, char*		val) {
	std::string str = val;
	s->next(str);
}

void rros_stream_write_int8_array	(OStreamR *s, std::vector<signed char>*		vec) { s->next(*vec); }
void rros_stream_write_uint8_array	(OStreamR *s, std::vector<unsigned char>*	vec) { s->next(*vec); }
void rros_stream_write_int16_array	(OStreamR *s, std::vector<signed short>*	vec) { s->next(*vec); }
void rros_stream_write_uint16_array	(OStreamR *s, std::vector<unsigned short>*	vec) { s->next(*vec); }
void rros_stream_write_int32_array	(OStreamR *s, std::vector<signed int>*		vec) { s->next(*vec); }
void rros_stream_write_uint32_array	(OStreamR *s, std::vector<unsigned int>*	vec) { s->next(*vec); }
void rros_stream_write_int64_array	(OStreamR *s, std::vector<signed long long>*	vec) { s->next(*vec); }
void rros_stream_write_uint64_array	(OStreamR *s, std::vector<unsigned long long>*	vec) { s->next(*vec); }
void rros_stream_write_float32_array	(OStreamR *s, std::vector<float>*		vec) { s->next(*vec); }
void rros_stream_write_float64_array	(OStreamR *s, std::vector<double>*		vec) { s->next(*vec); }
void rros_stream_write_string_array	(OStreamR *s, std::vector<std::string>*		vec) { s->next(*vec); }

