package IntelliHome::Schema::SQLite::Entity::GPIO;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('gpio');
__PACKAGE__->add_columns(qw/ gpioid nodeid pluginid numgpio type value /);
__PACKAGE__->set_primary_key('gpioid');
__PACKAGE__->belongs_to(roomid => 'IntelliHome::Schema::SQLite::Entity::Node');
__PACKAGE__->belongs_to(pluginid => 'IntelliHome::Schema::SQLite::Entity::Plugin');
 
1;