package IntelliHomeNode;
require IntelliHome::Interfaces::Terminal;
require IntelliHome::Config;
require IntelliHome::Workers::Node::Monitor;
require IntelliHome::Workers::Node::Sox;
require IntelliHome::Workers::Node::Event;
require IntelliHome::Workers::Node::AudioProcess;
require Proc::Daemon;
require AnyEvent;
require IntelliHome::Node;
use base qw(Exporter);
use warnings;
use strict;
our @EXPORT = qw(cleanup);

sub cleanup {
    unlink($_) for ( glob "/var/tmp/sox/*" );
    unlink($_) for ( glob "/var/tmp/ih/*" );
}

!!42;

