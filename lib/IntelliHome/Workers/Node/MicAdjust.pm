package IntelliHome::Workers::Node::MicAdjust;

=head1 NAME

IntelliHome::Workers::Node::MicAdjust - This thread auto adjusts and also set mic levels

=head1 DESCRIPTION

This Object tries to auto adjusts and also set mic levels based on maximum amplitude using 'rec'

=head1 USAGE

This object is used internally by G@H

=cut

use Moo;
use Carp qw( croak );
use feature 'say';
with("IntelliHome::Workers::Thread");    #is a thread
has 'lower_threshold' => ( is => "rw", default => "0.015" );
has 'upper_threshold' => ( is => "rw", default => "0.021" );
has 'step'            => ( is => "rw", default => 2 );
has 'boost'           => ( is => "rw", default => 0 );

sub set {
    my $self    = shift;
    my $control = shift;
    my $value   = shift;
    system("amixer set '$control' '$value' > /dev/null");
}

sub get_max_amplitude {
    my $self   = shift;
    #my $status = qx/rec -n stat trim 0 .5 2>&1/;
    #parec --record | sox -t raw -r 44100 -sLb 16 -c 2 - -n stat trim 0 .5 2>&1
    my $status = qx/parec --record | sox -t raw -r 44100 -sLb 16 -c 2 - -n stat trim 0 .5 2>&1/;

    $status =~ /^Maximum amplitude:\s*(.*?)$/mgi;
    return $1;
}

sub run {
    my $self            = shift;
    my $lower_threshold = $self->lower_threshold;
    my $upper_threshold = $self->upper_threshold;
    while ( 1 ) {
        my $amplitude = $self->get_max_amplitude;
        if ( $amplitude > $upper_threshold ) {
            say "Threshold decreased of "
                . $self->step
                . " %, amplitude is : $amplitude";
                  #      $self->set( "Internal Mic Boost", $self->boost );

            $self->set( "Capture", $self->step . '%-' );

        }
        elsif ( $amplitude < $lower_threshold ) {
            say "Threshold decreased of "
                . $self->step
                . " %, amplitude is : $amplitude";
               #         $self->set( "Internal Mic Boost", $self->boost );

            $self->set( "Capture", $self->step . '%+' );

        }
    }

}

sub launch {
    my $self = shift;
    $self->callback( \&run );
        $self->set( "Internal Mic Boost", $self->boost );
    $self->args( [$self] );
    $self->start();
}

1;
