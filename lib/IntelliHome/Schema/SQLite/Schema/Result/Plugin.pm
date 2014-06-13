package IntelliHome::Schema::SQLite::Schema::Result::Plugin;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('plugin');
__PACKAGE__->add_columns(qw/ pluginid name description gpioid commandid triggerid /);
__PACKAGE__->set_primary_key('pluginid');
__PACKAGE__->has_many(userplugin => 'IntelliHome::Schema::SQLite::Schema::Result::UserPlugin', 'pluginid');
__PACKAGE__->has_many(gpio => 'IntelliHome::Schema::SQLite::Schema::Result::GPIO', 'gpioid');
__PACKAGE__->has_many(command => 'IntelliHome::Schema::SQLite::Schema::Result::Command', 'commandid');
__PACKAGE__->has_many(trigger => 'IntelliHome::Schema::SQLite::Schema::Result::Trigger', 'triggerid');
__PACKAGE__->many_to_many('users' => 'userplugin', 'userid');

 
1;