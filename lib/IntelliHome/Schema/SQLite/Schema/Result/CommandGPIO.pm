package IntelliHome::Schema::SQLite::Schema::Result::CommandGPIO;

use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('command_gpio');
__PACKAGE__->add_columns(
	'id' =>{ data_type=>'int', is_auto_increment=>1},
	'commandid' => { data_type=>'int'}, 
	'gpioid' => { data_type=>'int'} );
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(command => 'IntelliHome::Schema::SQLite::Schema::Result::Command','commandid');
__PACKAGE__->belongs_to(gpio => 'IntelliHome::Schema::SQLite::Schema::Result::GPIO','gpioid');
 
1;
