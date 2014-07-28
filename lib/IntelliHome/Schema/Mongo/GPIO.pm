package IntelliHome::Schema::Mongo::GPIO;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with 'Mongoose::Document' => {
    -collection_name => 'gpio',
    -pk              => [qw/ id /]
};
has 'id' => (is=>"rw");

has 'pin_id' => ( is => "rw" );
has 'pins'=> (is=>"rw",  isa => 'ArrayRef'); #This is required if the GPIO is driven by two or more GPIOs
has 'node' => (
    is      => 'rw',
    isa     => 'Mongoose::Join[IntelliHome::Schema::Mongo::Node]',
    default => sub {
        Mongoose::Join->new(
            with_class => 'IntelliHome::Schema::Mongo::Node' );
    }
);
has 'status' => (is=>"rw");
has 'tags' => (
    is  => 'rw',
    isa => 'ArrayRef'
);
has 'timing' => ( is => "rw", default => 0 );

has 'driver' => (is=>"rw");

1;
