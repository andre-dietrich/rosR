#include "BagR.h"

 std::vector<BagMessage>* rrosBagRead(const char *filename, std::vector<std::string> *topics, unsigned int max_size){

	rosbag::Bag bag;
	bag.open(filename, rosbag::bagmode::Read);

	//std::cerr << filename << std::endl;

	std::vector<BagMessage> *vecMsg = new std::vector<BagMessage>();
	vecMsg->reserve(1000);
	rosbag::View *view;

	if(topics->size() > 0){
		view = new rosbag::View(bag, rosbag::TopicQuery(*topics));
	} else {
		view = new rosbag::View(bag);
	}


	BOOST_FOREACH(rosbag::MessageInstance const m, *view)
	{
		BagMessage *msg = new BagMessage();
		msg->topic = m.getTopic();
		msg->datatype = m.getDataType();
		msg->time_stamp = m.getTime().toSec();

		msg->ui8Buffer = boost::shared_array<uint8_t> (new uint8_t[m.size()]);
		msg->isStream  = new IStreamR(msg->ui8Buffer.get(), m.size());

		m.write(*msg->isStream);

		msg->isStream->advance(-m.size());

		vecMsg->push_back(*msg);

		max_size--;
		if(max_size==0) break;
	}

	bag.close();

	delete view;

	return vecMsg;
}
