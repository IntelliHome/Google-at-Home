package IntelliHome::WebUI::Plugin::RPC;

use Mojo::Base 'Mojolicious::Plugin';
use MojoX::JSON::RPC::Client;
use IntelliHome::Schema::SQLite::Schema;
use IntelliHome::Schema::SQLite::Schema::Result::GPIO;
use DBI;
use DBIx::Class;
use YAML qw'freeze thaw';

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
                    return map { $_ = thaw($_); $_ } @{ $res->result };
                }
            }
            else {
                return
                    ref $client->tx->res eq "ARRAY"
                    ? map { $_ = thaw($_); $_ } @{ $client->tx->res }
                    : ();

            }
        }
    );
    $app->helper(
        rpc_call => sub {
            shift;
            my $client   = MojoX::JSON::RPC::Client->new;
            my $url      = 'http://localhost:3000/' . shift;
            my $callback = shift;
            my $callobj  = {
                id     => 1,
                method => shift,
                params => \@_
            };
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
                            $callback->( $res->result );

                            #print $res->result . "\n";
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

