package IntelliHome::Schema::SQLite::Entity::Tag;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('tag');
__PACKAGE__->add_columns(
	'tagid' => { data_type=>'int', is_auto_increment=>1 },
	'gpioid' => { data_type=>'int' }, 
	'name', 
	'description' => { is_nullable => 1 } );
__PACKAGE__->set_primary_key('tagid');
__PACKAGE__->belongs_to(gpio => 'IntelliHome::Schema::SQLite::Entity::GPIO', 'gpioid');

 
1;