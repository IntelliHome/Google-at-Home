use Test::Simple tests => 3;
use IH::Schema::Token;
my $Token = new IH::Schema::Token();

ok( defined($Token) && $Token->isa("IH::Schema::Token"),
    'IH::Schema::Token initialization ' );
$Token->content("bar cane");
ok( $Token->compile_regex('(.*?)\s+(.*?)')->satisfy == 1,
    'IH::Schema::Token compile_regex() and content()'
);
$Token->regex('(.*?)\s+(.*?)');
ok( $Token->compile('bar cane')->satisfy == 1,
    'IH::Schema::Token compile() and content()'
);
