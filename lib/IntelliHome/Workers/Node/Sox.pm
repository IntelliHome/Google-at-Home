package IntelliHome::Workers::Node::Sox;

=head1 NAME

IntelliHome::Workers::Node::Sox - This Process represent the Sox recording instance and generate the command to be executed

=head1 DESCRIPTION

This Object generate the configured command for sox and launch it

=head1 USAGE

This object is used internally by G@H

=cut

use Moo;
use Fcntl qw(:DEFAULT :flock);

with("IntelliHome::Workers::Process");

has 'command'             => ( is => "rw" );
has 'Rate'                => ( is => "rw", default => "16000" );
has 'HW'                  => ( is => "rw", default => "1,0" );
has 'Output'              => ( is => "rw", default => "ih.flac" );
has 'beginEnable'         => ( is => "rw", default => "1" );
has 'beginSoundDuration'  => ( is => "rw", default => "0.5" );
has 'beginThreshold'      => ( is => "rw", default => '1%' );
has 'finishEnable'        => ( is => "rw", default => "1" );
has 'finishSoundDuration' => ( is => "rw", default => "1.5" );
has 'finishThreshold'     => ( is => "rw", default => '2%' );
has 'Directory'           => ( is => "rw", default => "/var/tmp/sox/" );
has 'Filters' => (
    is      => "rw",
    default => "trim 0 12"
    #compand 0.3,1 6:-70,-60,-20 -5 -90 0.2
);

#parec --record | sox -t raw -r 44100 -sLb 16 -c 2 - -r 16000 -b 32 /var/tmp/sox/ih.flac trim 0 12 silence 1 0.5 1% 1 1.5 2% : newfile : restart


#XXX:  highpass 100  "treble 10 3.5k" or "bass -10 300"  http://sox.10957.n7.nabble.com/band-pass-filter-for-voices-td3607.html
#XXX: http://sox.cvs.sourceforge.net/viewvc/sox/sox/scripts/voice-cleanup.sh?revision=1.1&content-type=text%2Fplain
sub _generateOutputCommand {
    my $self = shift;
    mkdir( $self->Directory ) if ( !-d $self->Directory );

    $self->command(
        defined $self->HW
        ? "sox -q -t alsa hw:"
            . $self->HW() . " -r "
            . $self->Rate() . " "
            . $self->Directory()
            . $self->Output() . " "
            . $self->Filters
            . " silence "
            . $self->beginEnable() . " "
            . $self->beginSoundDuration . " "
            . $self->beginThreshold() . " "
            . $self->finishEnable() . " "
            . $self->finishSoundDuration . " "
            . $self->finishThreshold()
            . " : newfile : restart"
        : "parec --record | sox -t raw -r 44100 -sLb 16 -c 2 - -q -r "
            . $self->Rate() . " "
            . $self->Directory()
            . $self->Output() . " "
            . $self->Filters
            . " silence "
            . $self->beginEnable() . " "
            . $self->beginSoundDuration . " "
            . $self->beginThreshold() . " "
            . $self->finishEnable() . " "
            . $self->finishSoundDuration . " "
            . $self->finishThreshold()
            . " : newfile : restart"

    );
    print $self->command . "\n";
}

sub clean {

    #Called on start by IntelliHome::Workers::Process
    my $self = shift;
   # foreach my $file ( glob $self->Directory . "*.flac" ) {

   #     open FILE, "<" . $file;
   #       if ( flock( FILE, 1 ) ) {
   #        close FILE;
   #           unlink $file;
   #       }
   #  }

}

1;
