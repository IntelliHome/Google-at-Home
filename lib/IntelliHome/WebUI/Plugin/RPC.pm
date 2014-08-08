package IntelliHome::WebUI::Plugin::RPC;

use Mojo::Base 'Mojolicious::Plugin';
use Mojox::JSON:RPC:Client;

sub register {
    my ( $self, $app, $conf ) = @_;
    $app->helper(
        rpc_call_blocking => sub {
            shift;
            my $client  = MojoX::JSON::RPC::Client->new;
            my $url     = 'http://localhost:3000/' . shift;
            my $callobj = {
                id     => 1,
                method => shift,
                params => \@_
            };
            my $res = $client->call( $url, $callobj );

            if ($res) {
                if ( $res->is_error ) {    # RPC ERROR
                    print 'Error : ', $res->error_message . "\n";
                }
                else {
                    print $res->result . "\n";
                }
            }
            else {
                return $client->tx->res;
            }
        }
    );
    $app->helper(
        rpc_call => sub {
            shift;
            my $client  = MojoX::JSON::RPC::Client->new;
            my $url     = 'http://localhost:3000/' . shift;
            my $callobj = {
                id     => 1,
                method => shift,
                params => \@_
            };
            my $callback = shift;
            $client->call(
                $url, $callobj,
                sub {
                    # With callback
                    my $res = pop;
                    if ($res) {
                        if ( $res->is_error ) {    # RPC ERROR
                            print 'Error : ', $res->error_message . "\n";
                        }
                        else {
                            print $res->result . "\n";
                        }
                    }
                    else {
                        $callback->( $client->tx->res );
                    }
                }
            );

        }
    );
}

1;

