package IntelliHome::WebUI::Plugin::ModelFactory;

use Mojo::Base 'Mojolicious::Plugin';
use IntelliHome::WebUI::Plugin::RPC;
use IntelliHome::WebUI::Model::Tile;
use IntelliHome::WebUI::Model::Room;
use IntelliHome::WebUI::Model::Node;

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
            my @rooms;
            push( @rooms, IntelliHome::WebUI::Model::Room->new( %{$_} ) )
                for shift->app->rpc_call_blocking("ask","get_rooms");
            return @rooms;
            #return [shift->app->rpc_call_blocking("ask","get_rooms")];
        }
    );
    $app->helper(
        build_nodes => sub {
            my @nodes;
            push( @nodes, IntelliHome::WebUI::Model::Node->new( %{$_} ) )
                for shift->app->rpc_call_blocking("ask","get_nodes");
            return @nodes;
            #return [shift->app->rpc_call_blocking("ask","get_nodes")];
        }
    );
}

1;

