package IntelliHome::Schema::SQLite::Schema::Result::Command;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('command');
__PACKAGE__->add_columns(
	'commandid' => { data_type=>'int', is_auto_increment=>1 }, 
	'name',
	'plugin', 
	'command');
__PACKAGE__->set_primary_key('commandid');
__PACKAGE__->has_many(trigger => 'IntelliHome::Schema::SQLite::Schema::Result::Trigger');
__PACKAGE__->has_many(commandgpio => 'IntelliHome::Schema::SQLite::Schema::Result::CommandGPIO', 'commandid');
__PACKAGE__->many_to_many('gpios' => 'commandgpio', 'gpioid');
 
1;
