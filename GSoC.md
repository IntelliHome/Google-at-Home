#Google Summer of Code

For the GSoC 2014 (Google Summer of Code) we have quite a lot of tasks to be yet done, as said the project is young and there are a lot of prototyping functions that needs to be properly implemented and lot of core functionalities yet to be fully developed.
This brings to you the decision of what you might want to do, here few ideas:

* you could implement new functions like the interface to *Google Now*(this requires a bit of reverse engineering) - **Difficulty:** *medium*
* the network auto-configurator (probing the configurations from the master or everything else can be discussed) - **Difficulty:** *easy* this means that can't be the only task
* database design: it's a very important part, it regards also user, plugin and nodes interfaces;for now we are working with "Tokens" objects, but we are going to document it soon,  you are free to came up with something other idea - **Difficulty:** *medium*
* Agents offline routines: RPC calls to nodes should be supported and also emergency situations where the nodes are detached from node - **Difficulty:** *medium*
* Video surveillance and alarm: should support webcams and alarm leveraging the OpenCV library see [https://metacpan.org/pod/Image::ObjectDetect](Image::ObjectDetect), or if you want to hit the hard road have also a look at [https://metacpan.org/pod/Cv::More](Cv::More) , [https://metacpan.org/pod/Cv](Cv) -**Difficulty:** *medium/high*
* Write Display interface: Developing a set of modules that can handle different situation where the output should be a monitor (or a TV) - **Difficulty:** *medium/tedious*
