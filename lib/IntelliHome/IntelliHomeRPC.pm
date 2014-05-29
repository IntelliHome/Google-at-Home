use base 'Mojolicious';
use MojoX::JSON::RPC::Service;
use Mojo::Loader;
use feature 'say';
use Mojolicious::Plugin::JsonRpcDispatcher; #ensure the plugin it's available
my %Modules;
my $loader = Mojo::Loader->new;
for my $module ( @{ $loader->search('IntelliHome::RPC::Service') } ) {
    my $e = $loader->load($module);
    warn qq{Loading "$module" failed: $e} and next if ref $e;
    my $Hook = $module;
    say "$module was found";
    $Hook =~ s/.*\:\://g;
    $Modules{"/$Hook"} = $e->new;
    say "$Hook was created for $e at /$Hook";
}

sub startup {
    my $self = shift;
    $self->plugin( 'json_rpc_dispatcher', services => %Modules );
}

1;
