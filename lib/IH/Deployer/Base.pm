package IH::Deployer::Base;
use Moo;
use IH::Interface::Terminal;

has 'Node' => (is=>"rw");
has 'Output' => (is=>"rw" , default=> sub{return new IH::Interface::Terminal});

1;