package IntelliHome::RPC::Service::Dummy;

=head1 NAME

IntelliHome::RPC::Service::Dummy - IntelliHome "Dummy" service for RPC server

=head1 DESCRIPTION

This object represent the "Dummy" service for the RPC server, it is available under C<rpcserver_ip:port/Dummy>.
It is only used for testing purposes, pends deletion

=head1 METHODS

IntelliHome::RPC::Service::Dummy inherits all methods from  L<IntelliHome::RPC::Service::Base> and implement the following new:

=over

=item dummy

it just returns "DUMMY-DUMMY!"

=back

=head1 ATTRIBUTES

IntelliHome::RPC::Service::Parse inherits all attributes from L<IntelliHome::RPC::Service::Base>

=head1 SEE ALSO

L<IntelliHome>, L<IntelliHome::RPC::Service::Command>, L<IntelliHome::Workers::Master::RPC>, L<MojoX::JSON::RPC::Service>

=cut

use Carp::Always;
use Mojo::Base 'IntelliHome::RPC::Service::Base';
sub dummy {
    my ( $self, $tx, undef, @params ) = @_;

    return "DUMMY-YUMMY!";
}

__PACKAGE__->register_rpc_method_names('dummy');

1;
