package IntelliHome::RPC::Service::Base;

=head1 NAME

IntelliHome::RPC::Service::Base - Base class for RPC Services

=head1 DESCRIPTION

This object represent a base class for RPC Services for IntelliHome.
It only ovverides the C<new> to inject C<'with_mojo_tx'=1> option by default.
For more information on how services work, have a look at L<MojoX::JSON::RPC::Service>

=head1 ATTRIBUTES

=over

=item IntelliHome

contains an injected instance of L<IntelliHome::IntelliHomeRPC>

=back

=head1 SEE ALSO

L<IntelliHome>, L<IntelliHome::Workers::Master::RPC>, L<MojoX::JSON::RPC::Service>

=cut

use Carp::Always;
use Mojo::Base 'MojoX::JSON::RPC::Service';
has 'IntelliHome';

sub new {
    my $self = shift;
    $self = $self->SUPER::new(@_);

    #   $self->{'_rpcs'}
    #     ->{ lc( ( split( "::", ( $self =~ /(.*)\=/ )[0] ) )[-1] ) }
    #    ->{'with_mojo_tx'} = 1;
    $self->{'_rpcs'}->{$_}->{'with_mojo_tx'} = 1
        for ( keys %{ $self->{'_rpcs'} } );
    return $self;
}

1;

