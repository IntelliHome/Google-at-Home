package IntelliHome::Schema::SQLite::Schema::Result::UserGPIO;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('user_gpio');
__PACKAGE__->add_columns(
	'id' =>{ data_type=>'int', is_auto_increment=>1},
	'userid' => { data_type=>'int'}, 
	'gpioid' => { data_type=>'int'} );
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(user => 'IntelliHome::Schema::SQLite::Schema::Result::User','userid');
__PACKAGE__->belongs_to(gpio => 'IntelliHome::Schema::SQLite::Schema::Result::GPIO','gpioid');
 
1;