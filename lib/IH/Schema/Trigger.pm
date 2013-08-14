package IH::Schema::Trigger;
use Moose;
use namespace::autoclean;

use KiokuDB::Set;

use KiokuDB::Util qw(set);

extends 'IH::Schema::Token';

has 'plugin' => ( is => "rw" );
has 'plugin_method' => (is=>"rw");
has 'needed' => (
    isa     => "KiokuDB::Set",
    lazy    => 1,
    default => sub { set() },    # empty set
);

1;
