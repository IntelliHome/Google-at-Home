#Google@Home [![Build Status](https://travis-ci.org/mudler/Google-at-Home.png?branch=master)](https://travis-ci.org/mudler/Google-at-Home)

***##########################################################***

**ATTENTION! This project is not an official Google Project**

***##########################################################***

Do you like **Google** services? Would you like to bring them at home too? So are we, so this is why we started the deployment of this project. *Google@Home* aim is to let control your home in your own way that could be with android device or for example your voice, with the feature of an easy installation on every kind of embedded device that have GPIO inteface and could run *GNU/Linux*.

Would be great to fuse the Google Now functions in your domotic control of the house: the goal is to speak to your home to make google searches, use google now capability and open doors, gates and shutter at the same time.

Picture that:

*Let's suppose that we are an electronic/computer enthusiast that want to enhance our home with some domotics control, but in non-expansive way. Then probably our choise would be to take some RaspberryPi and relay boards, then link the relayboards to the interested points (shutters, lights, dim lights, etc...) we plan to control: maybe a raspberry for floor it's enough, maybe not, but that doesn't matter. Then we install G@H and we can control those points using the voice, web interface, or even mobile device.*

It's just easy as to say *"open shutter"* or a *touch* on your mobile phone.

## IntelliHome library

![IntelliHome Logo](http://www.mudler.pm/img/intellihome_logo.png "IntelliHome Logo")

IntelliHome is a set of Perl libraries to handle all the domotic needs, like dispatching information on nodes, saving configurations, plugin handling and much more that bound together with google services form Google-at-Home, a complete, easy and affordable solution for your home control.

##Development status

For now you can setup some agents and a master: you speak at the microphone at an agent and the master compute the answer.

Really, really prototype.

Some things works, others don't, that's because it's currently in development so doesn't expect to run something successfully every time now, code is also ugly
and obscure in some parts.

**Until we reach a proper state of functionalities, won't be released a major release.**

Some things must be properly redesigned yet.

##Structure
There are 2 kind of nodes:

* masters,
* agents or basics nodes.

A basic node can either be an agent or a master.

The master takes the requests of agent's nodes, process them in a unique interface and send a reply back, so you will talk to the same Entity but you can ask things in parallel in different places on the house/infrastructure.
The Agents can be a PC or an embedded device and we plan to give also a display interface.

##Install

###Configurations
For now, we use SoX for recording on the mic so files are split up by silence (avoiding storage leaks) you have to calibrate properly those params (a proper wiki page will be prepared soon).

#### config/nodes.yaml

For testing the default configuration are enough: they are configured so the master is also the node.
You can set up the audio device by setting *HW*  according to what ```aplay -l``` gives you (need to find your recording device looking at the ```card,device``` pair).

#### config/database.yaml

For testing the default configuration are enough.
This file represent the configuration of the database backend, the *language* can be set there.

###Installing dependencies

You can install all deps typing ```cpanm --installdeps .``` (user install)
If you want to have the dependencies avaible system wide run the command as root ```sudo cpanm --installdeps .```

### Software Dependencies

The nodes needs only ```sox``` installed in the box as external dependency.
The master needs the proper database installed and configured:

For now it's implemented the MongoDB Backend, this requires mongodb installed *only in the box of the master node*.

**This repository ships out a default configuration of master and node on the same pc.**

###Full Setup

You don't need to install the software, you can just clone this repository and launch
```intellihome-master``` or ```intellihome-node```.
If you wish to install:

```
perl Makefile.PL      # optionally "perl Makefile.PL verbose"
make
make test             # optionally set TEST_VERBOSE=1
sudo make install     # only if you want main modules installed in your libpath
```

####Database

In the ```ex/``` directory there is a backup of a pre-configured database, if you have a clean install just do:

```mongorestore ex/dump```.

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

####Database

In the ```ex/``` directory there is a backup of a pre-configured database, if you have a clean install just do
```mongorestore ex/dump```.

##Plugin

The plugin systems allow to extend the system by triggers that can be invoked by voice.
Currently plugins are WiP so api can change and most of them are drafts:

* [IntelliHome::Plugin::Wikipedia](https://github.com/mudler/IntelliHome-Plugin-Wikipedia) - Allow to search in wikipedia with the *"wikipedia <term>"* trigger
* [IntelliHome::Plugin::Hailo](https://github.com/mudler/IntelliHome-Plugin-Hailo) - Makes your computer speak with MegaHAL! - just for fun :)
* ...

##Todo

- [x] Making a wrapper to linux gpio functionality
- [x] Make the node communicate
- [x] Delivering functions on a master node
- [x] Master node accept and respond to requests
- [x] Speech interface thru google
- [x] SpeechToText thru google
- [x] Ideas for a better database schema to collect and display informations
- [x] Auto-Calibration of mic ~~or an aided one~~
- [ ] Write an api so to open the possibility to build an Android app or a web interface
- [ ] Relay control plugin
- [ ] *Google Now* functionality interface
- [ ] Write Display interface
- [ ] Agents offline routines
- [ ] Video surveillance and alarm
- [ ] Simple majordomo interface with a personality (did you remember Jarvis?:P)

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