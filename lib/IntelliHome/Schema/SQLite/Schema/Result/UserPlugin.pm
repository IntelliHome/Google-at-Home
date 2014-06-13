package IntelliHome::Schema::SQLite::Schema::Result::UserPlugin;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('user_plugin');
__PACKAGE__->add_columns(qw/ id userid pluginid /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(userid => 'IntelliHome::Schema::SQLite::Schema::Result::User');
__PACKAGE__->belongs_to(pluginid => 'IntelliHome::Schema::SQLite::Schema::Result::Plugin');
 
1;