package IntelliHome::Schema::SQLite::Schema::Result::Command;

=head1 NAME

IntelliHome::Schema::SQLite::Schema::Result::Command - DBIx::Class model that represent plugin exported functions

=head1 DESCRIPTION

This object is a model that represent plugin exported functions that have many triggers

=head1 ATTRIBUTES

=over

=item commandid()

command ID

=item name()

command name

=item plugin()

contains the plugin package name

=item command()

contains the plugin method to call

=item triggers()

all the triggers associated with that command

=item commandgpio()

all the gpio associated with that command

=back

=head1 SEE ALSO

L<IntelliHome::Schema::SQLite::Schema::Result::Trigger>, L<IntelliHome::Schema::SQLite::Schema::Result::CommandGPIO>

=cut

use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('command');
__PACKAGE__->add_columns(
	'commandid' => { data_type=>'int', is_auto_increment=>1 }, 
	'name',
	'plugin', 
	'command');
__PACKAGE__->set_primary_key('commandid');
__PACKAGE__->has_many(triggers => 'IntelliHome::Schema::SQLite::Schema::Result::Trigger', 'commandid');
__PACKAGE__->has_many(commandgpio => 'IntelliHome::Schema::SQLite::Schema::Result::CommandGPIO', 'commandid');
__PACKAGE__->many_to_many('gpios' => 'commandgpio', 'gpioid');
 
1;
