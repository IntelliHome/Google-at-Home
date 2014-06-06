package IntelliHome::IntelliHomeRPC;

use Carp::Always;

use Mojo::Base 'Mojolicious';
use MojoX::JSON::RPC::Service;
use Mojo::Loader;
use Mojolicious::Plugin::JsonRpcDispatcher;    #ensure the plugin it's available

use IntelliHome::Config;
use IntelliHome::Google::Synth;
use IntelliHome::Interfaces::Voice;

has 'Loader' => sub { return Mojo::Loader->new; };
has 'Config';
has 'GSynth';
has 'Services' => sub { {} };
has 'Parser';
has 'Output';

sub build {
    my $self = shift;
    $self->Config( IntelliHome::Config->instance( Dirs => ['./config'] ) );
    $self->Output(
        IntelliHome::Interfaces::Voice->new( Config => $self->Config ) );

    for my $module ( @{ $self->Loader->search('IntelliHome::RPC::Service') } ) {

        # Load them safely
        my $e = $self->Loader->load($module);
        warn qq{Loading "$module" failed: $e} and next if ref $e;
        my $Hook = $module;
        $Hook =~ s/.*\:\://g;
        $self->Services->{ lc("/$Hook") } =
          $module->new( IntelliHome => $self );
        $self->Output->failback->info(
            "$Hook was created for $module at /" . lc($Hook) );
    }
    my $Parser = 'IntelliHome::Parser::'
      . $self->Config->DBConfiguration->{'database_backend'};
    $self->Loader->load($Parser);
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
