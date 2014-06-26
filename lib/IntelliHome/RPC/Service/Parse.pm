package IntelliHome::RPC::Service::Parse;

use Carp::Always;
use Mojo::Base 'IntelliHome::RPC::Service::Base';
use feature 'say';
use Data::Dumper;
has 'IntelliHome';

sub parse {
    my ( $self, $tx, @params ) = @_;
    my $Client = $self->IntelliHome->Parser->node->selectFromHost(
        $tx->remote_address, "node" );
    $Client = $self->IntelliHome->Parser->node->selectFromType("master")
        if !$Client;
    $self->IntelliHome->Parser->Node($Client);
    $self->IntelliHome->Parser->Output->Node($Client);
    $self->IntelliHome->Parser->parse(@params);
    return "Received " . join( " ", @params );
}

__PACKAGE__->register_rpc_method_names('parse');

1;

