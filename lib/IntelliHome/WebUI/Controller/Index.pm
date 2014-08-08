package IntelliHome::WebUI::Controller::Index;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(hmac_sha1_sum);
use List::Util qw(min max);
use POSIX;
use Encode;
use IntelliHome::WebUI::Model::Tile;
use IntelliHome::WebUI::Plugin::ModelFactory;

sub index {
    my $self = shift;
    my @tiles;
    my @rooms;

    #User login
    #if ( my $user = $self->session("username") ) {
    #User is logged.
    #}
    #
    my @tiles = $self->build_tiles("gpio");

    $self->stash(
        tiles  => \@tiles,
        single => 0,
        logged => 0,
        admin  => 0
    );
    $self->render("index");
}

1;

