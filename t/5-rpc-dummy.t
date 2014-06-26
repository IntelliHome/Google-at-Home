use Test::More;
use MojoX::JSON::RPC::Client;
use IntelliHome::RPC::Service::Dummy;
use IntelliHome::Workers::Master::RPC;

my $client  = MojoX::JSON::RPC::Client->new;
my $url     = 'http://localhost:3000/dummy';
my $callobj = {
    id     => 1,
    method => 'dummy',
    params => ["apri serranda"]
};

my $RPC = IntelliHome::Workers::Master::RPC->new();
$RPC->launch;
sleep(4);
$client->call(
    $url, $callobj,
    sub {
        # With callback
        my $res = pop;
        my $output;

        if ($res) {
            if ( $res->is_error ) {    # RPC ERROR
                $output = 'Error : ', $res->error_message;
            }
            else {
                $output = $res->result;
            }
        }
        else {
            my $tx_res = $client->tx->res;    # Mojo::Message::Response object
            $output
                = 'HTTP response ' . $tx_res->code . ' ' . $tx_res->message;
        }
        is( $output, "DUMMY-YUMMY!", "rpc-answer" );
        $RPC->stop;
        Mojo::IOLoop->stop;
    }
);

Mojo::IOLoop->start;
done_testing;
