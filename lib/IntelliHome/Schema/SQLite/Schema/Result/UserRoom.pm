package IntelliHome::Schema::SQLite::Schema::Result::UserRoom;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('user_room');
__PACKAGE__->add_columns(qw/ id userid roomid /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(userid => 'IntelliHome::Schema::SQLite::Schema::Result::User');
__PACKAGE__->belongs_to(roomid => 'IntelliHome::Schema::SQLite::Schema::Result::Room');
 
1;