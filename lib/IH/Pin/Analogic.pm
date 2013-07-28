package IH::Pin::Analogic;
use Moo;

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
