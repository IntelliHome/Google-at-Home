package IntelliHome::Plugin::Agent::GPIO;

=head1 NAME

IntelliHome::Plugin::Agent::GPIO - GPIO handler plugin for agent

=head1 DESCRIPTION

This object is the base class for the agent's plugins

=head1 ATTRIBUTES

IntelliHome::Plugin::Agent::Base implements those attributes

=over

=item app()

Get/Set the app instance (IntelliHome::IntelliHomeAgent)

=back

=head1 FUNCTIONS

=over

=item install()

installs the plugin hooks

=back

=cut

use Moo;
extends("IntelliHome::Plugin::Agent::Base");
use IntelliHome::Connector qw(STATUS_MSG GPIO_MSG);

sub install {    #Called on install
    my $self = shift;
    $self->app->event->on(
        GPIO_MSG => sub {
            use IntelliHome::Utils qw(load_module);
            my $self   = shift;
            my @args   = @_;
            my $Driver = shift @args;
            my $Pin    = "IntelliHome::Driver::GPIO::" . $Driver;
            my $return;
            load_module($Pin);
            my $Port;

            if ( $Driver eq "Dual" ) {
                $Port = $Pin->new(
                    onPin     => shift @args,
                    offPin    => shift @args,
                    Direction => shift @args
                );
            }
            else {
                $Port = $Pin->new(
                    Pin       => shift @args,
                    Direction => shift @args
                );
            }
            my $method = shift @args;

            if ( $Port->can($method) ) {
                $return = $Port->$method(@args);
                #### XXX: This should be reported in a better way
                my $master = IntelliHome::Connector->new(
                    Node => $self->app->nodes->selectFromType("master") );
                $master->send( STATUS_MSG, $Pin->Pin, $return )
                    if $Driver ne "Mono";

                $master->send( STATUS_MSG, $Pin->onPin, $return )
                    if $Driver eq "Dual";
            }
            else {
                die("Cannot set $Port $method with @args");
            }
        }
    );
}

1;
