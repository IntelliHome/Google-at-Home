package IntelliHome::WebUI::Controller::Pages;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(hmac_sha1_sum);
use List::Util qw(min max);
use POSIX;
use Encode;
use IntelliHome::WebUI::Model::Tile;

sub index {
    my $self = shift;

    #User login
    #if ( my $user = $self->session("username") ) {
    #User is logged.
    #}
    #
    my @tiles = $self->app->build_tiles();

    $self->stash(
        tiles  => \@tiles,
        single => 0,
        logged => 0,
        admin  => 0
    );
    $self->render("index");
}

sub admin {
    my $self = shift;
    $self->session( "logged" => 1, "admin" => 1 );
    $self->redirect_to('/admin/gpios');
}

sub admin_gpios {
    my $self  = shift;
    my @gpios = $self->app->build_tiles();

    $self->stash( gpios => \@gpios, );
    $self->render("gpios");
}

1;

