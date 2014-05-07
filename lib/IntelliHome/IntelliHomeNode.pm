package IntelliHome::IntelliHomeNode;
require IntelliHome::Interfaces::Terminal;
require IntelliHome::Config;
require IntelliHome::Workers::Node::Monitor;
require IntelliHome::Workers::Node::Sox;
require IntelliHome::Workers::Node::Event;
require IntelliHome::Workers::Node::AudioProcess;
require IntelliHome::Schema::YAML::Node;
require IntelliHome::Workers::Node::MicAdjust;
require AnyEvent;
use base qw(Exporter);
use IntelliHome::Utils qw(daemonize cleanup);
use Moo;
with 'MooX::Singleton';
use warnings;
use strict;
use Unix::PID;
use IntelliHome::Utils qw(stop_process);
$SIG{INT} = $SIG{KILL} = $SIG{USR1}
    = "IntelliHome::IntelliHomeNode::clean_processes";
$SIG{CHLD} = 'IGNORE';

has 'Processes' => ( is => "rw", default => sub { [] } );
has 'Config' => (
    is => "rw",
    default =>
        sub { return IntelliHome::Config->instance( Dirs => ['./config'] ) }
);
has 'Output' => (
    is      => "rw",
    default => sub { return IntelliHome::Interfaces::Terminal->instance }
);
sub stop { stop_process("node"); }

sub start {
    my $self       = __PACKAGE__->instance;
    my $class      = shift;
    my $foreground = shift // 0;
    cleanup;
    my $IHOutput = $self->Output;    #set up output (debug)

## XXX: For prototyping purposes we load a YAML file for now, but we should auto-configure stuff
##      probing the network or the master

    my $Config = $self->Config;      #specify where yaml file are

    # in the local YAML it's specified the master node and my address
    my $MasterNode = IntelliHome::Schema::YAML::Node->new( Config => $Config )
        ->selectFromType("master");
    my $me = IntelliHome::Schema::YAML::Node->new( Config => $Config )
        ->selectFromType("node");

    my $Connector = IntelliHome::Connector->new( Node => $MasterNode )
        ; #set up a connector and supply the config file (For auto select of nodes)

    $IHOutput->info("IntelliHome : Node started");
    $IHOutput->info(
        "Bringing up sox and sending recordings to " . $MasterNode->Host );
    my $Sox = IntelliHome::Workers::Node::Sox->new( HW => $me->HW )
        ;    #set up a sox process
    my $Monitor = IntelliHome::Workers::Node::Monitor->new( Process => $Sox )
        ;    # an anyevent monitor for file changes

    #Closing all in case of sig int
    #  daemonize unless ($foreground ==1);
    unless ($foreground) {
        if (!daemonize("node") ) {
            $IHOutput->debug("Process already started");
            $self->clean_processes;
        }
    }

    $Sox->launch();

### Automatic Mic Adjustment
    my $MicAdjust
        = IntelliHome::Workers::Node::MicAdjust
        ->new;    # a loop for continously setting mic
    if (    defined $me->mic_upper_threshold
        and defined $me->mic_lower_threshold )
    {
        $MicAdjust->upper_threshold( $me->mic_upper_threshold );
        $MicAdjust->lower_threshold( $me->mic_lower_threshold );
        $MicAdjust->boost( $me->mic_boost_level )
            if ( defined $me->mic_boost_level );
        $MicAdjust->step( $me->mic_step )
            if ( defined $me->mic_step );
        $MicAdjust->launch();
    }
    elsif ( defined $me->mic_capture_level ) {
        $MicAdjust->set( "Capture",            $me->mic_capture_level );
        $MicAdjust->set( "Internal Mic Boost", $me->mic_boost_level );
    }

    #Set the event listener on the monitor process
    $Monitor->worker(
        IntelliHome::Workers::Node::Event->new( Connector => $Connector ) );
    $Monitor->launch();    #Launches the monitor

#Config parameter is optional, only needed if you wanna send broadcast messages
    $Connector = IntelliHome::Connector->new(
        Config => $Config,
        Node   => $me,
        Worker => IntelliHome::Workers::Node::AudioProcess->new
    );
    push( @{ __PACKAGE__->instance->{Processes} },
        $MicAdjust, $Sox, $Monitor );

    $Connector->blocking(1);    #that makes the socket blocking
    $Connector->listen();

    #$Monitor->join;

    $self->clean_processes;
}

sub clean_processes {
    $_->stop for ( @{ __PACKAGE__->instance->{Processes} } );
    exit 0;
}

!!42;

