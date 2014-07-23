package IntelliHome::Schema::SQLite::Schema::Result::GPIO;


=head1 NAME

IntelliHome::Schema::SQLite::Schema::Result::GPIO - DBIx::Class model that represent a GPIO 

=head1 DESCRIPTION

This object is a model that represent a GPIO in the node's network

=head1 ATTRIBUTES

=over

=item gpioid()

gpio unique ID identifier

=item nodeid()

corresponding node that has that GPIO

=item num_gpio()

gpio number (used for export)

=item type()

gpio type

=item value()

the gpio current value

=item driver()

the driver associated to that gpio

=item tags()

tags associated to that gpio

=back

=head1 SEE ALSO

L<IntelliHome::Schema::SQLite::Schema::Result::Node>, L<IntelliHome::Schema::SQLite::Schema::Result::UserGPIO>, L<IntelliHome::Schema::SQLite::Schema::Result::Tag>

=cut

use base qw/DBIx::Class::Core/;
 
__PACKAGE__->table('gpio');
__PACKAGE__->add_columns(
	'gpioid' => { data_type=>'int', is_auto_increment=>1 },
	'nodeid' => { data_type=>'int' }, 
	'num_gpio', 
	'type',
	'value',
	'driver' );
__PACKAGE__->set_primary_key('gpioid');
__PACKAGE__->belongs_to(node => 'IntelliHome::Schema::SQLite::Schema::Result::Node', 'nodeid');
__PACKAGE__->has_many(usergpio => 'IntelliHome::Schema::SQLite::Schema::Result::UserGPIO', 'gpioid');
__PACKAGE__->has_many(commandgpio => 'IntelliHome::Schema::SQLite::Schema::Result::CommandGPIO', 'gpioid');
__PACKAGE__->has_many(tags => 'IntelliHome::Schema::SQLite::Schema::Result::Tag', 'gpioid');
__PACKAGE__->many_to_many('users' => 'usergpio', 'userid');
__PACKAGE__->many_to_many('commands' => 'commandgpio', 'commandid'); 

1;
