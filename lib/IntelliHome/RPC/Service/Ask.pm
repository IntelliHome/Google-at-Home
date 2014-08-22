package IntelliHome::RPC::Service::Ask;

=head1 NAME

IntelliHome::RPC::Service::Ask - IntelliHome "ask" service for RPC server

=head1 DESCRIPTION

This object represent the "ask" service for the RPC server, it is available under C<rpcserver_ip:port/ask>

=head1 METHODS

IntelliHome::RPC::Service::Ask inherits all methods from  L<IntelliHome::RPC::Service::Base> and implement the following new:

=over

=item rpc_gpio($tag)

Query the database backend, returning a list of GPIOs object (Schema dependant).
The C<$tag> must be a tagged gpio.
If C<$tag> is not given it returns all the elements.

=item rpc_nodes($query)

Query the database backend, returning a list of nodes object (Schema dependant).
The C<$query> must be an hashref of key => values that matches a gpio.
If C<$query> is not given it returns all the elements.

=item rpc_get_nodes($name)

Query the database backend, returning a list of YAML serialized nodes.
The C<$name> is used to filter by name.
If C<$name> is not given it returns all the elements.

=item rpc_gpio_data($tag)

Query the database backend, returning a list of YAML serialized gpios.
The C<$tag> is used to filter by tag.
If C<$tag> is not given it returns all the elements.

=item rpc_get_rooms($name)

Query the database backend, returning a list of YAML serialized rooms.
The C<$name> is used to filter by name.
If C<$name> is not given it returns all the elements.

=back

=head1 ATTRIBUTES

IntelliHome::RPC::Service::Ask inherits all attributes from L<IntelliHome::RPC::Service::Base>

=head1 SEE ALSO

L<IntelliHome>, L<IntelliHome::Workers::Master::RPC> , L<MojoX::JSON::RPC::Service>

=cut

use Carp::Always;
use Mojo::Base 'IntelliHome::RPC::Service::Base';
has 'IntelliHome';
use YAML qw'freeze thaw';

sub rpc_gpio {
    my ( $self, $tx, $tag ) = @_;

    return [map { $_ = freeze $_; $_ }
            $self->IntelliHome->Parser->Backend->get_all_gpio() ]
        if ( $self->IntelliHome->Parser->Backend->can("get_all_gpio")
        && !defined($tag) );
    return
        map { $_ = freeze $_; $_ }
        $self->IntelliHome->Parser->Backend->search_gpio( $tag ||= "." );

}

sub rpc_gpio_data {
    my ( $self, $tx, $tag ) = @_;
    return [map { $_ = freeze $_; $_ }
            $self->IntelliHome->Parser->Backend->get_all_gpio_data() ]
        if ( $self->IntelliHome->Parser->Backend->can("get_all_gpio_data")
        && !defined($tag) );
    return [ map { $_ = freeze $_; $_ }
            $self->IntelliHome->Parser->Backend->search_gpio( $tag ||= "." )
    ];

}

sub rpc_get_rooms {
    my ( $self, $tx, $room ) = @_;
    return [map { $_ = freeze $_; $_ }
            $self->IntelliHome->Parser->Backend->get_all_rooms() ]
        if ( $self->IntelliHome->Parser->Backend->can("get_all_rooms")
        && !defined($room) );
    return [ map { $_ = freeze $_; $_ }
            $self->IntelliHome->Parser->Backend->search_room( $room ||= "." )
    ];

}

sub rpc_get_nodes {
    my ( $self, $tx, $node ) = @_;
    return [map { $_ = freeze $_; $_ }
            $self->IntelliHome->Parser->Backend->get_all_nodes() ]
        if ( $self->IntelliHome->Parser->Backend->can("get_all_nodes")
        && !defined($node) );
    return [ map { $_ = freeze $_; $_ }
            $self->IntelliHome->Parser->Backend->search_node( $node ||= "." )
    ];

}

sub rpc_nodes {
    my ( $self, $tx, $query ) = @_;
    return [ map { $_ = freeze $_; $_ }
            $self->IntelliHome->Parser->Backend->getNodes($query) ];
}

__PACKAGE__->register_rpc;

1;
