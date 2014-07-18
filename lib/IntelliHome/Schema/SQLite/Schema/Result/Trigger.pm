package IntelliHome::Schema::SQLite::Schema::Result::Trigger;
=head1 NAME

IntelliHome::Schema::SQLite::Schema::Result::Trigger - DBIx::Class model that represent a Trigger associated to a Plugin 

=head1 DESCRIPTION

This object is a model that represent a Trigger associated to a Plugin command

=head1 ATTRIBUTES

=over

=item triggerid()

trigger unique ID identifier

=item commandid()

the command id of the trigger

=item trigger()

the trigger name

=item arguments()

the trigger arguments that represent a regex to match options to the plugins

=item language()

the trigger language

=back

=head1 SEE ALSO

L<IntelliHome::Schema::SQLite::Schema::Result::GPIO>, L<IntelliHome::Schema::SQLite::Schema::Result::Node>, L<IntelliHome::Schema::SQLite::Schema::Result::Command>

=cut

use base qw/DBIx::Class::Core/;


sub new {
	my $self=shift;
	$self->SUPER::new(@_);
	$self->{result} = [];
	return $self;
}
 
__PACKAGE__->table('trigger');
__PACKAGE__->add_columns(
	'triggerid' => { data_type=>'int', is_auto_increment=>1 },
	'commandid' => { data_type=>'int' },
	'trigger',
	'arguments', 
	'language' );
__PACKAGE__->set_primary_key('triggerid');
__PACKAGE__->belongs_to(command => 'IntelliHome::Schema::SQLite::Schema::Result::Command', 'commandid');
 
1;
