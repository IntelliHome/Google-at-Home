package IH::Deployer::Base;
use Moose;
use IH::Interfaces::Terminal;

has 'Node' => (is=>"rw");
has 'Output' => (is=>"rw" , default=> sub{return new IH::Interfaces::Terminal});

1;