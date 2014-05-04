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

use Moose;
has 'Config' => ( is => "rw" );
has 'Parser' => ( is => "rw" );
has 'IntelliHome' => (is=>"rw");

sub prepare {  # this is called on first load in the thread session if defined
    my $self = shift;
    $self->Parser->Output->debug(
        "(Leaved as default) Preparing " . __PACKAGE__ );
}

sub install {    #Called on install
    my $self = shift;
    $self->Parser->Output->debug(
        "(Leaved as default) Installing " . __PACKAGE__ );
}

sub update {     #Called on update
    my $self = shift;
    $self->Parser->Output->debug(
        "(Leaved as default) Updating " . __PACKAGE__ );
    return $self->remove() and $self->install();
}

sub remove {     #Called on remove
    my $self = shift;
    $self->Parser->Output->debug(
        "(Leaved as default) Removing " . __PACKAGE__ );
}
1;
