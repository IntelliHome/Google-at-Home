package IntelliHome::RPC::Service::Parse;

use Carp::Always;
use Mojo::Base 'MojoX::JSON::RPC::Service';
use feature 'say';
use Data::Dumper;
use IntelliHome::Utils qw(load_module);
has 'IntelliHome';

sub new {
    my $self = shift;
    $self = $self->SUPER::new(@_);
    $self->{'_rpcs'}->{'parse'}->{'with_mojo_tx'} = 1;
    return $self;
}

sub parse {
    my ( $self, $tx, @params ) = @_;
    my $node =
        "IntelliHome::Schema::"
      . $self->IntelliHome->Config->DBConfiguration->{'database_backend'}
      . "::Node";
    load_module($node);
    my $Client = $node->new( Config => $self->IntelliHome->Config )
      ->selectFromHost( $tx->remote_address, "node" );
    $self->IntelliHome->Parser->Node($Client);
    $self->IntelliHome->Parser->Output->Node($Client);
    $self->IntelliHome->Parser->parse(@params);
    return "Received " . join( " ", @params );
}

__PACKAGE__->register_rpc_method_names('parse');

1;

