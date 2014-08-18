package IntelliHome::RPC::Service::DB;

=head1 NAME

IntelliHome::RPC::Service::DB - IntelliHome "db" service for RPC server

=head1 DESCRIPTION

This object represent the "db" service for the RPC server, it is available under C<rpcserver_ip:port/db>

=head1 METHODS

IntelliHome::RPC::Service::DB inherits all methods from  L<IntelliHome::RPC::Service::Base> and implement the following new:

=over

=item add_node({ name => "NODENAME", port=>"NODEPORT"})

Add the node to the db

=item add_room({ name => "NODENAME", port=>"NODEPORT"})

Add the room to the db

=item add_gpio({ name => "NODENAME", port=>"NODEPORT"})

Add the node to the db

=item add_tag({ name => "NODENAME", port=>"NODEPORT"})

Add the node to the db

=item delete_node({ name => "NODENAME", port=>"NODEPORT"})

Add the node to the db

=item delete_gpio({ name => "NODENAME", port=>"NODEPORT"})

Add the node to the db

=item delete_tag({ name => "NODENAME", port=>"NODEPORT"})

Add the node to the db


=back

=head1 ATTRIBUTES

IntelliHome::RPC::Service::DB inherits all attributes from L<IntelliHome::RPC::Service::Base>

=head1 SEE ALSO

L<IntelliHome>, L<IntelliHome::Workers::Master::RPC> , L<MojoX::JSON::RPC::Service>

=cut

use Carp::Always;
use Mojo::Base 'IntelliHome::RPC::Service::Base';
has 'IntelliHome';

sub add_node {
    my ( $self, $tx, $node, $room ) = @_;

    return [ map { $_ = freeze $_; $_ }
            $self->IntelliHome->Parser->Backend->addNode( $node, $room ) ]
        if ( $self->IntelliHome->Parser->Backend->can("addNode")
        && !defined($room)
        && !defined($node) );
}

sub delete {
    my ( $self, $tx, $entity, $id ) = @_;
    return [
        $self->IntelliHome->Parser->Backend->delete_element( $entity, $id )
        ]
        if ( $self->IntelliHome->Parser->Backend->can("delete_element")
        && !defined($entity)
        && !defined($id) );
}

sub add_room {
    my ( $self, $tx, $room ) = @_;
    return [ map { $_ = freeze $_; $_ }
            $self->IntelliHome->Parser->Backend->add_room($room) ]
        if ( $self->IntelliHome->Parser->Backend->can("add_room")
        && !defined($room) );
}

sub add_gpio {
    my ( $self, $tx, $gpio, $node ) = @_;

    return [ map { $_ = freeze $_; $_ }
            $self->IntelliHome->Parser->Backend->add_gpio( $gpio, $node ) ]
        if ( $self->IntelliHome->Parser->Backend->can("add_gpio")
        && !defined($gpio)
        && !defined($node) );
}

sub add_tag {
    my ( $self, $tx, $tag, $gpio ) = @_;

    return [ map { $_ = freeze $_; $_ }
            $self->IntelliHome->Parser->Backend->add_tag( $tag, $gpio ) ]
        if ( $self->IntelliHome->Parser->Backend->can("add_tag")
        && !defined($tag)
        && !defined($gpio) );
}

sub add_pin {
    my ( $self, $tx, $pin, $gpio ) = @_;

    return [ map { $_ = freeze $_; $_ }
            $self->IntelliHome->Parser->Backend->add_pin( $pin, $gpio ) ]
        if ( $self->IntelliHome->Parser->Backend->can("add_pin")
        && !defined($pin)
        && !defined($gpio) );
}

__PACKAGE__->register_rpc_method_names( 'add_node', 'add_room', 'add_gpio', 'add_tag', 'add_pin', 'delete' );
1;
