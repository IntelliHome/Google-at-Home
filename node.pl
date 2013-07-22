#!/usr/bin/perl
use lib './lib';
use IntelliHomeNode;
use AnyEvent;
use IH::Interfaces::Terminal;
my $IHOutput=new IH::Interfaces::Terminal;

$IHOutput->print("Node started");

my $Sox= new IH::Recorder::Sox;

$Sox->start();

while (sleep 1){
	$IHOutput->info(" Sox started? ");

}