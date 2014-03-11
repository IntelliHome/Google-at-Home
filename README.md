#Google@Home

***##########################################################***

**ATTENTION! This project is not an official Google Project**

***##########################################################***

Do you like **Google** services? Would you like to bring them at home too? So are we, so this is why we started the deployment of this 
personal project. *Google@Home* aim is to let control your home in your own way that could be with android device or for example your voice, 
with the feature of an easy installation on every kind of device that have GPIO inteface and could run Linux.

Would be great to fuse the Google Now functions in your domotic control of the house: the goal is to speak to your home to make google 
searches, use google now capability and open doors, gates and shutter at the same time.

##Development status

Really, really prototype.

CI Status: [![Build Status](https://travis-ci.org/mudler/Google-at-Home.png?branch=master)](https://travis-ci.org/mudler/Google-at-Home)

Some things works, others not, that's because it's currently in development so doesn't expect to run something useful now, code is also ugly 
and obscure in some parts.
For now you can setup some agents and a master: you speak at the microphone at an agent and the master compute the answer (currently only for 
testing purpose and mic calibration, defaults to replay what he understood with Google TTS).

##Structure
There are 2 kind of nodes: 

* masters, 
* agents or basics nodes. 

A basic node can either be an agent or a master. 

The master takes the requests of agent's nodes, process them in a unique interface and send a reply back, so you will talk to the same Entity 
but you can ask things in parallel in different places on the house/infrastructure.
The Agents can be a PC or an embedded device and we plan to give also a display interface.


##Install

###Configurations
For now, we use SoX for recording on the mic so files are split up by silence (avoiding storage leaks) you have to calibrate properly those 
params.
[Coming Soon]


###Installing dependencies

You can install all deps typing ```cpanm --installdeps .``` (user install)
If you want to have the dependencies avaible system wide run the command as root ```sudo cpanm --installdeps .```

The nodes also needs ```mplayer``` and ```sox``` installed in the box.
And also the master needs the proper database installed and configured.


###Setup

You don't need to install the software, you can just clone this repository and launch 
```intellihome-master``` or ```intellihome-node```.
If you wish to install:

```
perl Makefile.PL      # optionally "perl Makefile.PL verbose"
make
make test             # optionally set TEST_VERBOSE=1
sudo make install     # only if you want main modules installed in your libpath
```

###Quick Start

You wanna just try out? fire up your terminal, clone the repository and launch :

```
git clone https://github.com/mudler/Google-at-Home.git
cd Google-at-Home
cpanm --installdeps .
./intellihome-master
```

and in another terminal:

```
./intellihome-node
```

Now your PC will work both as master and node(default configuration). The plugin system is working, and the database setup it's WiP.


```intellihome-master``` and ```intellihome-node``` in two diff

##Todo

* ~~Making a wrapper to linux gpio functionality~~
* ~~Make the node communicate~~
* ~~Delivering functions on a master node~~
* ~~Master node accept and respond to requests~~
* ~~Speech interface thru google~~
* ~~SpeechToText thru google~~
* Auto-Calibration of mic, or an aided one
* *Google Now* functionality interface
* Ideas for a better database schema to collect and display informations
* Write Display interface
* Really, really clean the code
* Agents offline routines
* Video surveillance and alarm
* Simple majordomo interface with a personality (did you remember Jarvis?:P)
* Write an api so to open the possibility to build an Android app or a web interface

***

##Special: GSoC

Have a look at [GSoC](GSoC.md) to see what are the proposed tasks

***
##Notes

We need to buy a raspberryPi but we are testing our work on a FOXG20 board. But the code is written to be portable so we don't think things 
works really different.
Another thing, this project is strictly correlated with our lifes, that's because we are making our home with that: let's consider us first 
alfa-proto-beta-testers :)

***
##Contact

Suggestions, pull request or contributors, Bugs report, everything is well accepted.
E-Mail: mudler@dark-lab.net, skullbocks@dark-lab.net

IRC: irc.perl.org , #Google-at-Home

***

Everything is released under GPLv3 