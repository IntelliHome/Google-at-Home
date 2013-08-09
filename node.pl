#!/usr/bin/perl
use lib './lib';
use IntelliHomeNode;    #Load node library set
use Data::Dumper;

my $IHOutput = new IH::Interfaces::Terminal;    #set up output (debug)
my $Config =
    new IH::Config( Dirs => ['./config'] );     #specify where yaml file are
$Config->read();    # Read and load yaml configuration

my $MasterNode = IH::Node->new( Config => $Config )->selectFromType("master");

my $Connector = new IH::Connector( Node => $MasterNode )
    ; #set up a connector and supply the config file (For auto select of nodes)

$IHOutput->info("IntelliHome : Node started");
$IHOutput->info(
    "Bringing up sox and sending recordings to " . $MasterNode->Host );

my $Sox = new IH::Workers::Sox;    #set up a sox process
my $Monitor =
    new IH::Monitor( Process => $Sox ); # an anyevent monitor for file changes
$Sox->start();

my $WorkerOnEvent =
    new IH::Event( Connector => $Connector );    # Prepare the remote worker
$Monitor->worker($WorkerOnEvent);    #Set the worker on the monitor
$Monitor->launch();                  #Launches the monitor

my $me = IH::Node->new( Config => $Config )->selectFromType("node");
my $Connector = new IH::Connector( Config => $Config, Node => $me )
    ; #Config parameter is optional, only needed if you wanna send broadcast messages
$Connector->Worker( new IH::Workers::ListenNode );
$Connector->listen();
