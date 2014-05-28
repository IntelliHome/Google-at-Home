package IntelliHome::Schema::SQLite::Entity::Room;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('room');
__PACKAGE__->add_columns(qw/ roomid name location /);
__PACKAGE__->set_primary_key('roomid');
__PACKAGE__->has_many(userroom => 'IntelliHome::Schema::SQLite::Entity::UserRoom', 'roomid');
__PACKAGE__->has_many(node => 'IntelliHome::Schema::SQLite::Entity::Node', 'roomid');
__PACKAGE__->many_to_many('users' => 'userroom', 'userid');

 
1;