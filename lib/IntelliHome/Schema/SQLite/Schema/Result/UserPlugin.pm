package IntelliHome::Schema::SQLite::Schema::Result::UserPlugin;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('user_plugin');
__PACKAGE__->add_columns(qw/ id userid pluginid /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(user => 'IntelliHome::Schema::SQLite::Schema::Result::User','userid');
__PACKAGE__->belongs_to(plugin => 'IntelliHome::Schema::SQLite::Schema::Result::Plugin','pluginid');
 
1;