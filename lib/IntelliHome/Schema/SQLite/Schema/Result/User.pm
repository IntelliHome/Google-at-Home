package IntelliHome::Schema::SQLite::Schema::Result::User;
use base qw/DBIx::Class::Core/;
use Digest::SHA1  qw(sha1_hex);

__PACKAGE__->table('user');
__PACKAGE__->add_columns(
	'userid' => { data_type=>'int', is_auto_increment=>1 },
	'username' => { accessor => '_check_username' }, 
	'password' => { accessor => '_check_password', data_type=>'varchar', size => 40 }, 
	'name' => { data_type=>'varchar'} , 
	'admin' => { data_type => 'int', size=>1 });
__PACKAGE__->set_primary_key('userid');
__PACKAGE__->has_many(remotecontrollayouts => 'IntelliHome::Schema::SQLite::Schema::Result::RemoteControlLayout', 'userid');
__PACKAGE__->has_many(usergpio => 'IntelliHome::Schema::SQLite::Schema::Result::UserGPIO', 'userid');
__PACKAGE__->has_many(userroom => 'IntelliHome::Schema::SQLite::Schema::Result::UserRoom', 'userid');
__PACKAGE__->many_to_many('gpios' => 'usergpio', 'gpioid');
__PACKAGE__->many_to_many('rooms' => 'userroom', 'roomid');

sub check_username (@) {
    my ($self, $value) = @_;

    die "Invalid username format!" if($value =~ /^$|\s+|[!$%^&*()+|~=`{}\[\]:";'<>?,\/]/);
    $self->_check_username($value);
 
    return $self->_check_username();
}

sub check_password (@) {
    my ($self, $value) = @_;
 	
    die "Invalid password format!" if($value =~ /^$|\s+/);
    $digest = sha1($value);
    $self->_check_password($digest);
 
    return $self->_check_password();
}



1;
