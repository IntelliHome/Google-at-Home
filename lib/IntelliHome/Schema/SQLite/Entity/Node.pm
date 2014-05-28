package IntelliHome::Schema::SQLite::Entity::Node;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('node');
__PACKAGE__->add_columns(qw/ nodeid roomid name description host port type username password /);
__PACKAGE__->set_primary_key('nodeid');
__PACKAGE__->has_many(gpio => 'IntelliHome::Schema::SQLite::Entity::GPIO', 'gpioid');
__PACKAGE__->belongs_to(roomid => 'IntelliHome::Schema::SQLite::Entity::Room');

 
1;