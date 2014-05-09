package IntelliHome::Schema::Mongo::Event;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
extends 'IntelliHome::Schema::Mongo::Trigger';

has 'node_id' => (
    is      => 'rw',
    isa     => 'Mongoose::Join[IntelliHome::Schema::Mongo::Node]',
    default => sub {
        Mongoose::Join->new(
            with_class => 'IntelliHome::Schema::Mongo::Node' );
    }
);

1;
