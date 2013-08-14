package IH::Trigger::Task;
use Moose;
use namespace::autoclean;

use KiokuDB::Set;
use KiokuDB::Util qw(set);
has 'status' => ( is => "rw", default => 0 );
has 'node' => (
    isa  => "IH::Node",
    lazy => 1
);
has 'need' => (
    isa  => "IH::Schema::Need",
    lazy => 1
);
has 'start_time' => (
    is      => "rw",
    default => time()
);

1;
