package IntelliHome::Workers::Role::Parser;
use Moo::Role;
use IntelliHome::Utils qw(load_module);
has 'Parser' => ( is => "rw" );

sub BUILD {
    my $self = shift;
    if ( $self->Config->DBConfiguration->{'database_backend'} ) {
        my $Parser
            = 'IntelliHome::Parser::'
            . $self->Config->DBConfiguration->{'database_backend'};
        load_module($Parser);
        $Parser = $Parser->new(
            Config => $self->Config,
            Output => $self->Output
        );
        $self->Parser($Parser);
        ##
        $self->GSynth->Language(
            defined $self->Config
                and $self->Config->DBConfiguration->{'language'}
            ? $self->Config->DBConfiguration->{'language'}
            : "en"
        );
    }
    else {
        $self->Output->error("No Backend specified");
    }
}

1;
