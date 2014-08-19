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
        tiles      => \@tiles,
        single     => 0,
        show_tiles => 1,
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
    my @nodes = $self->app->build_nodes();

    $self->stash(
        gpios => \@gpios,
        gpio_types=> [1,2,3],
        nodes => \@nodes
    );
    $self->render("gpios");
}

sub admin_nodes {
    my $self  = shift;
    my @nodes = $self->app->build_nodes();

    $self->stash( nodes => \@nodes, node_types=>["master","node","agent"]);
    $self->render("nodes");
}

sub admin_rooms {
    my $self = shift;
    $self->render("rooms");
}

sub logout {
    my $self = shift;
    $self->session( "logged" => 0, "admin" => 0 );
    $self->redirect_to('/');
}

1;

