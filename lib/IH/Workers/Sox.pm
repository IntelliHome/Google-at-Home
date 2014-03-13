package IH::Workers::Sox;
use Moose;
use Fcntl qw(:DEFAULT :flock);

with("IH::Workers::Process");

has 'command'             => ( is => "rw" );
has 'Rate'                => ( is => "rw", default => "16000" );
has 'HW'                  => ( is => "rw", default => "1,0" );
has 'Output'              => ( is => "rw", default => "ih.flac" );
has 'beginEnable'         => ( is => "rw", default => "1" );
has 'beginSoundDuration'  => ( is => "rw", default => "0.5" );
has 'beginThreshold'      => ( is => "rw", default => '1%' );
has 'finishEnable'        => ( is => "rw", default => "1" );
has 'finishSoundDuration' => ( is => "rw", default => "3.0" );
has 'finishThreshold'     => ( is => "rw", default => '2%' );
has 'Directory'           => ( is => "rw", default => "/var/tmp/sox/" );
has 'Filters' => (
    is      => "rw",
    default => "trim 0 12 compand 0.3,1 6:-70,-60,-20 -5 -90 0.2"
);

#XXX: "treble 10 3.5k" or "bass -10 300"  http://sox.10957.n7.nabble.com/band-pass-filter-for-voices-td3607.html

sub _generateOutputCommand {
    my $self = shift;
    mkdir( $self->Directory ) if ( !-d $self->Directory );

    $self->command(
        defined $self->HW
        ? "sox -b 32 -t alsa hw:"
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
        : "rec -b 32 -r "
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

    #Called on start by IH::Workers::Process
    my $self = shift;
    foreach my $file ( glob $self->Directory . "*.flac" ) {

        # open FILE, "<" . $file;
        # if ( flock( FILE, 1 ) ) {
        #     unlink $file;

        # }
    }

}

1;
