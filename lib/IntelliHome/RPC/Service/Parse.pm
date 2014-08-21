package IntelliHome::RPC::Service::Parse;

=head1 NAME

IntelliHome::RPC::Service::Parse - IntelliHome "Parse" service for RPC server

=head1 DESCRIPTION

This object represent the "Parse" service for the RPC server, it is available under C<rpcserver_ip:port/Parse>.
The parsing process is delegated to the dynamically loaded parser at boot, that uses triggers to match the corresponding plugin that must be called.

=head1 METHODS

IntelliHome::RPC::Service::Parse inherits all methods from  L<IntelliHome::RPC::Service::Base> and implement the following new:

=over

=item parse(@params)

parse thru the L<IntelliHome::Parser::Base> the given params

=back

=head1 ATTRIBUTES

IntelliHome::RPC::Service::Parse inherits all attributes from L<IntelliHome::RPC::Service::Base>

=head1 SEE ALSO

L<IntelliHome>, L<IntelliHome::RPC::Service::Command>, L<IntelliHome::Workers::Master::RPC>, L<MojoX::JSON::RPC::Service>

=cut

use Carp::Always;
use Mojo::Base 'IntelliHome::RPC::Service::Base';
use feature 'say';
has 'IntelliHome';

sub parse {
    my ( $self, $tx, @params ) = @_;
    my $Client = $self->IntelliHome->Parser->node->selectFromHost(
        $tx->remote_address, "node" );
    $Client = $self->IntelliHome->Parser->node->selectFromType("master")
        if !$Client;
    $self->IntelliHome->Parser->Node($Client);
    $self->IntelliHome->Parser->Output->Node($Client);
    $self->IntelliHome->Parser->parse(@params);
    return "Received " . join( " ", @params );
}

__PACKAGE__->register_rpc_method_names('parse');

1;

