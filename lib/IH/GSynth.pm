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
	    my $request_arrival_time = [gettimeofday];
	    return 0 if($self->File =~ /^0$/);
	my $url = $self->GoogleURL. $self->Language;
	my @hypotheses = ();
	my $audio;
	my $result;
	my $response;
	$self->Output()->info("Synthesys of ".$self->File ." delegated to google (do you know a better machine learning as googlebrain?)");
 	open( FILE, "<" . $self->File ) or $self->Output->error("Cannot open ".$self->File);
	while (<FILE>) {
		$audio .= $_;
	}
	close(FILE);
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
	unlink($self->File);
	$self->hypotheses(\@hypotheses);
	my $elapsed = tv_interval( $request_arrival_time, [gettimeofday] );
	$self->Time($elapsed);
	return 0 if @hypotheses <= 0;
	return @hypotheses;
}




1;