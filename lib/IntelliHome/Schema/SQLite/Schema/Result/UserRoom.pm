package IntelliHome::Schema::SQLite::Schema::Result::UserRoom;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('user_room');
__PACKAGE__->add_columns(qw/ id userid roomid /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(user => 'IntelliHome::Schema::SQLite::Schema::Result::User','userid');
__PACKAGE__->belongs_to(room => 'IntelliHome::Schema::SQLite::Schema::Result::Room','roomid');
 
1;