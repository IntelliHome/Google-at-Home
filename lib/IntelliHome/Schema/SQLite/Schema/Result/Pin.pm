package IntelliHome::Schema::SQLite::Schema::Result::Pin;

=head1 NAME

IntelliHome::Schema::SQLite::Schema::Result::Pin - DBIx::Class model that represent a Pin of a Node

=head1 DESCRIPTION

This object is a model that represent a Pin in the node's network

=head1 ATTRIBUTES

=over

=item pinid()

pin unique ID identifier

=item gpioid()

corresponding GPIO that has that pin

=item pin()

pin number (used for export)

=item type()

pin type

=item value()

the pin current value

=item status()

alias for the pin current value

=back

=head1 SEE ALSO

L<IntelliHome::Schema::SQLite::Schema::Result::GPIO>

=cut

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('pin');
__PACKAGE__->add_columns(
    'pinid'  => { data_type => 'int', is_auto_increment => 1 },
    'gpioid' => { data_type => 'int' },
    'pin',
    'type',
    'value'
);
__PACKAGE__->set_primary_key('pinid');
__PACKAGE__->belongs_to(
    gpio => 'IntelliHome::Schema::SQLite::Schema::Result::GPIO',
    'gpioid'
);

sub serialize {
    {   id     => $_[0]->pinid,
        gpioid => $_[0]->gpioid,
        pin    => $_[0]->pin,
        type   => $_[0]->type,
        value  => $_[0]->value
    };
}

sub status {
    shift->value(@_);
}

1;
