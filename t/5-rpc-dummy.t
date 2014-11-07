# Workaround for issue #34. Must stay at the top.
BEGIN{ $ENV{MOJO_REACTOR} = "Mojo::Reactor::Poll"; }

use Test::More;
use MojoX::JSON::RPC::Client;
use IntelliHome::RPC::Service::Dummy;
use IntelliHome::Workers::Master::RPC;
use File::Path qw(remove_tree);
use IntelliHome::Schema::SQLite::Schema;
use IntelliHome::Deployer::Schema::SQLite;
unlink("/tmp/intellihome.db");
remove_tree("/tmp/db_upgrades");
$ENV{INTELLIHOME_DB_NAME} = "/tmp/intellihome.db";
my $Deployer = IntelliHome::Deployer::Schema::SQLite->new(
    dh => DBIx::Class::DeploymentHandler->new(
        {   schema => IntelliHome::Schema::SQLite::Schema->connect(
                'dbi:SQLite:/tmp/intellihome.db'
            ),
            script_directory => '/tmp/db_upgrades',
            databases        => 'SQLite',
            force_overwrite  => 1,
            schema_version   => 1
        }
    )
);

$Deployer->prepare;
$Deployer->install;

my $client  = MojoX::JSON::RPC::Client->new;
my $url     = 'http://localhost:3000/dummy';
my $callobj = {
    id     => 1,
    method => 'dummy',
    params => ["apri serranda"]
};
my $RPC = IntelliHome::Workers::Master::RPC->new();
$RPC->launch( "prefork", '-l', 'http://*:3000' )->detach;
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
        $ENV{INTELLIHOME_DB_NAME} = undef;

        Mojo::IOLoop->stop;
    }
);

Mojo::IOLoop->start;
done_testing;
