package IntelliHome::IntelliHomeRPC;
use Mojo::Base 'Mojolicious';
use MojoX::JSON::RPC::Service;
use Mojo::Loader;
use feature 'say';
use Carp::Always;
use Mojolicious::Plugin::JsonRpcDispatcher; #ensure the plugin it's available

my %Modules;
my $loader = Mojo::Loader->new;
for my $module ( @{ $loader->search('IntelliHome::RPC::Service') } ) {
 # Load them safely
    my $e = $loader->load($module);
    warn qq{Loading "$module" failed: $e} and next if ref $e;
    my $Hook = $module;
    say "$module was found";
    $Hook =~ s/.*\:\://g;
    say "The hook will be $Hook";
    $Modules{lc("/$Hook")} = $module->new;
    say "$Hook was created for $module at /".lc($Hook);
}

sub startup {
    my $self = shift;
    $self->plugin( 'json_rpc_dispatcher', services => \%Modules );
}


1;
