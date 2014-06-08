package IntelliHome::Driver::GPIO::Base;

use Moo;
use IntelliHome::Interfaces::Terminal;
use IntelliHome::Utils qw(message_compact SEPARATOR);

has 'GpioDir'  => ( is => "rw", default => "/sys/class/gpio/gpio" );
has 'Exporter' => ( is => "rw", default => "/sys/class/gpio/export" );
has 'Direction' => ( is => "rw" );
has 'Status'    => ( is => "rw" );
has 'Output'    => (
    is      => "rw",
    default => sub { return IntelliHome::Interfaces::Terminal->instance }
);
has 'Connector' => ( is => "rw" );

sub BUILD { shift->Sync; }

sub initialize {
    my $self      = shift;
    my $Pin       = shift;
    my $Direction = shift;
    if ( !-d $self->GpioDir . $Pin ) {
        $self->Output->info("Pin $Pin not initialized yet");
        if ( open my $EXPORTER, ">", $self->Exporter ) {
            print $EXPORTER $Pin;
            close($EXPORTER);
            if ( -d $self->GpioDir . $Pin ) {
                if ( open my $PIN,
                    ">", $self->GpioDir . $Pin . "/direction" )
                {
                    print $PIN $Direction;
                    close($PIN);
                    return 1;
                }
                else {
                    $self->Output->error("No Handle to setup direction");
                }
            }
        }
        else {
            $self->Output->error("No Handle to setup pin");
        }
    }
    else {
        return 1;
    }
    return 0;
}

1;
