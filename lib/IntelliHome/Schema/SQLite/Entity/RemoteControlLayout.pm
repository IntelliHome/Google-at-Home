package IntelliHome::Schema::SQLite::Entity::RemoteControlLayout;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('remote_control_layout');
__PACKAGE__->add_columns(
	'rclid' => { data_type=>'int', is_auto_increment=>1 }, 
	'userid' => { data_type=>'int' }, 
	'name' { accessor => '_check-name' });
__PACKAGE__->set_primary_key('rclid');
__PACKAGE__->belongs_to(userid => 'IntelliHome::Schema::SQLite::Entity::User');
 

sub check-name (@) {
    my ($self, $value) = @_;
 	
 	#TODO create a regex to exclude symbols
    die "Invalid name format!" if($value =~ /^$/);
    #TODO convert the string in a standard form
    $self->_check-username($value);
 
    return $self->_check-username();
}

1;