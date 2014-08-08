package IntelliHome::WebUI::Plugin::ModelFactory;

use Mojo::Base 'Mojolicious::Plugin';
use IntelliHome::WebUI::Plugin::RPC;
use IntelliHome::WebUI::Model::Tile;

sub register {
    my ( $self, $app, $conf ) = @_;
    $app->helper(
        build_tiles => sub {
            my @tiles;
            push(
                @tiles,
                IntelliHome::WebUI::Model::Tile->new(
                    title  => $_->tags->first(),
                    id     => $_->gpioid,
                    image  => 0,
                    driver => $_->driver,
                    status => $_->status,
                    toggle => (
                        ( split( /::/, ( $_->driver =~ /(.*)\=/ )[0] ) )[-1]
                            eq "Mono"
                        ) ? 1 : 0,
                    gpio => $_->pin_id,
                    room => $_->node->room->name,
                    tag  => $_->tags->all()
                )
            ) for shift->rpc_call_blocking(@_);
            return @tiles;
        }
    );
}

1;

