package IH::Plugin::Search;
use Moose::Role;

has 'Commands' => (is=>"rw");

sub pretty{ print "I am pretty" }
 
1;