package IntelliHome::Workers::Master::WebUI;

=head1 NAME

IntelliHome::Workers::Node::RPC - This thread starts the RPC server

=head1 DESCRIPTION

This Object starts the RPC internal server

=head1 USAGE

This object is used internally by G@H

=cut

use Moo;
use Carp qw( croak );
use feature 'say';
use Mojolicious::Commands;
with("IntelliHome::Workers::Thread");    #is a thread

sub run {
    my $self            = shift;
    # Application
    $ENV{MOJO_APP} = 'IntelliHome::IntelliHomeWebUI';
    # Start commands
    Mojolicious::Commands->start_app('IntelliHome::IntelliHomeWebUI',"prefork", '-l', 'http://*:8080');
}

sub launch {
    my $self = shift;
    $self->callback( \&run );
    $self->args( [$self] );
    $self->start();
}

1;
