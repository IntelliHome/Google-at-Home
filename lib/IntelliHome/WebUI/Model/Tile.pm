package IntelliHome::WebUI::Model::Tile;

use Mojo::Base -base;

has [
    qw(title id image driver status toggle gpio room type value node_data tags_data pins_data)
];

sub node {
    return ref $_[0]->node_data eq "ARRAY" ? @{ shift->node_data } : ();
}

sub tags {
    return ref $_[0]->tags_data eq "ARRAY" ? @{ shift->tags_data } : ();
}

sub pins {
    return ref $_[0]->pins_data eq "ARRAY" ? @{ shift->pins_data } : ();
}
1;
