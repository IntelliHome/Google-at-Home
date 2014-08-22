package IntelliHome::WebUI::Controller::Node;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(hmac_sha1_sum);
use List::Util qw(min max);
use POSIX;
use Encode;
use IntelliHome::WebUI::Model::Tile;
use JSON;

sub add {
    my $self = shift;
    my %data = $self->deserialize_form_data( $self->param("data") );
    my $room = { id => $data{roomid} };
    delete $data{roomid};
    $self->render( json => $self->build_new_node( \%data, $room ) );
}

sub delete {
    my $self = shift;
    $self->render( json =>
            { result => $self->delete_entity( "Node", $self->param("id") ) }
    );
}

1;

