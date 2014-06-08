package IntelliHome::Workers::Agent::CommandProcess;
use Moo;
use IntelliHome::Utils qw(message_expand SEPARATOR load_module);

has 'Output' => (
    is      => "rw",
    default => sub { return IntelliHome::Interfaces::Terminal->instance }
);

sub process {
    my $self = shift;
    my $fh   = shift;
    my $command;
    while (<$fh>) {
        $command .= $_;
    }
    $self->Output->debug("I received - $command -");
    my @args = message_expand($command);
    my $Pin  = "IntelliHome::Driver::GPIO::" . uc( shift @args );
    load_module($Pin);
    my $Port = $Pin->new(
        Pin       => shift @args,
        Direction => shift @args
    );
    my $method = shift @args;
    my $return;

    if ( $Port->can($method) ) {
        $return = $Port->$method(@args);
    }
    else {
        $return = -1;
    }
    print $command $return;
    return $return;
}

1;
