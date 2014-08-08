package IntelliHome::IntelliHomeWebUI;

use strict;

use Cwd;

use 5.008_005;

our $VERSION = '0.01';

use Mojo::Base 'Mojolicious';

use Mojo::Loader;
use IO::Compress::Gzip 'gzip';
use Mojolicious::Plugin::BootstrapAlerts;
use Mojolicious::Plugin::AssetPack;
use Mojolicious::Plugin::StaticCompressor;
use Mojolicious::Plugin::Bootstrap3;

has 'rooms';

sub startup {

    my $app = shift;
################# Basic plugin loading
    $app->plugin( 'Config' => { file => './config/webui.conf' } );
    $app->plugin('StaticCompressor');
    $app->plugin('AssetPack');
    $app->plugin("BootstrapAlerts");
    $app->plugin("bootstrap3");
################# Assets definitions

    # script.js and extern.js are bundled in the app.js asset

    $app->asset(
        'app.js' => '/js/functions_script.js',
        '/js/isotope_script.js'
    );
    $app->asset( 'login.js' => '/js/login_script.js' );
    $app->asset( 'style.css' =>
            ( '/css/style.css', '/css/user-panel.css', '/css/isotope.css' ) );
    $app->asset( 'login-style.css' => '/css/login.css' );

    # assets from web

    $app->asset(
        'web.js' => (
            '/js/libs/isotope.pkgd.min.js',
            '/js/libs/jquery.infinitescroll.min.js',
            '/js/libs/imagesloaded.js',
            '/js/libs/fitcolumns.js',
            '/js/libs/hammer.js',
            '/js/libs/jquery.hammer.js',
            '/js/libs/extern.js'
        )
    );

################# Load plugin namespace

    push @{ $app->plugins->namespaces }, 'IntelliHome::WebUI::Plugin';
    $app->static->paths(   ['./assets/public'] );
    $app->renderer->paths( ['./assets/templates'] );

################# GZip Compression

    $app->hook(

        after_render => sub {

            my ( $c, $output, $format ) = @_;

            # Check if "gzip => 1" has been set in the stash

            return if ( exists $c->stash->{gzip} and $c->stash->{gzip} == 0 );

            # Check if user agent accepts GZip compression

            return

                unless ( $c->req->headers->accept_encoding // '' ) =~ /gzip/i;

            $c->res->headers->append( Vary => 'Accept-Encoding' );

            # Compress content with GZip

            $c->res->headers->content_encoding('gzip');

            gzip $output, \my $compressed;

            $$output = $compressed;

            }

    );

################# Room dispatch
    #$app->rooms( "search for rooms on rpc" );
    #$app->hook(
    #    before_dispatch => sub {
    #        my $app = shift;

    #        my @rooms = sort (@{ $app->app->rooms });
    #        $app->stash( rooms => \@rooms);

    #    }
    #);
################# Routes

    my $r = $app->routes;

    $r->namespaces( ['IntelliHome::WebUI::Controller'] );

    # Index

    $r->any('/')->to('index#index');

    $r->any('/index')->to('index#index');

}

1;
