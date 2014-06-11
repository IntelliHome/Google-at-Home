package IntelliHome::Schema::SQLite::Entity::User;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('user');
__PACKAGE__->add_columns(
	'userid' => { data_type=>'int', is_auto_increment=>1 },
	'username' => { accessor => '_check-username' }, 
	'password' => { accessor => '_check-password' size => 24 }, 
	'name' => { is_nullable => 1} , 
	'admin' => { data_type => 'boolean' });
__PACKAGE__->set_primary_key('userid');
__PACKAGE__->has_many(remotecontrollayouts => 'IntelliHome::Schema::SQLite::Entity::RemoteControlLayout');
__PACKAGE__->has_many(usergpio => 'IntelliHome::Schema::SQLite::Entity::UserGPIO', 'userid');
__PACKAGE__->many_to_many('gpios' => 'usergpio', 'gpioid');

sub check-username (@) {
    my ($self, $value) = @_;
 	
 	#TODO create a regex to exclude symbols and space but not . _ -
    die "Invalid username format!" if($value =~ /^$/);
    $self->_check-username($value);
 
    return $self->_check-username();
}

sub check-password (@) {
    my ($self, $value) = @_;
 	
    die "Invalid password format!" if($value =~ /^$/);
    #TODO insert md5 hash conversion or some other hashing method
    
    $self->_check-password($value);
 
    return $self->_check-password();
}



1;