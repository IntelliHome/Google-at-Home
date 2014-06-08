package IntelliHome::Driver::GPIO::Mono;

use Moo;
use constant DRIVER => "Mono";

extends 'IntelliHome::Driver::GPIO::Base';
has 'Pin' => ( is => "rw" );

sub on {
    my $self = shift;
    if ( $self->Connector )
    {    # if it's defined a connector, the command will be sent to a node
        return $self->Connector->send_command(
            message_compact( DRIVER,$self->Pin, 1, $self->Direction ) );
    }
    else {
        $self->setValue(1);    #Led Off
        $self->Status(1);
        $self->Output->info( $self->Pin . " -> " . $self->Status );
        return $self->Status;
    }
}

sub off {
    my $self = shift;
    if ( $self->Connector ) {
        return $self->Connector->send_command(
            message_compact(DRIVER,$self->Pin, 0, $self->Direction ) );
    }
    else {
        $self->setValue(0);    #Led On
        $self->Status(0);
        $self->Output->info( $self->Pin . " -> " . $self->Status );
        return $self->Status;
    }
}

sub toggle {
    my $self = shift;
    $self->Output->info( $self->Pin . " -> " . $self->Status );
    if ( $self->Status() == 1 ) {
        $self->off();
    }
    else {
        $self->on();
    }
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
    return $value;
}

sub Sync {
    my $self = shift;
    $self->Output->info( "Synchronizing " . $self->Pin );
    if ( $self->initialize( $self->Pin, $self->Direction ) ) {
        $self->Output->info("Sync OK");
    }
    else {
        $self->Output->info(
            "Something went wrong with initialization of the Pin");
    }
    return $self;
}

1;
