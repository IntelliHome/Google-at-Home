package IntelliHome::Schema::SQLite::Schema::Result::Trigger;
use Carp::Always;
use base qw/DBIx::Class::Core/;


sub new {
	my $self=shift;
	$self->SUPER::new(@_);
	$self->{result} = [];
	return $self;
}
 
__PACKAGE__->table('trigger');
__PACKAGE__->add_columns(
	'triggerid' => { data_type=>'int', is_auto_increment=>1 },
	'commandid' => { data_type=>'int' },
	'trigger',
	'arguments', 
	'language' );
__PACKAGE__->set_primary_key('triggerid');
__PACKAGE__->belongs_to(command => 'IntelliHome::Schema::SQLite::Schema::Result::Command', 'commandid');
 
1;
