#!/usr/bin/perl
use lib './lib';
use IntelliHomeNodeMaster;
 my $IHOutput = new IH::Interfaces::Terminal;

 
$IHOutput->info("IntelliHome : Node master started");
$IHOutput->info("Bringing up sockets (non secured, i assume you have vpn on your network)");
my $Delegate=new IH::Delegate;
my $Connector= new IH::Connector;
$Connector->Worker($Delegate);
$Connector->listen();
