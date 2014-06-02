package IntelliHome::Schema::SQLite::Entity::Command;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('command');
__PACKAGE__->add_columns(
	'commandid' => { data_type=>'int', is_auto_increment=>1 }, 
	'name' => { data_type=>'int'},
	'plugin', 
	'command');
__PACKAGE__->set_primary_key('commandid');
__PACKAGE__->has_many(trigger => 'IntelliHome::Schema::SQLite::Entity::Trigger');
__PACKAGE__->has_many(commandgpio => 'IntelliHome::Schema::SQLite::Entity::CommandGPIO', 'commandid');
__PACKAGE__->many_to_many('gpios' => 'commandgpio', 'gpioid');
 
1;