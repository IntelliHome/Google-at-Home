use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('IntelliHome::IntelliHomeWebUI');

# HTML/XML
$t->get_ok('/')->status_is(200);

# # HTML/XML
# $t->get_ok('/welcome')->status_is(200)->text_is('div#message' => 'Hello!');

# # JSON
# $t->post_ok('/search.json' => form => {q => 'Perl'})
#   ->status_is(200)
#   ->header_is('Server' => 'Mojolicious (Perl)')
#   ->header_isnt('X-Bender' => 'Bite my shiny metal ass!')
#   ->json_is('/results/4/title' => 'Perl rocks!')
#   ->json_like('/results/7/title' => qr/Perl/);

# # WebSocket
# $t->websocket_ok('/echo')
#   ->send_ok('hello')
#   ->message_ok
#   ->message_is('echo: hello')
#   ->finish_ok;

done_testing();
