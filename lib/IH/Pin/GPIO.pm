package Pin::GPIO;

    use Moo;
    use Moose::Util::TypeConstraints;
    subtype 'direction', as 'Str',
        where { ( $_ eq "in" ) or ( $_ eq "out" ) };

    has 'Pin'       => ( isa => "Int",       is => "rw" );
    has 'Direction' => ( isa => "direction", is => "rw" );
    has 'Status'    => ( is  => "rw" );

    our $Default_dir = "/sys/class/gpio/gpio";
    our $Export_file = "/sys/class/gpio/export";

    sub on() {
        my $self = shift;

        $self->setValue(1);    #Led Off
        $self->Status(1);
    }

    sub off() {
        my $self = shift;

        $self->setValue(0);    #Led On
        $self->Status(0);
    }

    sub toggle() {
        my $self = shift;

        my $Status = $self->Status();
        print "Status is $Status\n";
        if ( $Status == 1 ) {
            $self->off();
        }
        else {
            $self->on();
        }

    }

    sub status() {
        my $self = shift;

        open my $PIN, "<", $Default_dir . $self->Pin . "/value";
        my @currentValue = <$PIN>;
        chomp(@currentValue);
        close($PIN);

        #chop $currentValue[0];
        return $currentValue[0];
    }

    sub setValue() {
        my $self  = shift;
        my $value = shift;
        print "Setting " . $self->Pin . " to $value\n";
        open my $PIN, ">", $Default_dir . $self->Pin . "/value";
        print $PIN $value;
        close($PIN);
    }

    sub Sync() {
        my $self = shift;

        print "Synchronizing " . $self->Pin . "\n";
        if ( !-d $Default_dir . $self->Pin ) {
            print "Pin not initialized yet\n";
            if ( open my $EXPORTER, ">", $Export_file ) {
                print $EXPORTER $self->Pin;
                close($EXPORTER);
            }
            else {
                print "No Handle to setup pin\n";
            }
        }
        if ( open my $PIN, ">", $Default_dir . $self->Pin . "/direction" ) {
            print $PIN $self->Direction;
            close($PIN);
        }
        else {
            print "No Handle to setup direction\n";
        }
    }


1;
