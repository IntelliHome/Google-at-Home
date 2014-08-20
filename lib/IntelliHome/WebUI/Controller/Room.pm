package IntelliHome::WebUI::Controller::Room;
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
    $self->render( json => $self->build_new_room( \%data ) );
}

sub delete {
    my $self = shift;
    my $result = $self->delete_entity( "Room", $self->param("id") );
    $self->app->rooms(
        [ grep { $_->id != $self->param("id") } @{ $self->app->rooms } ] )
        if ($result);
    $self->render( json => { result => $result } );
}

1;

