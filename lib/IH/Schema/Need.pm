package IH::Schema::Need;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with 'Mongoose::Document' => {
    -collection_name => 'needs',
   # -pk              => [qw/ title /]
};
extends 'IH::Schema::Token';

has 'forced' => ( is => "rw", default => 0 );
has 'suggested' => ( is => "rw", default => 0 );

has 'questions' => (
    is      => 'rw',
    isa     => 'Mongoose::Join[IH::Schema::Question]',
    default => sub { Mongoose::Join->new( with_class => 'IH::Schema::Question' ) }
);
1;
