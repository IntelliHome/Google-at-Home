#!/usr/bin/perl
use lib './lib';
use IntelliHomeNode; #Load node library set
use Data::Dumper;

my $IHOutput = new IH::Interfaces::Terminal; #set up output (debug)
my $Config= new IH::Config( Dirs=> [ './config']); #specify where yaml file are
$Config->read(); # Read and load yaml configuration
my $Connector=new IH::Connector(Config => $Config); #set up a connector and supply the config file (For auto select of nodes)
$Connector->selectFromType("master"); #Select the last master node (there will be one for now)
$IHOutput->info("IntelliHome : Node started");
$IHOutput->info("Bringing up sox and sending recordings to ".$Connector->Host);

my $Sox = new IH::Recorder::Sox; #set up a sox process
my $Monitor = new IH::Monitor( Process => $Sox ); # an anyevent monitor for file changes
$Sox->start(); 

my $WorkerOnEvent = new IH::Event(Connector=> $Connector); # Prepare the remote worker
$Monitor->worker($WorkerOnEvent); #Set the worker on the monitor
$Monitor->launch(); #Launches the monitor

#Now just a loop is necessary, but will cycle here for debug purposes
while ( sleep 1 ) {

    # $IHOutput->info( " Sox status " . $Sox->is_running() );
    # $IHOutput->info( " Monitor is_running " . $Monitor->is_running() );
    # $IHOutput->info( " Monitor is_detached " . $Monitor->is_detached() );
}
