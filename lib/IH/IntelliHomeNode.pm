package IntelliHomeNode;
require IH::Interfaces::Terminal;
require IH::Config;
require IH::Workers::Node::Monitor;
require IH::Workers::Node::Sox;
require IH::Workers::Node::Event;
require IH::Workers::Node::AudioProcess;
require Proc::Daemon;
require AnyEvent;
require IH::Node;
use base qw(Exporter);
use warnings;
use strict;
our @EXPORT = qw(cleanup);

sub cleanup {
    unlink($_) for ( glob "/var/tmp/sox/*" );
    unlink($_) for ( glob "/var/tmp/ih/*" );
}

1;
