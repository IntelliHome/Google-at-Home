#!/usr/bin/env perl

use warnings FATAL => 'all';
use strict;

use Test::More;

BEGIN {
	use_ok( $_ ) or BAIL_OUT("$_ failed") for qw|
		IntelliHome
		IntelliHome::Connector
		IntelliHome::RPC::Service::Dummy
		IntelliHome::RPC::Service::Command
		IntelliHome::RPC::Service::Base
		IntelliHome::RPC::Service::Ask
		IntelliHome::RPC::Service::Parse
		IntelliHome::RPC::Service::DB
		IntelliHome::Config
		IntelliHome::IntelliHomeAgent
		IntelliHome::Driver::Analogic
		IntelliHome::Driver::GPIO::Mono
		IntelliHome::Driver::GPIO::Base
		IntelliHome::Driver::GPIO::Dual
		IntelliHome::IntelliHomeNode
		IntelliHome::Interfaces::Interface
		IntelliHome::Interfaces::Terminal
		IntelliHome::Interfaces::Voice
		IntelliHome::Workers::Master::StatusListener
		IntelliHome::Workers::Master::WebUI
		IntelliHome::Workers::Master::RemoteSynth
		IntelliHome::Workers::Master::RPC
		IntelliHome::Workers::Base
		IntelliHome::Workers::Node::Monitor
		IntelliHome::Workers::Node::Event
		IntelliHome::Workers::Node::Sox
		IntelliHome::Workers::Node::MicAdjust
		IntelliHome::Workers::Node::AudioProcess
		IntelliHome::Workers::Agent::CommandProcess
		IntelliHome::Workers::SocketAsync
		IntelliHome::Workers::SocketListener
		IntelliHome::Schema::YAML::Node
		IntelliHome::Schema::Mongo::PluginOption
		IntelliHome::Schema::Mongo::Notification
		IntelliHome::Schema::Mongo::Task
		IntelliHome::Schema::Mongo::Trigger
		IntelliHome::Schema::Mongo::Question
		IntelliHome::Schema::Mongo::Need
		IntelliHome::Schema::Mongo::Token
		IntelliHome::Schema::Mongo::GPIO
		IntelliHome::Schema::Mongo::Node
		IntelliHome::Schema::Mongo::Hypo
		IntelliHome::Schema::SQLite::Schema
		IntelliHome::Schema::SQLite::Schema::Result::UserPlugin
		IntelliHome::Schema::SQLite::Schema::Result::Tag
		IntelliHome::Schema::SQLite::Schema::Result::Command
		IntelliHome::Schema::SQLite::Schema::Result::Trigger
		IntelliHome::Schema::SQLite::Schema::Result::RemoteControlLayout
		IntelliHome::Schema::SQLite::Schema::Result::GPIO
		IntelliHome::Schema::SQLite::Schema::Result::UserRoom
		IntelliHome::Schema::SQLite::Schema::Result::UserGPIO
		IntelliHome::Schema::SQLite::Schema::Result::User
		IntelliHome::Schema::SQLite::Schema::Result::Room
		IntelliHome::Schema::SQLite::Schema::Result::Node
		IntelliHome::Schema::SQLite::Schema::Result::Plugin
		IntelliHome::Schema::SQLite::Schema::Result::CommandGPIO
		IntelliHome::Schema::SQLite::Schema::Result::Pin
		IntelliHome::Parser::Base
		IntelliHome::Parser::DB::Base
		IntelliHome::Parser::DB::SQLite
		IntelliHome::Parser::DB::Mongo
		IntelliHome::Parser::SQLite
		IntelliHome::Parser::Mongo
		IntelliHome::WebUI::Controller::Gpio
		IntelliHome::WebUI::Controller::Pages
		IntelliHome::WebUI::Controller::Room
		IntelliHome::WebUI::Controller::Node
		IntelliHome::WebUI::Plugin::RPC
		IntelliHome::WebUI::Plugin::ModelFactory
		IntelliHome::WebUI::Model::Tile
		IntelliHome::WebUI::Model::Room
		IntelliHome::WebUI::Model::Node
		IntelliHome::Utils
		IntelliHome::Deployer::Base
		IntelliHome::Deployer::Schema::Base
		IntelliHome::Deployer::Schema::SQLite
		IntelliHome::Deployer::Schema::Mongo
		IntelliHome::Deployer::Debian
		IntelliHome::IntelliHomeWebUI
		IntelliHome::IntelliHomeNodeMaster
		IntelliHome::Plugin::Base
		IntelliHome::Plugin::Agent::Base
		IntelliHome::Plugin::Agent::GPIO
		IntelliHome::EventEmitter
		IntelliHome::Google::TTS
		IntelliHome::Google::Synth
		IntelliHome::IntelliHomeRPC
		IntelliHome::Workers::Role::Parser
		IntelliHome::Workers::Process
		IntelliHome::Workers::Thread
		IntelliHome::Schema::Mongo::Role::Plugin
	|;
}

done_testing();
