#!/usr/bin/perl
use lib './lib';
use IntelliHomeNodeMaster;
use KiokuDB::Backend::Files;

use Cwd;
my $DB=IH::DB->connect("./config/kiokudb.yml");


my $IHOutput = new IH::Interfaces::Terminal;

 
$IHOutput->info("IntelliHome : Node master started");
$IHOutput->info("Bringing up sockets (not secured, i assume you have vpn on your network)");

my $Config= new IH::Config( Dirs=> [ './config']); #specify where yaml file are
$Config->read(); # Read and load yaml configuration

my $Delegate=new IH::Delegate;
my $Connector= new IH::Connector(Config=>$Config,Host=>"localhost",Port=>23457);
$Connector->Worker($Delegate);
#$Connector->listen();

$Connector->broadcastMessage("node","test");