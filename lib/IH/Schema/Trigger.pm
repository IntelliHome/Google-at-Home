package IH::Schema::Trigger;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with 'Mongoose::Document' => {
    -collection_name => 'triggers',
   # -pk              => [qw/ title /]
};
extends 'IH::Schema::Token';

has 'plugin' => ( is => "rw" );
has 'plugin_method' => (is=>"rw");
has 'needed' => (
    is      => 'rw',
    isa     => 'Mongoose::Join[IH::Schema::Need]',
    default => sub { Mongoose::Join->new( with_class => 'IH::Schema::Need' ) }
);
1;
