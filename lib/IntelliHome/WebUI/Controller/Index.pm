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
# TODO: Add creation of tiles and rooms for every backend.

@rooms = sort ( @rooms );

$self->stash(
    tiles      => \@tiles,
    single        => 0,
    rooms => \@rooms
);
$self->render("index");
}


1;

