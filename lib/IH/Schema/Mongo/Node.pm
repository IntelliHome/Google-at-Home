package IH::Schema::Node;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with 'Mongoose::Document' => {
    -collection_name => 'nodes',
    -pk => [qw/ ip /]
};

has 'ip' => ( is => "rw" );
has 'port' => ( is => "rw" );
has 'username' => ( is => "rw" );
has 'password' => ( is => "rw" );
has 'description' => ( is => "rw" );
has 'GPIO' => (
    is      => 'rw',
    isa     => 'Mongoose::Join[IH::Schema::Mongo::GPIO]',
    default => sub { Mongoose::Join->new( with_class => 'IH::Schema::Mongo::GPIO' ) }
);
1;
