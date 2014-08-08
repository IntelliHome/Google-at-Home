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
                for shift->app->rpc_call_blocking(@_);
            return @tiles;
        }
    );
}

1;

