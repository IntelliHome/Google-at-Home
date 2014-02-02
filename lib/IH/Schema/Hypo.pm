package IH::Schema::Hypo;
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
    isa     => 'Mongoose::Join[IH::Schema::Task]',
    default => sub { Mongoose::Join->new( with_class => 'IH::Schema::Task' ) }
);
has 'needs' => (
    is      => 'rw',
    isa     => 'Mongoose::Join[IH::Schema::Need]',
    default => sub { Mongoose::Join->new( with_class => 'IH::Schema::Need' ) }
);
has 'start_time' => (
    is      => "rw",
    default => sub { time() }
);
1;
