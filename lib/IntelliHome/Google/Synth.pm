package IntelliHome::Google::Synth;

=head1 NAME

IntelliHome::Google::Synth - Synthetizes flac files and returns google synth's hypothesis

=head1 DESCRIPTION

This Object synthetizes the file supplied via C<File> argument and returns a list of hypotesis using Google Services


=head1 ATTRIBUTES 

=over 4

=item File() 

Get/Set the file to synthetize

=item Language() 

Get/Set the language

=back

=head1 FUNCTIONS

=over 4

=item synth()

send to google services the files and return a list of hypothesis

=back

=cut

use Moose;
use Try::Tiny;
use Time::HiRes qw(usleep ualarm gettimeofday tv_interval);
require IntelliHome::Interfaces::Terminal;
require LWP::UserAgent;

has 'File' => ( is => "rw" );
has 'Output' =>
    ( is => "rw", default => sub { return IntelliHome::Interfaces::Terminal->new } );
has 'GoogleURL' => (
    is => "rw",
    default =>
        "https://www.google.com/speech-api/v1/recognize?xjerr=1&maxresults=10&client=speech2text&lang=" #huh
);
has 'Language' => ( is => "rw", default => "en" );
has 'hypotheses' => ( is => "rw" );
has 'Time'       => ( is => "rw" );

sub synth {
    my $self = shift;
    return 0 if ( $self->File =~ /^0$/ );

    my $File = @_ ? shift : $self->File;
    return if !$File;

    my $audio;

    $self->Output()
        ->info( "Synthesys of "
            . $File
            . " delegated to google (do you know a better machine learning as googlebrain?)"
        );
    open( FILE, "<" . $File )
        or $self->Output->error( "Cannot open " . $File );
    while (<FILE>) {
        $audio .= $_;
    }
    close(FILE);

    $self->audiosynth($audio);
    my @hypotheses = $self->hypotheses;
    unlink( $File );

    return 0 if @hypotheses <= 0;
    return @hypotheses;
}

sub audiosynth {
    my $self                 = shift;
    my $audio                = shift;
    my $url                  = $self->GoogleURL . $self->Language;
    my $request_arrival_time = [gettimeofday];
    my $result;
    my $response;
    my @hypotheses = ();
    try {
        my $ua = LWP::UserAgent->new;
        $response = $ua->post(
            $url,
            Content_Type => "audio/x-flac; rate=16000",
            Content      => $audio
        );
        $ua->timeout(10);
    }
    catch {
        $self->Output->error("Error processing to google: $_");
    };
    if ( defined $response and $response->is_success ) {
        $result = $response->content;
        $self->Output->debug("Google answered, good.");
        $self->Output->debug($result) if $result;
    }
    if ( defined $result ) {
        while ( $result =~ m/\"utterance\"\:\"(.*?)\"/g ) {
            push( @hypotheses, $1 );
        }
    }
    $self->hypotheses( \@hypotheses );

    my $elapsed = tv_interval( $request_arrival_time, [gettimeofday] );
    $self->Time($elapsed);

}

1;
