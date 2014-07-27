package IntelliHome::RPC::Service::Ask;

=head1 NAME

IntelliHome::RPC::Service::Ask - IntelliHome "ask" service for RPC server

=head1 DESCRIPTION

This object represent the "ask" service for the RPC server, it is available under C<rpcserver_ip:port/ask>

=head1 METHODS

IntelliHome::RPC::Service::Ask inherits all methods from  L<IntelliHome::RPC::Service::Base> and implement the following new:

=over

=item gpio($tag)

Query the database backend, returning a list of GPIOs object (Schema dependant).
The C<$tag> must be a tagged gpio.
If C<$tag> is not given it returns all the elements.

=item nodes($query)

Query the database backend, returning a list of nodes object (Schema dependant).
The C<$query> must be an hashref of key => values that matches a gpio.
If C<$query> is not given it returns all the elements.

=back

=head1 ATTRIBUTES

IntelliHome::RPC::Service::Ask inherits all attributes from L<IntelliHome::RPC::Service::Base>

=head1 SEE ALSO

L<IntelliHome>, L<IntelliHome::Workers::Master::RPC> , L<MojoX::JSON::RPC::Service>

=cut

use Carp::Always;
use Mojo::Base 'IntelliHome::RPC::Service::Base';
has 'IntelliHome';

sub gpio {
    my ( $self, $tx, $tag ) = @_;
    return $self->IntelliHome->Parser->Backend->search_gpio( $tag ||= "." );
}

sub nodes {
    my ( $self, $tx, $query ) = @_;
    return $self->IntelliHome->Parser->Backend->getNodes($query);
}

__PACKAGE__->register_rpc_method_names( 'gpio', 'nodes' );

1;
