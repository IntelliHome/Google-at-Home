package IntelliHome::Schema::Mongo::Trigger;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with 'Mongoose::Document' => {
    -collection_name => 'triggers',
   # -pk              => [qw/ title /]
};
with('IntelliHome::Schema::Mongo::Role::Plugin');
extends 'IntelliHome::Schema::Mongo::Token';


has 'needed' => (
    is      => 'rw',
    isa     => 'Mongoose::Join[IntelliHome::Schema::Mongo::Need]',
    default => sub { Mongoose::Join->new( with_class => 'IntelliHome::Schema::Mongo::Need' ) }
);
1;
