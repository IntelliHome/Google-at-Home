package IntelliHome::WebUI::Controller::Index;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(hmac_sha1_sum);
use List::Util qw(min max);
use POSIX;
use Encode;
use IntelliHome::WebUI::Model::Tile;

sub index {
my $self = shift;
my @tiles;
my @rooms;
#User login
#if ( my $user = $self->session("username") ) {
    #User is logged.
#}
#

$self->stash(
    tiles      => \@tiles,
    single        => 0,
);
$self->render("index");
}


1;

