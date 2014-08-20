package IntelliHome::Schema::SQLite::Schema::Result::Room;

=head1 NAME

IntelliHome::Schema::SQLite::Schema::Result::Room - DBIx::Class model that represent a Room in the house

=head1 DESCRIPTION

This object is a model that represent a Room in the house that has one or more nodes in

=head1 ATTRIBUTES

=over

=item roomid()

room unique ID identifier

=item name()

the room name

=item location()

the room location

=item nodes()

the room associated nodes

=back

=head1 SEE ALSO

L<IntelliHome::Schema::SQLite::Schema::Result::GPIO>, L<IntelliHome::Schema::SQLite::Schema::Result::Node>, L<IntelliHome::Schema::SQLite::Schema::Result::Room>

=cut

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('room');
__PACKAGE__->add_columns(
    'roomid' => { data_type => 'int', is_auto_increment => 1 },
    'name',
    'location'    => { is_nullable => 1 },
    'description' => { is_nullable => 1 },
    'notes'       => { is_nullable => 1 }
);
__PACKAGE__->set_primary_key('roomid');
__PACKAGE__->has_many(
    nodes => 'IntelliHome::Schema::SQLite::Schema::Result::Node',
    'roomid'
);

sub serialize {
    {   id          => $_[0]->roomid,
        name        => $_[0]->name,
        location    => $_[0]->location,
        description => $_[0]->description,
        notes       => $_[0]->notes,
        nodes_data  => [ map { $_->serialize } $_[0]->nodes->all() ]
    };
}

1;
