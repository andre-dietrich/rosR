/* rosR.i */
%module rosR
%{
	#include "rosR.h"
	#include "SubscribeR.h"
	#include "PublisheR.h"
	#include "ParamR.h"
	#include "BagR.h"
%}

%include cpointer.i
%include "std_vector.i"
%include "std_string.i"

// Instantiate templates used by example
namespace std {
	%template(vector_int8) 		vector<signed char>;
	%template(vector_uint8) 	vector<unsigned char>;
	%template(vector_int16) 	vector<signed short>;
	%template(vector_uint16) 	vector<unsigned short>;
	%template(vector_int32) 	vector<signed int>;
	%template(vector_uint32) 	vector<unsigned int>;
	%template(vector_int64) 	vector<signed long>;
	%template(vector_uint64) 	vector<unsigned long>;
	%template(vector_float32) 	vector<float>;
	%template(vector_float64) 	vector<double>;
	%template(vector_string) 	vector<string>;
	%template(vector_bag) 		vector<BagMessage>;
}

%include "rosR.h"
%include "SubscribeR.h"
%include "PublisheR.h"
%include "ParamR.h"
%include "BagR.h"
