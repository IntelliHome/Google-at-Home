package IntelliHome::Schema::Mongo::Event;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
has 'plugin' => ( is => "rw" );
has 'plugin_method' => (is=>"rw");
has 'node' => (
    is      => 'rw',
    isa     => 'Mongoose::Join[IntelliHome::Schema::Mongo::Node]',
    default => sub {
        Mongoose::Join->new(
            with_class => 'IntelliHome::Schema::Mongo::Node' );
    }
);

1;
