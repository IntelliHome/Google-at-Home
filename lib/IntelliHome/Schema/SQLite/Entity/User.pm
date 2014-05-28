package IntelliHome::Schema::SQLite::Entity::User;
use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('user');
__PACKAGE__->add_columns('userid','username' => { accessor => '_check-username', size => 24 }, 'password' => { accessor => '_check-password' size => 24 }, 'name' { is_nullable => 1} , 'admin' => { data_type => 'boolean' }, 'roomid', 'pluginid');
__PACKAGE__->set_primary_key('userid');
__PACKAGE__->has_many(remotecontrollayout => 'IntelliHome::Schema::SQLite::Entity::RemoteControlLayout', 'userid');
__PACKAGE__->has_many(userroom => 'IntelliHome::Schema::SQLite::Entity::UserRoom', 'userid');
__PACKAGE__->has_many(userplugin => 'IntelliHome::Schema::SQLite::Entity::UserPlugin', 'userid');
__PACKAGE__->many_to_many('rooms' => 'userroom', 'roomid');
__PACKAGE__->many_to_many('plugins' => 'userplugin', 'pluginid');

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