use Test::More;
use Test::Mojo;
my $t = Test::Mojo->new('IntelliHome::IntelliHomeWebUI');

# HTML/XML
$t->get_ok('/')->status_is(200);
$t->get_ok('/index')->status_is(200);
$t->get_ok('/admin')->status_is(302);
$t->get_ok('/admin/gpios')->status_is(200);

done_testing();