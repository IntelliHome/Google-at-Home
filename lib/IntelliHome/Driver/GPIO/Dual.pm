package IntelliHome::Driver::GPIO::Dual;
use Moo;

extends 'IntelliHome::Driver::GPIO::Base';
use constant DRIVER => ( split( "::", __PACKAGE__ ) )[-1];
use constant TYPE   => ( split( "::", __PACKAGE__ ) )[-2];
has 'onPin'  => ( is => "rw" );
has 'offPin' => ( is => "rw" );

sub on {
    my $self = shift;
    if ( $self->Connector )
    {    # if it's defined a connector, the command will be sent to a node
        $self->Status(1);
        return $self->Connector->send_command(
            message_compact(
                TYPE,             DRIVER,
                $self->onPin,     $self->offPin,
                $self->Direction, "on"
            )
        );
    }
    else {
        $self->setValue( 0, $self->offPin );    #Led Off
        $self->setValue( 1, $self->onPin );     #Led Off
        $self->Status(1);
        $self->Output->info( $self->onPin . " -> " . $self->Status );
        return $self->Status;
    }
}

sub off {
    my $self = shift;
    if ( $self->Connector )
    {    # if it's defined a connector, the command will be sent to a node
        $self->Status(0);
        return $self->Connector->send_command(
            message_compact(
                TYPE,             DRIVER,
                $self->onPin,     $self->offPin,
                $self->Direction, "off"
            )
        );
    }
    else {
        $self->setValue( 1, $self->offPin );    #Led Off
        $self->setValue( 0, $self->onPin );     #Led Off
        $self->Status(0);
        $self->Output->info( $self->offPin . " -> " . $self->Status );
        return $self->Status;
    }
}

sub toggle {
    my $self = shift;
    $self->Output->info( $self->onPin . " -> " . $self->Status );
    if ( $self->Status() == 1 ) {
        $self->off();
    }
    else {
        $self->on();
    }
}

sub status {
    my $self = shift;
    my $Pin  = shift;
    open my $PIN, "<", $self->GpioDir . $Pin . "/value";
    my @currentValue = <$PIN>;
    chomp(@currentValue);
    close($PIN);
    $self->onStatus( $currentValue[0] )  if $Pin eq $self->onPin;
    $self->offStatus( $currentValue[0] ) if $Pin eq $self->offPin;

    #chop $currentValue[0];
    return $currentValue[0];
}

sub setValue {
    my $self  = shift;
    my $value = shift;
    my $Pin   = shift;
    $self->Output->info( "Setting " . $Pin . " to $value" );
    open my $PIN, ">", $self->GpioDir . $Pin . "/value";
    print $PIN $value;
    close($PIN);
    return $value;
}

sub Sync {
    my $self = shift;
    $self->Output->info( "Synchronizing " . $self->onPin );
    if ( $self->initialize( $self->onPin, $self->Direction ) ) {
        $self->Output->info( "Sync OK for " . $self->onPin );
    }
    else {
        $self->Output->info(
            "Something went wrong with initialization of the Pin");
    }
    $self->Output->info( "Synchronizing " . $self->offPin );
    if ( $self->initialize( $self->offPin, $self->Direction ) ) {
        $self->Output->info( "Sync OK for " . $self->offPin );
    }
    else {
        $self->Output->info(
            "Something went wrong with initialization of the Pin");
    }
    return $self;
}

1;
