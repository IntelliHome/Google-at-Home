package IntelliHome::Workers::Agent::CommandProcess;
use Moo;
use IntelliHome::Utils qw(message_expand SEPARATOR);
use Module::Load;

has 'Output' =>
    ( is => "rw", default => sub { return new IntelliHome::Interfaces::Terminal } );

sub process {
    my $self = shift;
    my $fh   = shift;
    my $command;
    while (<$fh>) {
        $command .= $_;
    }
    $self->Output->debug("I received - $command -");
    my @args=message_expand($command);
    my $type=shift @args;
   	my $Pin="IntelliHome::Pin::".uc($type);
   	my $id=shift @args;
   	my $direction=shift @args;
   	my $value=shift @args;
   	my $Port=$Pin->new(
   		Pin=> $id,
   		Direction=>$direction
   		);
   	my $return=$Port->setValue($value);
   	print $command $return;
   	return $return;
}

1;
