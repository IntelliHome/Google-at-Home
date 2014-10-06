package IntelliHome::RPC::Service::Command;

=head1 NAME

IntelliHome::RPC::Service::Command - IntelliHome "Command" service for RPC server

=head1 DESCRIPTION

This object represent the "Command" service for the RPC server, it is available under C<rpcserver_ip:port/Command>

=head1 METHODS

IntelliHome::RPC::Service::Command inherits all methods from  L<IntelliHome::RPC::Service::Base> and implement the following new:

=over

=item gpio

emit the "GPIO" event with the argument passed

=item startup

Starts the RPC server with the loaded services.

=back

=head1 ATTRIBUTES

IntelliHome::RPC::Service::Command inherits all attributes from L<IntelliHome::RPC::Service::Base>

=head1 SEE ALSO

L<IntelliHome>, L<IntelliHome::Workers::Master::RPC> , L<MojoX::JSON::RPC::Service>

=cut

use Carp::Always;
use Mojo::Base 'IntelliHome::RPC::Service::Base';
use IntelliHome::Connector qw(GPIO_MSG);
has 'IntelliHome';

sub gpio {
    my ( $self, $tx, undef, @params ) = @_;
    my $Client = $self->IntelliHome->Parser->node->selectFromHost(
        $tx->remote_address, "node" );
    $Client = $self->IntelliHome->Parser->node->selectFromType("master")
        if !$Client;
    $self->IntelliHome->Parser->Node($Client);
    $self->IntelliHome->Parser->Output->Node($Client);
    $self->IntelliHome->Parser->event->emit(GPIO_MSG,@params);
    return "Received " . join( " ", @params );
}

__PACKAGE__->register_rpc_method_names('gpio');

1;
