package IntelliHome::IntelliHomeWebUI;


use strict;

use Cwd;
    
use 5.008_005;

our $VERSION = '0.01';

use Mojo::Base 'Mojolicious';

use Mojo::Loader;

use Mojolicious::Plugin::Disqus::Tiny;

use IO::Compress::Gzip 'gzip';

use Mojolicious::Plugin::BootstrapAlerts;

sub startup {

my $app = shift;


################# Basic plugin loading

$app->plugin('config');

$app->plugin('StaticCompressor');

$app->plugin('AssetPack');

$app->plugin("BootstrapAlerts");

$app->plugin("bootstrap3");


################# Assets definitions

# script.js and extern.js are bundled in the app.js asset

$app->asset( 'app.js' => '/js/script.js', '/js/extern.js' );

$app->asset( 'style.css' => '/css/style.css' );


# assets from web

$app->asset(

'web.js' => (

'/js/isotope.pkgd.min.js',

'/js/jquery.infinitescroll.min.js',

'/js/imagesloaded.pkgd.min.js'


)

);


################# Load plugin namespace

push @{ $app->plugins->namespaces }, 'IntelliHome::WebUI::Plugin';
$app->static->paths([cwd().'assets/public']);
$app->renderer->paths([cwd().'assets/templates']);

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


################# Routes

my $r = $app->routes;

$r->namespaces( ['IntelliHome::WebUI::Controller'] );


# Index

$r->any('/')->to('index#index');

$r->any('/index')->to('index#index');


}

1;
