package IntelliHome::Schema::SQLite::Schema::Result::User;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('user');
__PACKAGE__->add_columns(
	'userid' => { data_type=>'int', is_auto_increment=>1 },
	'username' => { accessor => '_check_username' }, 
	'password' => { accessor => '_check_password', data_type=>'varchar', size => 24 }, 
	'name' => { data_type=>'varchar', size=>40} , 
	'admin' => { data_type => 'int', size=>1 });
__PACKAGE__->set_primary_key('userid');
__PACKAGE__->has_many(remotecontrollayouts => 'IntelliHome::Schema::SQLite::Schema::Result::RemoteControlLayout');
__PACKAGE__->has_many(usergpio => 'IntelliHome::Schema::SQLite::Schema::Result::UserGPIO', 'userid');
__PACKAGE__->many_to_many('gpios' => 'usergpio', 'gpioid');

sub check_username (@) {
    my ($self, $value) = @_;
 	
 	#TODO create a regex to exclude symbols and space but not . _ -
    die "Invalid username format!" if($value =~ /^$/);
    $self->check_username($value);
 
    return $self->check_username();
}

sub check_password (@) {
    my ($self, $value) = @_;
 	
    die "Invalid password format!" if($value =~ /^$/);
    #TODO insert md5 hash conversion or some other hashing method
    
    $self->check_password($value);
 
    return $self->check_password();
}



1;
