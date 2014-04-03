package IntelliHome::Workers::Agent::CommandProcess;
use Moo;
use IntelliHome::Utils qw(message_expand SEPARATOR);
use Module::Load;

has 'Output' => (
    is      => "rw",
    default => sub { return new IntelliHome::Interfaces::Terminal }
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
    my $Pin  = "IntelliHome::Pin::" . uc( shift @args );
    load $Pin;
    my $Port = $Pin->new(
        Pin       => shift @args,
        Direction => shift @args
    );
    my $return = $Port->setValue( shift @args );
    print $command $return;
    return $return;
}

1;
