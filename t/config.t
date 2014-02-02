use Test::Simple tests => 1;
use IH::Config;
my $Config = new IH::Config();

ok( defined($Config) && $Config->isa("IH::Config"),
    'IH::Config initialization ' );

ok( $Config->Output->isa("IH::Interfaces::Terminal"), 'IH::Config output' );
