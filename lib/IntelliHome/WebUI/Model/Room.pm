package IntelliHome::WebUI::Model::Room;

use Mojo::Base -base;

has [qw(id name location description notes nodes_data)];

sub nodes {
    @{ shift->nodes_data };
}
1;
