use Test::More;
use IntelliHome::Schema::Mongo::Token;
my $Token = new IntelliHome::Schema::Mongo::Token();

ok( defined($Token) && $Token->isa("IntelliHome::Schema::Mongo::Token"),
    'IntelliHome::Schema::Mongo::Token initialization ' );
$Token->content("bar cane");
ok( $Token->compile_regex('(.*?)\s+(.*?)')->satisfy == 1,
    'IntelliHome::Schema::Mongo::Token compile_regex() and content()'
);
$Token->regex('(.*?)\s+(.*?)');
ok( $Token->compile('bar cane')->satisfy == 1,
    'IntelliHome::Schema::Mongo::Token compile() and content()'
);

done_testing;