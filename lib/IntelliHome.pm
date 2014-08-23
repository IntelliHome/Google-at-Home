package IntelliHome;

our $VERSION = "0.002";

1;
__END__
=head1 Google@Home

B<I<##########################################################>>

B<ATTENTION! This project is not an official Google Project>

B<I<##########################################################>>

Do you like B<Google> services? Would you like to bring them at home
too? So are we, so this is why we started the deployment of this
project. I<Google@Home> aim is to let control your home in your own way
that could be with android device or for example your voice, with the
feature of an easy installation on every kind of embedded device that
have GPIO inteface and could run I<GNU/Linux>.

Would be great to fuse the Google Now functions in your domotic control
of the house: the goal is to speak to your home to make google
searches, use google now capability and open doors, gates and shutter
at the same time.

Picture that:

I<Let's suppose that we are an electronic/computer enthusiast that want
to enhance our home with some domotics control, but in non-expansive
way. Then probably our choise would be to take some RaspberryPi and
relay boards, then link the relayboards to the interested points
(shutters, lights, dim lights, etc...) we plan to control: maybe a
raspberry for floor it's enough, maybe not, but that doesn't matter.
Then we install G@H and we can control those points using the voice,
web interface, or even mobile device.>

It's just easy as to say I<"open shutter"> or a I<touch> on your mobile
phone.

=head2 IntelliHome library

IntelliHome is a set of Perl libraries to handle all the domotic needs,
like dispatching information on nodes, saving configurations, plugin
handling and much more that bound together with google services form
Google-at-Home, a complete, easy and affordable solution for your home
control.

=head2 Development status

For now you can setup some agents and a master: you speak at the
microphone at an agent and the master compute the answer.

Really, really prototype.

Some things works, others don't, that's because it's currently in
development so doesn't expect to run something successfully every time
now, code is also ugly and obscure in some parts.

B<Until we reach a proper state of functionalities, won't be released a
major release.>

Some things must be properly redesigned yet.

=head2 Structure

There are 2 kind of nodes:

=over

=item * masters,

=item * agents or basics nodes.

=back

A basic node can either be an agent or a master.

The master takes the requests of agent's nodes, process them in a
unique interface and send a reply back, so you will talk to the same
Entity but you can ask things in parallel in different places on the
house/infrastructure. The Agents can be a PC or an embedded device and
we plan to give also a display interface.

=head2 Install

=head2 Configurations

For now, we use SoX for recording on the mic so files are split up by
silence (avoiding storage leaks) you have to calibrate properly those
params (a proper wiki page will be prepared soon).

=head2 config/nodes.yaml

For testing the default configuration are enough: they are configured
so the master is also the node. You can set up the audio device by
setting I<HW> according to what C<aplay -l> gives you (need to find
your recording device looking at the C<card,device> pair).

=head2 config/database.yaml

For testing the default configuration are enough. This file represent
the configuration of the database backend, the I<language> can be set
there.

=head2 Installing dependencies

You can install all deps typing C<cpanm --installdeps .> (user install)
If you want to have the dependencies avaible system wide run the
command as root C<sudo cpanm --installdeps .>

=head2 Software Dependencies

The nodes needs only C<sox> installed in the box as external
dependency. The master needs the proper database installed and
configured:

For now it's implemented the MongoDB Backend, this requires mongodb
installed I<only in the box of the master node>.

B<This repository ships out a default configuration of master and node
on the same pc.>

=head2 Full Setup

You don't need to install the software, you can just clone this
repository and launch C<intellihome-master> or C<intellihome-node>. If
you wish to install:

 perl Makefile.PL      # optionally "perl Makefile.PL verbose"
 make
 make test             # optionally set TEST_VERBOSE=1
 sudo make install     # only if you want main modules installed in your libpath

=head2 Database

Have a look at L<IntelliHome::Deployer::Schema::SQLite> to deploy the SQL schemas

=head2 Quick Start

You wanna just try out? fire up your terminal, clone the repository and
launch :

 git clone https://github.com/mudler/Google-at-Home.git
 cd Google-at-Home
 cpanm --installdeps .
 ./intellihome-master

and in another terminal:

 ./intellihome-node

Now your PC will work both as master and node(default configuration).
The plugin system is working, and the database setup it's WiP.

=head2 Plugin

The plugin systems allow to extend the system by triggers that can be
invoked by voice. Currently plugins are WiP so api can change and most
of them are drafts:

=over

=item * IntelliHome::Plugin::Wikipedia - Allow to search in wikipedia
with the I<"wikipedia "> trigger

=item * IntelliHome::Plugin::Hailo - Makes your computer speak with
MegaHAL! - just for fun :)

=item * IntelliHome::Plugin::Relay - Allow to command the agents relays

=item * ...

=back

=head2 Android application

The android application its in WiP, if you are interested contributing,
here it is the repository

=head2 Todo

=over

=item * [x] Making a wrapper to linux gpio functionality

=item * [x] Make the node communicate

=item * [x] Delivering functions on a master node

=item * [x] Master node accept and respond to requests

=item * [x] Speech interface thru google

=item * [x] SpeechToText thru google

=item * [x] Ideas for a better database schema to collect and display
informations

=item * [x] Auto-Calibration of mic

=item * [x] Write an api so to open the possibility to build an Android
app or a web interface

=item * [x] Relay control plugin

=item * [ ] I<Google Now> functionality interface

=item * [ ] Write Display interface

=item * [ ] Agents offline routines

=item * [ ] Video surveillance and alarm

=item * [ ] Simple majordomo interface with a personality (did you
remember Jarvis?:P)

=back

----

=head2 Special: GSoC

Have a look at GSoC to see what are the proposed tasks

----

=head2 Notes

We need to buy a raspberryPi but we are testing our work on a FOXG20
board. But the code is written to be portable so we don't think things
works really different. Another thing, this project is strictly
correlated with our lifes, that's because we are making our home with
that: let's consider us first alfa-proto-beta-testers :)

----

=head2 Contact

Suggestions, pull request or contributors, Bugs report, everything is
well accepted. E-Mail: mudler@dark-lab.net, skullbocks@dark-lab.net

IRC: irc.perl.org , #google-at-home

----

Everything is released under GPLv3

=cut
