package IntelliHome::Schema::SQLite::Entity::Trigger;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('trigger');
__PACKAGE__->add_columns(qw/ triggerid trigger language triggertype pluginid commandid /);
__PACKAGE__->set_primary_key('triggerid');
__PACKAGE__->belongs_to(commandid => 'IntelliHome::Schema::SQLite::Entity::Command');
__PACKAGE__->belongs_to(pluginid => 'IntelliHome::Schema::SQLite::Entity::Plugin');
 
1;