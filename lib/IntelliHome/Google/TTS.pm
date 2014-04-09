package IntelliHome::Google::TTS;

=head1 NAME

IntelliHome::Google::TTS - Generate audio files from the given text using Google services

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
require LWP::UserAgent;
use URI;
use Encode;

has 'Language' => ( default => "en", is => "rw" );
has 'text' => ( is => "rw" );
has 'base_url' =>
    ( default => "http://translate.google.com/translate_tts", is => "rw" );
has 'Result'    => ( is => "rw" );
has 'tmp'       => ( is => "rw", default => "/var/tmp/ih" );
has 'out'       => ( is => "rw" );
has 'Sentences' => ( is => "rw", default => sub { [] } );
has 'responses' => ( is => "rw", default => sub { [] } );

sub tts {
    my $self = shift;
    my $text = @_ ? shift : $self->text;
    return if !$text;
   # $text=encode_utf8($text);
    my @Speech;
    mkdir( $self->tmp() )
        or die("Cannot create temporary directory")
        if ( !-d $self->tmp() );

    if ( length($text) > 100 ) {
        @Speech = $text =~ m/(.{1,100}\W)/gs;

    }
    else {
        push( @Speech, $text );
    }
    my $error = scalar(@Speech);
    $self->Sentences( \@Speech );
    $self->responses( [] );
    foreach my $sentence (@Speech) {
        my $response = $self->_request($sentence);
        if ( $response->is_success ) {
            $self->Result(
                  $self->Result
                ? $self->Result . $response->decoded_content
                : $response->decoded_content
            );
            $error--;
        }
    }
    my $compound
        = $self->tmp() . "/compound-" . time() . int( rand(10000) ) . ".mp3";
    foreach my $Audio ( @{ $self->responses } ) {
        open my $File, "<$Audio";
        binmode($File);
        my @F = <$File>;
        open my $Join, ">>$compound";
        binmode($Join);
        print $Join @F;
        close $Join;
        close $File;
    }
    $self->out($compound);
    return $error;
}

sub _request {
    my $self = shift;
    my $text = shift;
    my $url  = URI->new( $self->base_url );
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
    $ua->timeout(30);
    $ua->env_proxy;

    # $self->out( $self->tmp() . "/" . time().int(rand(10000)) . ".mp3" );
    my $file = $self->tmp() . "/" . time() . int( rand(10000) ) . ".mp3";
    my $response = $ua->get( $url, ":content_file" => $file );
    if ( -e $file ) {
        push( @{ $self->responses }, $file );
    }
    return $response;

}

1;
