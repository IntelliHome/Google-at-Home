package IntelliHome::IntelliHomeRPC;

=head1 NAME

IntelliHome::IntelliHomeRPC - Top class for the IntelliHome RPC server

=head1 DESCRIPTION

This object represent a Mojolicious Application with the RPC plugin activated. At startup load all the services installed in the C<IntelliHome::RPC::Service::*> namespace.

=head1 METHODS

=over

=item build

Set up parser from the configuration file, searches and load all the services in the C<IntelliHome::RPC::Service::*> namespace.

=item startup

Starts the RPC server with the loaded services.

=back

=head1 ATTRIBUTES

=over

=item Config

Give access to the loaded L<IntelliHome::Config>

=item Services

Contains an HashRef of initialized services in the form C</hook => Service::Obj> the key contain the hook for the rpc service, the value has an instantiation of the object and the instance of L<IntelliHome::IntelliHomeRPC>

=item Parser

Contains the L<IntelliHome::Parser::*> dynamically loaded from the config specification

=item Output

Contains the output interface, see L<IntelliHome::Interfaces::Interface>,L<IntelliHome::Interfaces::Terminal>, L<IntelliHome::Interfaces::Voice>

=back

=head1 SEE ALSO

L<IntelliHome>, L<IntelliHome::Workers::Master::RPC> , L<MojoX::JSON::RPC::Service>

=cut

use Carp::Always;

use Mojo::Base 'Mojolicious';
use MojoX::JSON::RPC::Service;
use Mojo::Loader qw(data_section find_modules load_class);
use Mojolicious::Plugin::JsonRpcDispatcher;  #ensure the plugin it's available

use IntelliHome::Config;
use IntelliHome::Google::Synth;
use IntelliHome::Interfaces::Voice;

has 'Config';
has 'GSynth';
has 'Services' => sub { {} };
has 'Output';
has 'Parser';

sub build {
    my $self = shift;
    $self->Config( IntelliHome::Config->instance( Dirs => ['./config'] ) );
    $self->Output(
        IntelliHome::Interfaces::Voice->new( Config => $self->Config ) );
    for my $module ( find_modules 'IntelliHome::RPC::Service' ) {

        # Load them safely
        my $e = load_class $module;
        warn qq{Loading "$module" failed: $e} and next if ref $e;
        my $Hook = $module;
        $Hook =~ s/.*\:\://g;
        $self->Services->{ lc("/$Hook") }
            = $module->new( IntelliHome => $self );
        $self->Output->failback->info(
            "$Hook was created for $module at /" . lc($Hook) );
    }
    my $Parser = 'IntelliHome::Parser::'
        . $self->Config->DBConfiguration->{'database_backend'};
    load_class $Parser;
    $Parser = $Parser->new(
        Config => $self->Config,
        Output => $self->Output
    );
    $self->Parser($Parser);
    $self->GSynth( IntelliHome::Google::Synth->new );

    $self->GSynth->Language(
        defined $self->Config
            and $self->Config->DBConfiguration->{'language'}
        ? $self->Config->DBConfiguration->{'language'}
        : "en"
    );

}

sub startup {
    my $self = shift;
    $self->build;
    $self->plugin(
        'json_rpc_dispatcher',
        services          => $self->Services,
        exception_handler => sub {
            my ( $dispatcher, $err, $m ) = @_;

       # $dispatcher is the dispatcher Mojolicious::Controller object
       # $err is $@ received from the exception
       # $m is the MojoX::JSON::RPC::Dispatcher::Method object to be returned.

            $dispatcher->app->log->error(qq{Internal error: $err});

            # Fake invalid request
            $m->invalid_request('Faking invalid request');
            return;
        }
    );
}

1;
