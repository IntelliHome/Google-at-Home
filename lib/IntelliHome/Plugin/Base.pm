package IntelliHome::Plugin::Base;

=head1 NAME

IntelliHome::Plugin::Base - Base class for parser plugins

=head1 DESCRIPTION

This object is the base class for the parser's plugins

=head1 ATTRIBUTES

RemoteSynth implements the IntelliHome::Workers::Base attributes and implement the follow one

=over

=item Parser()

Get/Set the used Parser (defaults to autoload the specified in the config file)

=item Config()

Get/Set the L<IntelliHome::Config> object

=back

=head1 FUNCTIONS

=over

=item process()

Process the request with the parser specified in the config file

=back

=cut

use Moo;
has 'Config'      => ( is => "rw" );
has 'Parser'      => ( is => "rw" );
has 'IntelliHome' => ( is => "rw" );

sub prepare {  # this is called on first load in the thread session if defined
    my $self = shift;
    $self->Parser->Output->debug(
        "(Leaved as default) Preparing " . $self->_plugin );
}

sub install {    #Called on install
    my $self = shift;
    $self->Parser->Output->debug(
        "(Leaved as default) Installing " . $self->_plugin );
}

sub update {     #Called on update
    my $self = shift;
    $self->Parser->Output->debug(
        "(Leaved as default) Updating " . $self->_plugin );
    return $self->remove() and $self->install();
}

sub remove {     #Called on remove
    my $self = shift;
    $self->Parser->Output->debug(
        "(Leaved as default) Removing " . $self->_plugin );
    $self->IntelliHome->Backend->removePlugin(
        { plugin => ( split( /::/, ( $self =~ /(.*)\=/ )[0] ) )[-1] } );
    return 1;
}

1;
