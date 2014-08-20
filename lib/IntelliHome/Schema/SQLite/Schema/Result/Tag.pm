package IntelliHome::Schema::SQLite::Schema::Result::Tag;

=head1 NAME

IntelliHome::Schema::SQLite::Schema::Result::Tag - DBIx::Class model that represent a Tag associated to a gpio

=head1 DESCRIPTION

This object is a model that represent a tag associated to a gpio

=head1 ATTRIBUTES

=over

=item tagid()

tag unique ID identifier

=item gpioid()

the gpio id of the tag

=item tag()

the tag name

=item description()

the tag description

=item gpio()

the gpios that have that tag

=back

=head1 SEE ALSO

L<IntelliHome::Schema::SQLite::Schema::Result::GPIO>, L<IntelliHome::Schema::SQLite::Schema::Result::Node>, L<IntelliHome::Schema::SQLite::Schema::Result::Room>

=cut

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('tag');
__PACKAGE__->add_columns(
    'tagid'  => { data_type => 'int', is_auto_increment => 1 },
    'gpioid' => { data_type => 'int' },
    'tag',
    'description' => { is_nullable => 1 }
);
__PACKAGE__->set_primary_key('tagid');
__PACKAGE__->belongs_to(
    gpio => 'IntelliHome::Schema::SQLite::Schema::Result::GPIO',
    'gpioid'
);

sub serialize {
    {   id       => $_[0]->tagid,
        gpioid      => $_[0]->gpioid,
        tag         => $_[0]->tag,
        description => $_[0]->description,
    };
}
1;
