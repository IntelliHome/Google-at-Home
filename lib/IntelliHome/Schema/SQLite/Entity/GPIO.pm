package IntelliHome::Schema::SQLite::Entity::GPIO;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('gpio');
__PACKAGE__->add_columns(
	'gpioid' => { data_type=>'int', is_auto_increment=>1 },
	'nodeid' => { data_type=>'int' }, 
	'num_gpio', 
	'type',
	'value',
	'driver' );
__PACKAGE__->set_primary_key('gpioid');
__PACKAGE__->belongs_to(node => 'IntelliHome::Schema::SQLite::Entity::Node', 'nodeid');
__PACKAGE__->has_many(usergpio => 'IntelliHome::Schema::SQLite::Entity::UserGPIO', 'gpioid');
__PACKAGE__->has_many(commandgpio => 'IntelliHome::Schema::SQLite::Entity::CommandGPIO', 'gpioid');
__PACKAGE__->has_many(tags => 'IntelliHome::Schema::SQLite::Entity::Tags');
__PACKAGE__->many_to_many('users' => 'usergpio', 'userid');
__PACKAGE__->many_to_many('commands' => 'commandgpio', 'commandid'); 

1;