package IntelliHome::Schema::SQLite::Entity::Plugin;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('plugin');
__PACKAGE__->add_columns(qw/ pluginid name description gpioid commandid triggerid /);
__PACKAGE__->set_primary_key('pluginid');
__PACKAGE__->has_many(userplugin => 'IntelliHome::Schema::SQLite::Entity::UserPlugin', 'pluginid');
__PACKAGE__->has_many(gpio => 'IntelliHome::Schema::SQLite::Entity::GPIO', 'gpioid');
__PACKAGE__->has_many(command => 'IntelliHome::Schema::SQLite::Entity::Command', 'commandid');
__PACKAGE__->has_many(trigger => 'IntelliHome::Schema::SQLite::Entity::Trigger', 'triggerid');
__PACKAGE__->many_to_many('users' => 'userplugin', 'userid');

 
1;