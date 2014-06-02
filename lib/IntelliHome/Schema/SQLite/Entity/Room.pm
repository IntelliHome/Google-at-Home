package IntelliHome::Schema::SQLite::Entity::Room;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('room');
__PACKAGE__->add_columns(
	'roomid' => { data_type=>'int', is_auto_increment=>1 }, 
	'name', 
	'location' => { is_nullable => 1} );
__PACKAGE__->set_primary_key('roomid');
__PACKAGE__->has_many(nodes => 'IntelliHome::Schema::SQLite::Entity::Node');

 
1;