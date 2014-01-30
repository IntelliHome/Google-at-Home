package IH::Schema::Question;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with 'Mongoose::Document' => {
    -collection_name => 'questions',
   # -pk              => [qw/ title /]
};
has 'ask' => ( is => "rw" );
1;
