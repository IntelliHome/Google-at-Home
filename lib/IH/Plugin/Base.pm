package IH::Plugin::Base;
use Moose;
has 'Config' => ( is => "rw" );
has 'Parser' => ( is => "rw" );

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
