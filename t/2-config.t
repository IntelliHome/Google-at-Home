use Test::More;
use IntelliHome::Config;
my $Config = IntelliHome::Config->instance(
    Dirs   => ['./config'],
    Output => IntelliHome::Interfaces::Terminal->instance( log => 0 )
);

ok( defined($Config) && $Config->isa("IntelliHome::Config"),
    'IntelliHome::Config initialization ' );

ok( $Config->Output->isa("IntelliHome::Interfaces::Terminal"),
    'IntelliHome::Config output' );
done_testing;
