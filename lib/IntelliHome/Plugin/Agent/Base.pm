package IntelliHome::Plugin::Agent::Base;

=head1 NAME

IntelliHome::Plugin::Agent::Base - Base class for agents plugins

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
has 'app' => (is=>"rw");

sub install {    #Called on install
    my $self = shift;
    $self->app->Output->debug(
        "(Leaved as default) Installing " . $self->_plugin );
}

sub _plugin { my $self = shift; $self =~ s/\=.*//; return $self }
1;
