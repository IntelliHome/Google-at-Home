package IntelliHome::Schema::Mongo::GPIO;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with 'Mongoose::Document' => {
    -collection_name => 'gpio',
    -pk => [qw/ pin_id /]
};

has 'pin_id' => ( is => "rw" );
has 'tags' => (
    is  => 'rw',
    isa => 'ArrayRef'
);

1;
