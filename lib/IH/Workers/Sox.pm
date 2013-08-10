package IH::Workers::Sox;
use Moose;
with("IH::Workers::Process");

has 'command'             => ( is => "rw" );
has 'Rate'                => ( is => "rw", default => "16000" );
has 'HW'                  => ( is => "rw", default => "0,0" );
has 'Output'              => ( is => "rw", default => "ih.flac" );
has 'beginEnable'         => ( is => "rw", default => "1" );
has 'beginSoundDuration'  => ( is => "rw", default => "0.5" );
has 'beginThreshold'      => ( is => "rw", default => '1%' );
has 'finishEnable'        => ( is => "rw", default => "1" );
has 'finishSoundDuration' => ( is => "rw", default => "3.0" );
has 'finishThreshold'     => ( is => "rw", default => '2%' );
has 'Directory'           => ( is => "rw", default => "/var/tmp/sox/" );

sub _generateOutputCommand() {
    my $self = shift;
    mkdir( $self->Directory ) if ( !-d $self->Directory );

    $self->command(

        "sox -b 32 -t alsa hw:"
            . $self->HW() . " -r "
            . $self->Rate() . " "
            . $self->Directory()
            . $self->Output()
            . " silence "
            . $self->beginEnable() . " "
            . $self->beginSoundDuration . " "
            . $self->beginThreshold() . " "
            . $self->finishEnable() . " "
            . $self->finishSoundDuration . " "
            . $self->finishThreshold()
            . " : newfile : restart"

    );
}

1;
