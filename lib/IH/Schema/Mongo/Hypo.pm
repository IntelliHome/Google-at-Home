package IH::Schema::Mongo::Hypo;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with 'Mongoose::Document' => {
    -collection_name => 'hypos',

    -pk => [qw/ hypo /]
};

has 'hypo' => ( is => "rw" );
has 'tasks' => (
    is      => 'rw',
    isa     => 'Mongoose::Join[IH::Schema::Mongo::Task]',
    default => sub { Mongoose::Join->new( with_class => 'IH::Schema::Mongo::Task' ) }
);
has 'needs' => (
    is      => 'rw',
    isa     => 'Mongoose::Join[IH::Schema::Mongo::Need]',
    default => sub { Mongoose::Join->new( with_class => 'IH::Schema::Mongo::Need' ) }
);
has 'start_time' => (
    is      => "rw",
    default => sub { time() }
);
1;
