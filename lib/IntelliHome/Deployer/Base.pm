package IntelliHome::Deployer::Base;
use Moo;
use IntelliHome::Interfaces::Terminal;

has 'Node' => (is=>"rw");
has 'Output' => (is=>"rw" , default=> sub{return new IntelliHome::Interfaces::Terminal});

1;