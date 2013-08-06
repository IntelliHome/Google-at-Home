package IH::Google::TTS;
use Moose;
 require LWP::UserAgent;
use URI;

has 'language' => (default=>"it",is=>"rw");
has 'text' => (is=>"rw");
has 'base_url' =>(default=>"http://translate.google.com/translate_tts",is=>"rw");
has 'Result' =>(is=>"rw");
has 'tmp' => (is=>"rw", default=>"/var/tmp/ih");
has 'out' => (is=>"rw");
sub tts(){
	my $self=shift;

mkdir($self->tmp()) || die("Cannot create temporary directory")  if (!-d $self->tmp());
my $url = URI->new($self->base_url);
$url->query_form( 'q' => $self->text, 'tl' => $self->language, 'total' => '1',
'idx' => '0',
'textlen' => length($self->text),
'prev' => 'input'

	);
 
 my $ua = LWP::UserAgent->new;
   $ua->agent('Mozilla/5.0');
 $ua->timeout(10);
 $ua->env_proxy;
 $self->out($self->tmp()."/".time().".mp3");
 my $response = $ua->get($url
,    ":content_file"   => $self->out()
 	);
 
 if ($response->is_success) {
 				$self->Result($response->decoded_content);
 				return 1;
 }
 else {
 	$self->Result($response->status_line);
     return 0;
 }



}


1;