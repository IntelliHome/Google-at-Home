package IntelliHome::WebUI::Model::Tile;

use Mojo::Base -base;

has [qw(title id image driver status toggle gpio room type value node_data tags_data pins_data)];

sub node {
    @{ shift->node_data };
}

sub tags {
    @{ shift->tags_data };
}

sub pins {
    @{ shift->pins_data };
}
1;
