package IntelliHome::Pin::Analogic;
use Moo;
## XXX: not tested and not written yet, it's just sitting here for a mental bookmark
    has 'Pin' => ( is => "rw" );
our $Default_dir = "/sys/bus/platform/devices/at91_adc/chan";

sub get() {
    my $self = shift;
    open my $PIN, "<", $Default_dir . $self->Pin;
    my @currentValue = <$PIN>;
    chomp(@currentValue);
    close($PIN);
    return $currentValue[0];
}

1;
