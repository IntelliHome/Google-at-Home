package IntelliHome::IntelliHomeNodeMaster;
require IntelliHome::Interfaces::Terminal;
require IntelliHome::Connector;
require IntelliHome::Config;
require IntelliHome::Workers::Master::RemoteSynth;
require IntelliHome::Workers::Master::RPC;
require IntelliHome::Parser::Base;
require Module::Load;
require AnyEvent;
use base qw(Exporter);
use IntelliHome::Utils qw(daemonize cleanup stop_process);
use Moo;
use Module::Load;
with 'MooX::Singleton';
use warnings;

use strict;
use Unix::PID;
$SIG{USR1} = sub { die("Killed from USR1") };
$SIG{CHLD} = 'IGNORE';
has 'Config' => (
    is => "rw",
    default =>
      sub { return IntelliHome::Config->instance( Dirs => ['./config'] ) }
);
has 'Output' => (
    is      => "rw",
    default => sub { return IntelliHome::Interfaces::Terminal->instance }
);

has 'Remote' => (
    is      => "rw",
    default => sub {
        IntelliHome::Workers::Master::RemoteSynth->new(
            Config => shift->Config );
    }
);

sub stop { stop_process("master"); }

sub install_plugin {
    my $class          = shift;
    my $install_plugin = shift;
    my $self           = __PACKAGE__->instance;
    $self->Output->info("IntelliHome : installing plugin $install_plugin");
    exit $self->Remote->Parser->run_plugin( $install_plugin, "install" );
}

sub remove_plugin {
    my $class         = shift;
    my $remove_plugin = shift;
    my $self          = __PACKAGE__->instance;
    $self->Output->info("IntelliHome : removing plugin $remove_plugin");
    exit $self->Remote->Parser->run_plugin( $remove_plugin, "remove" );
}

sub update_plugin {
    my $class         = shift;
    my $update_plugin = shift;
    my $self          = __PACKAGE__->instance;
    $self->Output->info("IntelliHome : updating plugin $update_plugin");
    exit $self->Remote->Parser->run_plugin( $update_plugin, "update" );
}

sub start {
    my $class      = shift;
    my $foreground = shift;
    my $self       = __PACKAGE__->instance;
    my $IHOutput   = $self->Output;
    my $Config     = $self->Config;           #specify where yaml file are
    my $remote     = $self->Remote;

    $IHOutput->info("IntelliHome : Node master started");
    $IHOutput->info(
"Bringing up sockets (not secured, i assume you have properly secured your network)"
    );
    unless ($foreground) {
        if ( !daemonize("master") ) {
            $IHOutput->debug("Process already started");
            exit 0;
        }
    }
    my $node = "IntelliHome::Schema::"
      . $self->Config->DBConfiguration->{'database_backend'}

# . "YAML" #XXX: we force to yaml for now, but the backend will be switchable when autoconfiguration would be ready
      . "::Node";
    load $node;
    my $RPC = IntelliHome::Workers::Master::RPC->new();
    $RPC->launch;

    my $me = $node->new( Config => $Config )->selectFromType("master")
      ; # this for now forces the network to have one master, we can easily rid about that in the future
    my $Connector =
      IntelliHome::Connector->new( Config => $Config, Node => $me )
      ; #Config parameter is optional, only needed if you wanna send broadcast messages
    $Connector->Worker($remote);
    $Connector->blocking(1);
    $Connector->listen();

#blocking so down can't be executed (was used just for test)
# my $NodeToDeploy
#     = IntelliHome::Node->new( Config => $Config )->selectFromDescription("ih0");
# $NodeToDeploy->deploy();

    #$Connector->broadcastMessage("node","test");

}

!!42;
