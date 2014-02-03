use Test::Simple tests => 2;
use IH::Schema::Token;
my $Token = new IH::Schema::Token();

ok( defined($Token) && $Token->isa("IH::Schema::Token"),
    'IH::Schema::Token initialization ' );
$Token->content("bar cane");


ok( $Token->compile('(.*?)\s+(.*?)')->satisfy == 1, 'IH::Schema::Token compile() and content()' );
