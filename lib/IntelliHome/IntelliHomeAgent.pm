package IntelliHome::IntelliHomeAgent;
require IntelliHome::Driver::GPIO::Mono;
require IntelliHome::Driver::GPIO::Dual;
require IntelliHome::Driver::Analogic;
require IntelliHome::Interfaces::Terminal;
require IntelliHome::Config;
require IntelliHome::Connector;
require IntelliHome::Workers::Agent::CommandProcess;
require IntelliHome::Schema::YAML::Node;
use IntelliHome::Utils qw(daemonize cleanup stop_process search_modules load_module);
use Moo;
with 'MooX::Singleton';
use warnings;
use strict;
use Deeme;
use Deeme::Backend::Memory;
$SIG{INT} = $SIG{KILL} = $SIG{USR1}
    = sub { exit 0 };
$SIG{CHLD} = 'IGNORE';
has 'Config' => (
    is => "rw",
    default =>
        sub { return IntelliHome::Config->instance( Dirs => ['./config'] ) }
);
has 'Output' => (
    is      => "rw",
    default => sub { return IntelliHome::Interfaces::Terminal->instance; }
);

has 'event' => (
    is      => "rw",
    default => sub { return Deeme->new(backend=> Deeme::Backend::Memory->new)}
);
sub stop { stop_process("agent"); }

sub start {
    my $self       = __PACKAGE__->instance;
    my $class      = shift;
    my $foreground = shift // 0;
    my $IHOutput   = $self->Output;
    my $Config     = $self->Config;           #specify where yaml file are
    my $me = IntelliHome::Schema::YAML::Node->new( Config => $Config )
        ->selectFromType("agent");
    $IHOutput->info("IntelliHome : Node agent started");
    $IHOutput->info(
        "Bringing up sockets (non secured, i assume you have vpn on your network)"
    );

    unless ($foreground) {
        if ( !daemonize("agent") ) {
            $IHOutput->debug("Process already started");
            $self->clean_processes;
        }
    }
    foreach my $plugin ( search_modules("IntelliHome::Plugin::Agent") ) {
        load_module($plugin);
        my $Plugin = $plugin->new( app => $self );
        $Plugin->install;
        push( @{ $self->{'loaded_plugins'} }, $Plugin );
    }
    my $Connector = IntelliHome::Connector->new( Node => $me );
    $Connector->Worker(
        IntelliHome::Workers::Agent::CommandProcess->new( app => $self, IntelliHome=>$self ) );
    $Connector->blocking(1);
    $Connector->listen();
}

!!42;
