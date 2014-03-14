use Test::More;
use IH::Schema::Mongo::Token;
my $Token = new IH::Schema::Mongo::Token();

ok( defined($Token) && $Token->isa("IH::Schema::Mongo::Token"),
    'IH::Schema::Mongo::Token initialization ' );
$Token->content("bar cane");
ok( $Token->compile_regex('(.*?)\s+(.*?)')->satisfy == 1,
    'IH::Schema::Mongo::Token compile_regex() and content()'
);
$Token->regex('(.*?)\s+(.*?)');
ok( $Token->compile('bar cane')->satisfy == 1,
    'IH::Schema::Mongo::Token compile() and content()'
);

done_testing;