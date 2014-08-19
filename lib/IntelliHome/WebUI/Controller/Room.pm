package IntelliHome::WebUI::Controller::Room;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(hmac_sha1_sum);
use List::Util qw(min max);
use POSIX;
use Encode;
use IntelliHome::WebUI::Model::Tile;

sub add {
    my $self = shift;
    my %data = $self->deserialize_form_data( $self->param("data") );
    $self->render( text => scalar $self->build_new_room( \%data ) );
}

sub delete {
    my $self = shift;
    $self->app->rooms([ grep{ $_->id != $self->param("id") } @{$self->app->rooms} ]);
    $self->render(
        text => $self->delete_entity( "Room", $self->param("id") ) );
}

1;

