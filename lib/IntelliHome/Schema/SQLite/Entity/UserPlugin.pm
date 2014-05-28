package IntelliHome::Schema::SQLite::Entity::UserPlugin;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('user_plugin');
__PACKAGE__->add_columns(qw/ id userid pluginid /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(userid => 'IntelliHome::Schema::SQLite::Entity::User');
__PACKAGE__->belongs_to(pluginid => 'IntelliHome::Schema::SQLite::Entity::Plugin');
 
1;