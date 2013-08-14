#!/usr/bin/perl
use lib './lib';
use IntelliHomeNodeMaster;

my $IHOutput = new IH::Interfaces::Terminal;
my $DB = IH::DB->connect("./config/kiokudb.yml");

