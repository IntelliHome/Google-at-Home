package IntelliHome::Schema::SQLite::Schema::Result::Node;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('node');
__PACKAGE__->add_columns(
	'nodeid' => { data_type=>'int', is_auto_increment=>1 },
	'roomid' => { data_type=>'int' }, 
	'name', 
	'description' => { is_nullable => 1 },
	'host',
	'port' => { data_type=>'int' },
	'type',
	'username', 
	'password');
__PACKAGE__->set_primary_key('nodeid');
__PACKAGE__->has_many(gpios => 'IntelliHome::Schema::SQLite::Schema::Result::GPIO', 'nodeid');
__PACKAGE__->belongs_to(room => 'IntelliHome::Schema::SQLite::Schema::Result::Room', 'roomid');

 
1;