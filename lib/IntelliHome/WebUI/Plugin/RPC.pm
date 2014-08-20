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
                    ref  $res->result eq "ARRAY"
                        ? map { $_ = thaw($_); $_ } @{ $res->result }
                        :  $res->result;
                }
            }
            else {
                return
                    ref $client->tx->res eq "ARRAY"
                    ? map { $_ = thaw($_); $_ } @{ $client->tx->res }
                    :  $client->tx->res;

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

__END__

=encoding utf-8

=head1 NAME

IntelliHome::WebUI::Plugin::RPC - RPC plugin for mojolicious web application

=head1 SYNOPSIS

    my @Objs=rpc_call_blocking("Service",@args)
    #or non blocking:
    rpc_call("Service", sub { my ($res) = @_; ... },@params);

=head1 DESCRIPTION

This Mojolicious plugin allow to call the rpc server of IntelliHome

=head1 METHODS

=head2 rpc_call

Async call to the RPC server.

    rpc_call("Service", @params,
        sub { my ($res) = @_; ... }
        );


=head2 rpc_call_blocking

Blocking call to the RPC server

    my @Objs=rpc_call_blocking("Service",@args)

=head1 AUTHOR

skullbocks E<lt>dgikiller@gmail.comtE<gt>

=head1 COPYRIGHT

Copyright 2014- skullbocks

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO
L<IntelliHome::WebUI::Plugin::ModelFactory>, L<IntelliHome::IntelliHomeWebUI>

=cut
