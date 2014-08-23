package IntelliHome::Deployer::Schema::Base;
use Moo;
use IntelliHome::Interfaces::Terminal;
use IntelliHome::Config;
has 'Config' => (
    is => "rw",
    default =>
        sub { return IntelliHome::Config->instance( Dirs => ['./config'] ); }
);
has 'Output' => (is=>"rw" , default=> sub{return new IntelliHome::Interfaces::Terminal});

1;