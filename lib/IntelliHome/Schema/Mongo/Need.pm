package IntelliHome::Schema::Mongo::Need;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with 'Mongoose::Document' => {
    -collection_name => 'needs',
   # -pk              => [qw/ title /]
};
extends 'IntelliHome::Schema::Mongo::Token';

has 'forced' => ( is => "rw", default => 0 );
has 'suggested' => ( is => "rw", default => 0 );

has 'questions' => (
    is      => 'rw',
    isa     => 'Mongoose::Join[IntelliHome::Schema::Mongo::Question]',
    default => sub { Mongoose::Join->new( with_class => 'IntelliHome::Schema::Mongo::Question' ) }
);
1;
