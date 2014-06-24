package IntelliHome::Workers::Agent::CommandProcess;
use Moo;
use IntelliHome::Utils qw(message_expand SEPARATOR load_module);


has 'app' => (is=>"rw");

sub process {
    my $self = shift;
    my $fh   = shift;
    my $command;
    while (<$fh>) {
        $command .= $_;
    }
    $self->app->Output->debug("I received - $command -");
    my @args   = message_expand($command);
    my $Type   = shift @args;
    my $Driver = shift @args;
    my $Pin    = "IntelliHome::Driver::" . $Type . "::" . $Driver;
    load_module($Pin);
    if ( $Driver eq "Dual" ) {
        my $Port = $Pin->new(
            onPin     => shift @args,
            offPin    => shift @args,
            Direction => shift @args
        );
    }
    else {
        my $Port = $Pin->new(
            Pin       => shift @args,
            Direction => shift @args
        );
    }
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
