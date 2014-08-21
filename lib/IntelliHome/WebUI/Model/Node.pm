package IntelliHome::WebUI::Model::Node;

use Mojo::Base -base;

has [
    qw(id name description host port type username password gpios_data room_data)
];

sub gpios {
    @{ shift->gpios_data };
}

sub room {
    @{ shift->room_data };
}
1;
