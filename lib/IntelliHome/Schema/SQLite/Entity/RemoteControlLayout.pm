package IntelliHome::Schema::SQLite::Entity::RemoteControlLayout;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('remote_control_layout');
__PACKAGE__->add_columns(qw/ rclid userid name /);
__PACKAGE__->set_primary_key('rclid');
__PACKAGE__->belongs_to(userid => 'IntelliHome::Schema::SQLite::Entity::Plugin');
 
1;