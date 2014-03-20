use Test::More;
use IntelliHome::Config;
my $Config = new IntelliHome::Config();

ok( defined($Config) && $Config->isa("IntelliHome::Config"),
    'IntelliHome::Config initialization ' );

ok( $Config->Output->isa("IntelliHome::Interfaces::Terminal"), 'IntelliHome::Config output' );
done_testing;