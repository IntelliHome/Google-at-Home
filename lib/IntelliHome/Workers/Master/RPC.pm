package IntelliHome::Workers::Master::RPC;

=head1 NAME

IntelliHome::Workers::Node::RPC - This object represent a thread that starts the RPC server

=head1 DESCRIPTION

This object represent the instance of the RPC internal server

=head1 USAGE

This object is used internally by G@H

    IntelliHome::Workers::Node::RPC->new(%opts)->launch

=cut

use Moo;
use Carp qw( croak );
use feature 'say';
use Mojolicious::Commands;
with("IntelliHome::Workers::Thread");    #is a thread

sub run {
    my $self = shift;

    # Application
    $ENV{MOJO_APP}     = 'IntelliHome::IntelliHomeRPC';
    $ENV{MOJO_REACTOR} = "Mojo::Reactor::Poll";           #workaround for #34
                                                          # Start commands
    Mojolicious::Commands->start_app( 'IntelliHome::IntelliHomeRPC', @_ );
}

1;
