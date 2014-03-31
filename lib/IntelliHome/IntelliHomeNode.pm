package IntelliHome::IntelliHomeNode;
require IntelliHome::Interfaces::Terminal;
require IntelliHome::Config;
require IntelliHome::Workers::Node::Monitor;
require IntelliHome::Workers::Node::Sox;
require IntelliHome::Workers::Node::Event;
require IntelliHome::Workers::Node::AudioProcess;
require IntelliHome::Schema::YAML::Node;
require Proc::Daemon;
require AnyEvent;
use base qw(Exporter);
use warnings;
use strict;
our @EXPORT = qw(cleanup);

sub cleanup {
    unlink for ( (glob "/var/tmp/sox/*"),( glob "/var/tmp/ih/*" ));
}

!!42;

