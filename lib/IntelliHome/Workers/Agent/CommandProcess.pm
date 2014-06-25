package IntelliHome::Workers::Agent::CommandProcess;
use Moo;
use IntelliHome::Utils qw(message_expand SEPARATOR load_module);
use Carp::Always;
has 'app' => ( is => "rw" );

sub process {
    my $self = shift;
    my $fh   = shift;
    my $command;
    my $return;
    while (<$fh>) {
        $command .= $_;
    }
    chomp($command);
    $self->app->Output->debug("I received - $command -");
    eval {
        my @args = message_expand($command);
        my $Cmd  = shift @args;
        $self->app->event->emit( $Cmd,@args );
    };
    if ($@) {
        $self->app->Output->error($@);
        $return = -1;
    }
    return $return;

}

1;
