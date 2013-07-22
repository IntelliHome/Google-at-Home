package IH::GSynth;
use Moo;
require IH::Interfaces::Terminal;
require  LWP::UserAgent;

has 'File' => (is=>"rw");
has 'Output' => (is=>"rw",default=> sub{ return new IH::Interfaces::Terminal});
has 'GoogleURL' => (is=>"rw",default=>"https://www.google.com/speech-api/v1/recognize?xjerr=1&maxresults=10&client=speech2text&lang=" );
has 'Language' => (is=>"rw",default=> "it");

sub synth(){
	my $self=shift;
	my $url = $self->GoogleURL. $self->Language;
	my @hypotheses = ();
	my $audio      = '';
	$self->Output()->info("Synthesys of ".$Self->File ." delegated to google (do you know a better machine learning as googlebrain?)");
 	open( FILE, "<" . $self->File );
	while (<FILE>) {
		$audio .= $_;
	}
	close(FILE);
	my $ua       = LWP::UserAgent->new;
	my $response = $ua->post(
		$url,
		Content_Type => "audio/x-flac; rate=16000",
		Content      => $audio
	);
	if ( $response->is_success ) {
		$result = $response->content;
	}
	while (  $result =~ m/\"utterance\"\:\"(.*?)\"/g ) {
		push( @hypotheses, $1 );
	}
	unlink($Self->File);
	
	return 0 if @hypotheses <= 0;
	return @hypotheses;
}




1;