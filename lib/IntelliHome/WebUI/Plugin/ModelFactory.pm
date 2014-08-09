package IntelliHome::WebUI::Plugin::ModelFactory;

use Mojo::Base 'Mojolicious::Plugin';
use IntelliHome::WebUI::Plugin::RPC;
use IntelliHome::WebUI::Model::Tile;

sub register {
    my ( $self, $app, $conf ) = @_;
    $app->helper(
        build_tiles => sub {
            my @tiles;
            push( @tiles, IntelliHome::WebUI::Model::Tile->new( %{$_} ) )
                for shift->app->rpc_call_blocking("ask","gpio_data");
            return @tiles;
        }
    );
    $app->helper(
        build_rooms => sub {
            return [shift->app->rpc_call_blocking("ask","get_rooms")];
        }
    );
}

1;

