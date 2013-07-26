#!/usr/bin/perl
use lib './lib';
use IntelliHomeNode;

my $IHOutput = new IH::Interfaces::Terminal;

$IHOutput->info("IntelliHome : Node started");
$IHOutput->info("Bringing up sox");

my $Sox = new IH::Recorder::Sox;
my $Monitor = new IH::Monitor( Process => $Sox );
$Sox->start();
my $WorkerOnEvent = new IH::Event;
$WorkerOnEvent->Connector->connect();

$Monitor->worker($WorkerOnEvent);
$Monitor->launch();
while ( sleep 1 ) {

    # $IHOutput->info( " Sox status " . $Sox->is_running() );
    # $IHOutput->info( " Monitor is_running " . $Monitor->is_running() );
    # $IHOutput->info( " Monitor is_detached " . $Monitor->is_detached() );
}
