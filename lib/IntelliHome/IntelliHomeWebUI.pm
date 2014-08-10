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
has 'node_types';

sub startup {

    my $app = shift;

################# Load plugin namespace

    push @{ $app->plugins->namespaces }, 'IntelliHome::WebUI::Plugin';
    $app->static->paths(   ['./assets/public'] );
    $app->renderer->paths( ['./assets/templates'] );

################# Basic plugin loading
    $app->plugin( 'Config' => { file => './config/webui.conf' } );
    $app->plugin('StaticCompressor');
    $app->plugin('AssetPack');
    $app->plugin("BootstrapAlerts");
    $app->plugin( bootstrap3 => { jquery => 0 } );
################# Custom Plugin
    $app->plugin("ModelFactory");
    $app->plugin("RPC");

################# Assets definitions
    $app->asset(
        'app.js' => '/js/functions_script.js',
        '/js/isotope_script.js'
    );
    $app->asset( 'login.js' => '/js/login_script.js' );
    $app->asset(
        'style.css' => (
            '/css/style.css',   '/css/user-panel.css',
            '/css/isotope.css', '/css/jquery.tzineClock.css',
            'css/font-awesome.css'
        )
    );
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
            '/js/libs/extern.js',
            '/js/libs/jquery.tzineClock.js'
        )
    );

    $app->asset( 'jquery.js' =>
            ( '/js/libs/jquery.min.js', '/js/libs/jquery-migrate.min.js' ) );

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
    $app->rooms(
        [ map { $_ = $_->name; $_ } @{ $app->app->build_rooms() } ] );
    $app->hook(
        before_dispatch => sub {
            $_[0]->stash( rooms => shift->app->rooms );
        }
    );
################# Node types dispatch
    $app->node_types( [qw(master node agent)] );
    $app->hook(
        before_dispatch => sub {
            $_[0]->stash( node_types => shift->app->node_types );
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
__END__

=encoding utf-8

=head1 NAME

IntelliHome::IntelliHomeWebUI - Mojolicious web application for IntelliHome

=head1 SYNOPSIS

  $ perl intellihome-master #Starting the master will launch also the web interface
  $ morbo bin/intellihome-webui # for developing purposes
  $ hypnotoad bin/intellihome-webui #forking webserver

=head1 DESCRIPTION

This is the top module containing the routes to make the web interface working. This module communicate with the IntelliHome libs thru the RPC server, acting as a layer between the user and the libs itself. It uses the L<IntelliHome::WebUI::Plugin::ModelFactory> and L<IntelliHome::WebUI::Plugin::RPC>

=head1 ROUTES


=head1 AUTHOR

skullbocks E<lt>dgikiller@gmail.comtE<gt>

=head1 COPYRIGHT

Copyright 2014- skullbocks

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO
L<IntelliHome::WebUI::Plugin::ModelFactory>, L<IntelliHome::WebUI::Plugin::RPC>

=cut

