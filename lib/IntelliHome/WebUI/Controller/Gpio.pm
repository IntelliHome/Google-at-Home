package IntelliHome::WebUI::Controller::Gpio;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(hmac_sha1_sum);
use List::Util qw(min max);
use POSIX;
use Encode;
use IntelliHome::WebUI::Model::Tile;

sub add {
    my $self = shift;
    my %data = $self->deserialize_form_data( $self->param("data") );
    my $node = { id => $data{nodeid} };
    delete $data{nodeid};
    $self->render( json => $self->build_new_gpio( \%data, $node ) );
}

sub add_tag {
    my $self = shift;
    my %data = $self->deserialize_form_data( $self->param("data") );
    my $gpio = { id => $data{gpioid} };
    delete $data{gpioid};
    $self->render( json => $self->build_new_tag( \%data, $gpio ) );
}

sub add_pin {
    my $self = shift;
    my %data = $self->deserialize_form_data( $self->param("data") );
    my $gpio = { id => $data{gpioid} };
    delete $data{gpioid};
    $self->render( json => $self->build_new_pin( \%data, $gpio ) );
}

sub delete {
    my $self = shift;
    $self->render( json =>
            { result => $self->delete_entity( "GPIO", $self->param("id") ) }
    );
}

sub delete_tag {
    my $self = shift;
    $self->render( json =>
            { result => $self->delete_entity( "Tag", $self->param("id") ) } );
}

sub delete_pin {
    my $self = shift;
    $self->render( json =>
            { result => $self->delete_entity( "Pin", $self->param("id") ) } );
}

1;

