package IH::GSynth;
use Moo;
use Try::Tiny;
use Time::HiRes qw(usleep ualarm gettimeofday tv_interval);
require IH::Interfaces::Terminal;
require  LWP::UserAgent;

has 'File' => (is=>"rw");
has 'Output' => (is=>"rw",default=> sub{ return new IH::Interfaces::Terminal});
has 'GoogleURL' => (is=>"rw",default=>"https://www.google.com/speech-api/v1/recognize?xjerr=1&maxresults=10&client=speech2text&lang=" );
has 'Language' => (is=>"rw",default=> "it");
has 'hypotheses' => (is=>"rw");
has 'Time' => (is=>"rw");
sub synth(){
	my $self=shift;
	    return 0 if($self->File =~ /^0$/);

	my $audio;

	$self->Output()->info("Synthesys of ".$self->File ." delegated to google (do you know a better machine learning as googlebrain?)");
 	open( FILE, "<" . $self->File ) or $self->Output->error("Cannot open ".$self->File);
	while (<FILE>) {
		$audio .= $_;
	}
	close(FILE);
	
	$self->audiosynth($audio);
	my @hypotheses = $self->hypotheses;
	#unlink($self->File);

	return 0 if @hypotheses <= 0;
	return @hypotheses;
}


sub audiosynth(){
	my $self=shift;
	my $audio=shift;
		my $url = $self->GoogleURL. $self->Language;
			    my $request_arrival_time = [gettimeofday];
	my $result;
	my $response;
	my @hypotheses = ();
try {
		my $ua       = LWP::UserAgent->new;
		 $response = $ua->post(
			$url,
			Content_Type => "audio/x-flac; rate=16000",
			Content      => $audio
		);
	} catch {
		$self->Output->error("Error processing to google: $_");
	};
	if (defined $response and $response->is_success ) {
		$result = $response->content;
		$self->Output->info("Google answered, good.");
	}
	if(defined $result ){
		while (  $result =~ m/\"utterance\"\:\"(.*?)\"/g ) {
			push( @hypotheses, $1 );
		}
	}
	$self->hypotheses(\@hypotheses);

	my $elapsed = tv_interval( $request_arrival_time, [gettimeofday] );
	$self->Time($elapsed);

}


1;