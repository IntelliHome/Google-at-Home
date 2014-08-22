package IntelliHome::RPC::Service::DB;

=head1 NAME

IntelliHome::RPC::Service::DB - IntelliHome "db" service for RPC server

=head1 DESCRIPTION

This object represent the "db" service for the RPC server, it is available under C<rpcserver_ip:port/db>

=head1 METHODS

IntelliHome::RPC::Service::DB inherits all methods from  L<IntelliHome::RPC::Service::Base> and implement the following new:

=over

=item rpc_add_node({ name => "NODENAME", port=>"NODEPORT"}, {id=>$room->id })

Add the node to the db (the id is for roomid)

=item rpc_add_room({name => "test", location => "bedroom first floor" })

Add the room to the db

=item rpc_add_gpio({'pin_id' => '22','type' => '1','driver' => 'IntelliHome::Driver::GPIO::Mono'},{ id => $node->id })

Add the gpio to the db (the id is for nodeid)

=item rpc_add_tag({ tag => "test" }, { id => $gpio->id })

Add the tag to the db (the id is for gpioid)

=item rpc_add_pin({ pin => 44, type  => 4, value => 0 }, { id => $gpio->id })

Add the pin to the db (the id is for gpioid)

=item rpc_delete("Node", 42)

delete the Node resultset with the given id from the db

=back

=head1 ATTRIBUTES

IntelliHome::RPC::Service::DB inherits all attributes from L<IntelliHome::RPC::Service::Base>

=head1 SEE ALSO

L<IntelliHome>, L<IntelliHome::Workers::Master::RPC> , L<MojoX::JSON::RPC::Service>

=cut

use Carp::Always;
use Mojo::Base 'IntelliHome::RPC::Service::Base';
has 'IntelliHome';

sub rpc_add_node {
    my ( $self, $tx, $node, $room ) = @_;
    my $newnode;
    return
        !( $self->IntelliHome->Parser->Backend->can("addNode")
        && defined($room)
        && defined($node) ) ? undef
        : ( $newnode
            = $self->IntelliHome->Parser->Backend->addNode( $node, $room ) )
        ? $newnode->serialize
        : undef;
}

sub rpc_delete {
    my ( $self, $tx, $entity, $id ) = @_;
    return !( $self->IntelliHome->Parser->Backend->can("delete_element")
        && defined($entity)
        && defined($id) )
        ? undef
        : $self->IntelliHome->Parser->Backend->delete_element( $entity, $id );
}

sub rpc_add_room {
    my ( $self, $tx, $room ) = @_;
    my $newroom;
    return
        !( $self->IntelliHome->Parser->Backend->can("add_room")
        && defined($room) ) ? undef
        : ( $newroom = $self->IntelliHome->Parser->Backend->add_room($room) )
        ? $newroom->serialize
        : undef;
}

sub rpc_add_gpio {
    my ( $self, $tx, $gpio, $node ) = @_;
    my $newgpio;

    return
        !( $self->IntelliHome->Parser->Backend->can("add_gpio")
        && defined($gpio)
        && defined($node) ) ? undef
        : ( $newgpio
            = $self->IntelliHome->Parser->Backend->add_gpio( $gpio, $node ) )
        ? $newgpio->serialize
        : undef;
}

sub rpc_add_tag {
    my ( $self, $tx, $tag, $gpio ) = @_;
    my $newtag;

    return
        !( $self->IntelliHome->Parser->Backend->can("add_tag")
        && defined($tag)
        && defined($gpio) ) ? undef
        : ( $newtag
            = $self->IntelliHome->Parser->Backend->add_tag( $tag, $gpio ) )
        ? $newtag->serialize
        : undef;
}

sub rpc_add_pin {
    my ( $self, $tx, $pin, $gpio ) = @_;
    my $newpin;
    return
        !( $self->IntelliHome->Parser->Backend->can("add_pin")
        && defined($pin)
        && defined($gpio) ) ? undef
        : ( $newpin
            = $self->IntelliHome->Parser->Backend->add_pin( $pin, $gpio ) )
        ? $newpin->serialize
        : undef;
}

__PACKAGE__->register_rpc;
1;
