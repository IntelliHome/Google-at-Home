package IntelliHome::Schema::SQLite::Entity::Command;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('command');
__PACKAGE__->add_columns(qw/ commandid name command pluginid /);
__PACKAGE__->set_primary_key('commandid');
__PACKAGE__->has_many(trigger => 'IntelliHome::Schema::SQLite::Entity::Trigger', 'triggerid');
__PACKAGE__->belongs_to(pluginid => 'IntelliHome::Schema::SQLite::Entity::Plugin');
 
1;