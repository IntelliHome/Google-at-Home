package IH::Google::AutoSuggest;
use Moo;
use HTTP::Request::Common qw(GET);
use LWP::UserAgent;
use URI;
use JSON;
use Encode;

has 'domain'      => ( is => "rw", default => "com" );
has 'UA'          => ( is => "rw", default => "Mozilla/5.0" );    #eheh
has 'url'         => ( is => "rw" );
has 'base_url'    => ( is => "rw", default => "/s" );
has 'format_html' => ( is => "rw", default => 0 );

sub BUILD {
    my $self = shift;
    $self->url( "https://www.google." . $self->domain . $self->base_url );
}

sub search {
    my $self = shift;
    my $term = shift;
    my $ua   = LWP::UserAgent->new;
    $ua->agent( $self->UA );
    my $url = URI->new( $self->url );   # makes an object representing the URL
    $url->query_form(                   # And here the form data pairs:
        'q'     => $term,
        'gs_ri' => 'psy-ab',
    );
    my $res = $ua->get($url);
    if ( $res->is_success ) {
        my $Response = decode_json( $res->content );
        return map { $_ = encode( 'utf8', $_->[0] ) } @{ $Response->[1] };
    }
    else {
        return $res->status_line;
    }

}

1;
