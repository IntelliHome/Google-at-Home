package IntelliHome::Workers::Role::Parser;
use Moo::Role;
use Module::Load;
has 'Parser' => ( is => "rw", );

sub BUILD {
    my $self = shift;
    my $Parser
        = 'IntelliHome::Parser::'
        . $self->Config->DBConfiguration->{'database_backend'};
    load $Parser;
    $Parser
        = $Parser->new( Config => $self->Config, Output => $self->Output );
    $self->Parser($Parser);
    ##
    $self->GSynth->Language( $self->Config->DBConfiguration->{'language'} );
}

1;