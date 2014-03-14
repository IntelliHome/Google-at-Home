package IH::Google::TTS;
use Moose;
require LWP::UserAgent;
use URI;
use Encode;

has 'Language' => ( default => "it", is => "rw" );
has 'text' => ( is => "rw" );
has 'base_url' =>
    ( default => "http://translate.google.com/translate_tts", is => "rw" );
has 'Result' => ( is => "rw" );
has 'tmp'    => ( is => "rw", default => "/var/tmp/ih" );
has 'out'    => ( is => "rw" );

sub tts {
    my $self = shift;
    my $text =  @_ ? encode_utf8(shift) : encode_utf8($self->text);
    my @Speech;
    mkdir( $self->tmp() )
        or die("Cannot create temporary directory")
        if ( !-d $self->tmp() );

    if ( length($text) gt 90 ) {
        @Speech = $text =~ /(.{1,90}\W)/gms;
    }
    else {
        push( @Speech, $text );
    }
    my $error = @Speech;
    for (@Speech) {
        $_=~s/\'|\è|\é//g;
        my $response = $self->_request($_);
        if ( $response->is_success ) {
            $self->Result( $self->Result . $response->decoded_content );
            $error--;
        }
    }
    return $error;
}
sub _request {
    my $self = shift;
    my $text = shift;
    my $url  = URI->new( $self->base_url );
    print "Eseguo $text\n";
    $url->query_form(
        'q'       => $text,
        'tl'      => $self->Language,
        'total'   => '1',
        'idx'     => '0',
        'textlen' => length($text),
        'prev'    => 'input'

    );

    my $ua = LWP::UserAgent->new;
    $ua->agent('Mozilla/5.0');
    $ua->timeout(10);
    $ua->env_proxy;
    $self->out( $self->tmp() . "/" . time().int(rand(10000)) . ".mp3" );
    return $ua->get( $url, ":content_file" => $self->out() );

}

1;
