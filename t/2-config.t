use Test::More;
use IntelliHome::Config;
my $Config = IntelliHome::Config->instance(Dirs=> ['./config']);

ok( defined($Config) && $Config->isa("IntelliHome::Config"),
    'IntelliHome::Config initialization ' );

ok( $Config->Output->isa("IntelliHome::Interfaces::Terminal"), 'IntelliHome::Config output' );
done_testing;