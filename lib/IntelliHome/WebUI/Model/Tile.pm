package IntelliHome::WebUI::Model::Tile;

use Mojo::Base -base;

has [qw(title id image driver status toggle gpio room tag)]; 
1;