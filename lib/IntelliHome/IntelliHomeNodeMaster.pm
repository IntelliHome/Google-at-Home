package IntelliHome::IntelliHomeNodeMaster;
require IntelliHome::Interfaces::Terminal;
require IntelliHome::Connector;
require IntelliHome::Config;
require IntelliHome::Workers::Master::RemoteSynth;
require IntelliHome::Workers::Master::WebUI;
require IntelliHome::Workers::Master::RPC;
require IntelliHome::Parser::Base;
require AnyEvent;
use base qw(Exporter);
use IntelliHome::Utils qw(daemonize cleanup stop_process);
use Moo;
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
        my $self = shift;
        IntelliHome::Workers::Master::RemoteSynth->new(
            Config => $self->Config );
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
    my $self       = __PACKAGE__->instance;
    my $foreground = shift;
    $self->Output->info("IntelliHome : Node master started");
    $self->Output->info(
        "Bringing up sockets (not secured, i assume you have properly secured your network)"
    );
    unless ($foreground) {
        if ( !daemonize("master") ) {
            $self->Output->debug("Process already started");
            exit 0;
        }
    }

    IntelliHome::Workers::Master::RPC->new()->launch;
    IntelliHome::Connector->new(
        Config   => $self->Config,
        Node     => $self->Remote->Parser->node->selectFromType("master"),
        Worker   => $self->Remote,
        blocking => 1
        )->listen()
        ; #Config parameter is optional, only needed if you wanna send broadcast messages
}

!!42;
