package IntelliHome::WebUI::Controller::Index;


use Mojo::Base 'Mojolicious::Controller';

use Mojo::Util qw(hmac_sha1_sum);

use List::Util qw(min max);

use Data::Dumper;

use POSIX;

use Encode;


sub index {

my $self = shift;

$self->render("index");

}


1;

