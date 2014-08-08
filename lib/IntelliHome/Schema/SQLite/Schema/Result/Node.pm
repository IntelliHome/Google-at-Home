package IntelliHome::Schema::SQLite::Schema::Result::Node;


=head1 NAME

IntelliHome::Schema::SQLite::Schema::Result::Node - DBIx::Class model that represent a Node 

=head1 DESCRIPTION

This object is a model that represent a Node in the network

=head1 ATTRIBUTES

=over

=item nodeid()

node unique ID identifier

=item roomid()

the room id where the node is in

=item name()

the node name

=item description()

the node description

=item host()

the node address

=item port()

the node port were it's listening

=item type()

the node type (master/agent/node)

=item user()

the node username (where in the future can be ssh'd thru the deployers)

=item password()

the node password (where in the future can be ssh'd thru the deployers)

=item gpios()

the node associated gpios

=item room()

the room where the node belong to

=back

=head1 SEE ALSO

L<IntelliHome::Schema::SQLite::Schema::Result::GPIO>, L<IntelliHome::Schema::SQLite::Schema::Result::UserGPIO>, L<IntelliHome::Schema::SQLite::Schema::Result::Room>

=cut

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('node');
__PACKAGE__->add_columns(
    'nodeid' => { data_type => 'int', is_auto_increment => 1 },
    'roomid' => { data_type => 'int' },
    'name',
    'description' => { is_nullable => 1 },
    'host',
    'port' => { data_type => 'int' },
    'type',
    'username',
    'password'
);
__PACKAGE__->set_primary_key('nodeid');
__PACKAGE__->has_many(
    gpios => 'IntelliHome::Schema::SQLite::Schema::Result::GPIO',
    'nodeid'
);
__PACKAGE__->belongs_to(
    room => 'IntelliHome::Schema::SQLite::Schema::Result::Room',
    'roomid'
);

sub Host {
    shift->host(@_);
}

sub Port {
    shift->port(@_);
}

1;
