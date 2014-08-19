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
has 'gpio_types';
has 'drivers';

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
            '/css/font-awesome.css'
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
    $app->rooms( [$app->app->build_rooms()] );
    $app->hook(
        before_dispatch => sub {
            $_[0]->stash( rooms => shift->app->rooms )
                if $_[0]->app->rooms;
        }
    );
################# Node types dispatch
    $app->node_types( [qw(master node agent)] );
    $app->hook(
        before_dispatch => sub {
            $_[0]->stash( node_types => shift->app->node_types );
        }
    );
################# GPIO types dispatch
    # TODO: pass types from rpc query
    $app->node_types( [qw(analog switch)] );
    $app->hook(
        before_dispatch => sub {
            $_[0]->stash( gpio_types => shift->app->gpio_types );
        }
    );
################# Drivers types dispatch
    # TODO: pass drivers from rpc query
    $app->drivers(
        [qw(IntelliHome::Driver::GPIO::Mono IntelliHome::Driver::GPIO::Dual)]
    );
    $app->hook(
        before_dispatch => sub {
            $_[0]->stash( drivers => shift->app->drivers );
        }
    );
################# Routes

    my $r = $app->routes;
    $app->session( "admin" => 0, "logged" => 0 );
    $r->namespaces( ['IntelliHome::WebUI::Controller'] );

    # Index

    $r->get('/')->to('pages#index');

    $r->get('/index')->to('pages#index');

    $r->get('/admin')->to('pages#admin');

    my $is_admin = $r->under(
        sub {
            my $self = shift;
            return 0
                unless $self->session("admin") && $self->session("logged");
        }
    );

    ######### FAVOURITE

    $is_admin->get('/admin/gpios')->to('pages#admin_gpios');
    $is_admin->get('/admin/nodes')->to('pages#admin_nodes');
    $is_admin->get('/admin/rooms')->to('pages#admin_rooms');

    $is_admin->post("/admin/add_gpio")->to("gpio#add");
    $is_admin->post("/admin/add_node")->to("node#add");
    $is_admin->post("/admin/add_tag")->to("gpio#add_tag");
    $is_admin->post("/admin/add_pin")->to("gpio#add_pin");
    $is_admin->post("/admin/add_room")->to("room#add");


    $is_admin->post("/admin/delete_gpio/:id")->to("gpio#delete");
    $is_admin->post("/admin/delete_node/:id")->to("node#delete");
    $is_admin->post("/admin/delete_tag/:id")->to("gpio#delete_tag");
    $is_admin->post("/admin/delete_pin/:id")->to("gpio#delete_pin");
    $is_admin->post("/admin/delete_room/:id")->to("room#delete");

    $is_admin->get('/logout')->to('pages#logout');

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

=head2 /index or /

show the dashboard

=head2 /admin

show the admin dashboard (actually redirect to admin/gpios)

=head2 /admin/gpios

show the gpios managing page

=head2 /admin/nodes

show the nodes managing page

=head2 /admin/rooms

show the rooms managing page

=head2 /logout

logout from the admin section

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

