# rosR

## Overview

This package provides an simple interface of standard ros-functionalities for the programming
language R. We hope that it might be useful to make the R capabilities for statistical
analyses and visualization also usable for the robotic community. In contrast to other language
implementations, such as rospy, rosjava, etc. this is not a pure R implementation, it is a
mixture of pure R, SWIG generated functions, and system commands. This combination was required
to overcome some limitations of R, such as single threaded, lacking support for sockets and
handling of raw streams. Nevertheless, this package can be used to define and use typical ROS
publishers and subscribers in R, messages are automatically and online generated from the
definition files, and it integrates the possibility to read and therefore analyse bag-files in
R. We will explain this in more detail within the next sections.

See also rosR_demos.

## NOTE 64bit & 32bit

This version runs NOW on 64bit as well as on 32bit systems.The master branch is the 64bit version. If you
want to use rosR on a 32bit system, checkout the branch 32bit.

## Installation

We divided this section into two parts. For those who come from the ROS side, it will be
probably easy to install and to use this packet (of course they will probably have to cope with
the R-code). Coming from the R side with no experience about ROS, it will be hard to install
and run this package.

### ROS-Side

If you have already some expertise on working with ROS, then you can install rosR just like any
ordinary ros-package. Three additional dependencies are required before you can compile it:

- Swig2.0 is required for interfacing C code, and only swig2.0 can generate appropriate code
  for R.

  ``` bash
  $ sudo apt-get install swig2.0
  ```

- The second part is an R base installation

  ``` bash
  $ sudo apt-get install r-base
  ```

- r-cran-rcpp includes all required C source to develop R packages
  ``` bash
  $ sudo apt-get install r-cran-rcpp
  ```

Afterwards compile this package ... That's all folks!

### R-Side

Within this subsection we will describe all steps that are required to install ros-indigo under
an Ubuntu 14.04 32-bit (with long time support) and then our extension for the R-programming
language (especially for users with totally no ROS experience). The first steps were taken from
the manual (http://www.ros.org/wiki/indigo/Installation/Ubuntu) and we guess, you already have
installed Ubuntu on your PC.

todo




## Publish Subscribe

### R–Publisher

Defining a publisher in R is nearly as simple as in Python. First of all you will have to load
this package into your R environment, what can be done with the following command:

``` R
> source(paste(system("rospack find rosR",intern=T),"/lib/ros.R",sep=""),chdir=T)
```

This looks a bit complex, but have trust, this is the only complex command that is required.
We did not develop a package that can be directly installed in R but more a ros package and
therefore it can be somewhere on your systems, as ros packages do it normaly. Therefore the
commandline program rospack is involved to find the location of your rosR installation. But
thats all, now you can use all of our ros-functions in R.

As in most programs you start with the initialization of your new ros node and so we do:

``` R
> ros.Init("R_node")
```

And the new node appears... Let us now generate the publisher:

``` R
> publisher <- ros.Publisher("chatter", "std_msgs/String")
```

Simply call ros.Publisher with the new topic, in our case “chatter”, and the message type
that is transmitted “std_msgs/String”. In the same way it is also possible to define a new
message:

``` R
> message <- ros.Message("std_msgs/String")
```

Messages in our case are always defined as list, that may include further list. So it is
possible to set and get messages values in a similar war, as you know you know it from other
ROS language implementations:

``` R
> message$data <- "hello world"
```

Now we can pass this message to the publisher as follows:

``` R
> ros.WriteMessage(publisher, message)
```

And that was all ... cange the content of your message and republish it:

``` R
> message$data <- "hello world"
```

Have look at some complete examples in folder nodes/test/publisher.R

### R-Subscriber

Creating a subscriber is as simple creating a publisher. At first you have to load the
package, initialize the node and then create the subscriber:

``` R
> source(paste(system("rospack find rosR",intern=T),"/lib/ros.R",sep=""),chdir=T)
> ros.Init("R_node2")
> subscriber <- ros.Subscriber("chatter", "std_msgs/String")
```

As mentioned before, R is single threaded, and calling callback functions is nearly not
possible. To circumvent this tiny drawback, you have to poll, if a new messages was
received or not. Therefore, you have to call:

``` R
> ros.SpinOnce()
NULL
```

to fill the subscriber with possibly new messages. The receipt of a new message can than
be identified by calling the following method:

``` R
> ros.SubscriberHasNewMessage(subscriber)
[1] TRUE
```

This function call will return TRUE if a new message was received otherwise FALSE. If a
new message was received, this can simply be read with:

``` R
> message <- ros.ReadMessage(subscriber)
> print(message$data)
[1] hello world
```

Check out the examples in folder rosR/nodes.

### Messages

The subscriber generates automatically the correct message format. If you publish a message
it is recommended to use function:

``` R
> msg <- ros.Message("std_msgs/String")
```

If you want to get a message of another format, like for example a laserscan, you wil get
the following result:

``` R
> msg <- ros.Message("sensor_msgs/LaserScan")
```

A message in this case is always a composition of lists, therefor single elements are accessed
with "$". Thus, the structure of a message is quite similar to the structures in other languages,
but instead of a point, you have to use a dollar. Changing and reading the header sequence would
than be done as follows:

``` R
> print(msg$header$seq)
[[1]]
integer(0)
> msg$header$seq <- 100
> print(msg$header$seq)
[1] 100
```

The handling of arrays is a bit tricky, because in the background these are handled as C
structures std::vector. Thus, the size of our new LaserScan is currently 0:

```
> length(msg$ranges)
[1] 0
```

and you can add new elements and read these values in the normal manner:

``` R
> append(msg$ranges, c(1,2,3,4,5,6,7))
> length(msg$ranges)
[1] 7
> msg$ranges[2:4]
[1] 2 3 4
> msg$ranges[2:4] <- c(4,3,2)
> msg$ranges
[1] 1 4 3 2 5 6 7
```

But calling functions like sum(msg$ranges) or median(msg$ranges) will not work, unless you define
it in file lib/std_vector.R, or you call:

``` R
> sum(scan$ranges[1:7])
[1] 28
> median(scan$ranges[1:7])
[1] 4
```

This generates a copy of the structures within the std::vector and returns a R vector:

``` R
> typeof(msg$ranges)
[1] "S4"
> typeof(msg$ranges[1:7])
[1] "double"
```

Otherwise it would slow down the conversion of messages, just think of a camera image with 800x600
pixels with 24bits ... The handling of std::vectors in R is defined in lib/std_vector.R you are free
to add new functionality ...

## Other Functions

### Bag-Files

At the moment it is only possible to load bagfiles into R. Use therefore the following function:

``` R
> bag <- ros.BagRead(file, c("topic_1", "topic_2", ..., "topic_n"))
```

You will receive a list, containing the messages, the timestamps, topics, and datatypes of every
message:

``` R
> bag$topic[2]
> bag$message[2]$... # handled in the same way, as a normal message
> bag$datatype[2]
```

### Parameter-Server

todo

### Misc

There is also other functionality defined in src/ros.cpp and lib/ros.R like:

``` R
> ros.TimeNow()
> ros.Info("info")
> ros.Debug("...")
> ros.Error("...")
> ros.Warn("...")
```

## Contact

| André Dietrich |                                           |
| -------------- | ----------------------------------------- |
| web:           | http://eos.cs.ovgu.de/crew/dietrich/      |
| eMail:         | dietrich@ivs.cs.uni-magdeburg.de          |
