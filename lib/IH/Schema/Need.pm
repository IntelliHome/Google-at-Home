package IH::Schema::Need;
use Moose;
use namespace::autoclean;

extends 'IH::Schema::Token';
use KiokuDB::Set;

use KiokuDB::Util qw(set);
has 'forced' => ( is => "rw", default => 0 );
has 'question' => (
    isa     => "KiokuDB::Set",
    lazy    => 1,
    default => sub { set() },    # empty set
);
1;
