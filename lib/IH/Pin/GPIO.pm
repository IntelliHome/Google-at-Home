package IH::Pin::GPIO;

use Moo;
use IH::Interfaces::Terminal;
has 'GpioDir'  => ( is => "rw", default => "/sys/class/gpio/gpio" );
has 'Exporter' => ( is => "rw", default => "/sys/class/gpio/export" );
has 'Pin'      => ( is => "rw" );
has 'Direction' => ( is => "rw" );
has 'Status'    => ( is => "rw" );
has 'Output' =>
    ( is => "rw", default => sub { return new IH::Interfaces::Terminal } );
has 'Connector' => ( is => "rw" );

sub BUILD { shift->Sync; }

sub on {
    my $self = shift;
    if ( $self->Connector ) {
        $self->Connector->send_command(
            $self->Pin . ":1:" . $self->Direction );
    }
    else {
        $self->setValue(1);    #Led Off
        $self->Status(1);
        $self->Output->info( $self->Pin . " -> " . $self->Status );
    }
}

sub off {
    my $self = shift;
    if ( $self->Connector ) {
        $self->Connector->send_command(
            $self->Pin . ":0:" . $self->Direction );
    }
    else {
        $self->setValue(0);    #Led On
        $self->Status(0);
        $self->Output->info( $self->Pin . " -> " . $self->Status );
    }
}

sub toggle {
    my $self = shift;

    my $Status = $self->Status();
    if ( $Status == 1 ) {
        $self->off();
    }
    else {
        $self->on();
    }
    $self->Output->info( $self->Pin . " -> " . $self->Status );
}

sub status {
    my $self = shift;
    open my $PIN, "<", $self->GpioDir . $self->Pin . "/value";
    my @currentValue = <$PIN>;
    chomp(@currentValue);
    close($PIN);
    $self->Status( $currentValue[0] );

    #chop $currentValue[0];
    return $currentValue[0];
}

sub setValue {
    my $self  = shift;
    my $value = shift;
    $self->Output->info( "Setting " . $self->Pin . " to $value" );
    open my $PIN, ">", $self->GpioDir . $self->Pin . "/value";
    print $PIN $value;
    close($PIN);
}

sub Sync {
    my $self = shift;
    $self->Output->info( "Synchronizing " . $self->Pin );
    if ( !-d $self->GpioDir . $self->Pin ) {
        $self->Output->info("Pin not initialized yet");
        if ( open my $EXPORTER, ">", $self->Exporter ) {
            print $EXPORTER $self->Pin;
            close($EXPORTER);
        }
        else {
            $self->Output->error("No Handle to setup pin");
        }
    }
    if ( open my $PIN, ">", $self->GpioDir . $self->Pin . "/direction" ) {
        print $PIN $self->Direction;
        close($PIN);
    }
    else {
        $self->Output->error("No Handle to setup direction") and2 return undef;
    }
    return $self;
}

1;
