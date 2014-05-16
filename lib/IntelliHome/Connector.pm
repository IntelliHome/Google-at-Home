package IntelliHome::Connector;

use Moose;
use IntelliHome::Workers::SocketListener;
use IntelliHome::Workers::SocketAsync;
use Fcntl qw(:DEFAULT :flock);
use IO::Socket;

has 'Output' =>
    ( is => "rw", default => sub { IntelliHome::Interfaces::Terminal->instance } );
has 'Worker' => ( is => "rw" );
has 'Config' => ( is => "rw" )
    ;    #if has config can auto select where things must be done
has 'Socket'   => ( is => "rw" );
has 'Node'     => ( is => "rw" );
has 'Thread'   => ( is => "rw" );
has 'blocking' => ( is => "rw", default => 0 );

sub stop {
    my $self = shift;
    $self->Thread->stop if $self->blocking == 0;
}

sub broadcastMessage {
    my $self    = shift;
    my $Type    = shift;
    my $Message = shift;
    my $Nodes   = $self->Config->Nodes;
    foreach my $Node ( keys( %{$Nodes} ) ) {
        if ( $Nodes->{$Node}->{type} eq $Type ) {
            $self->Node->select( $Nodes, $Node );
            $self->connect();
            $self->send_command($Message);
        }
    }
}

sub listen {
    my $self = shift;
    return undef if ( !$self->Worker );
    $self->Output->error("Cannot found node!") and return undef
        if ( !defined $self->Node );
    my ( $filename, $new, $fh, @ready );
    my $lsn = IO::Socket::INET->new(
        Listen    => 1,
        LocalAddr => $self->Node->Host,
        LocalPort => $self->Node->Port,
    ) or ( $self->Output->error("$!") && exit 1 );
    if ( $self->blocking == 1 ) {
       $self->Worker->process($_)   while ($lsn->accept() ) ;
    }
    else {
        my $Thread = IntelliHome::Workers::SocketAsync->new(
            Worker => $self->Worker,
            Socket => $lsn
        );
        $Thread->launch();
        $self->Thread($Thread);
    }
    return $self->Thread->is_running ? 1 : 0;
}

sub connect {
    my $self   = shift;
    my $server = IO::Socket::INET->new(
        Proto    => "tcp",
        PeerPort => $self->Node->Port,
        PeerAddr => $self->Node->Host,
        Timeout  => 2000
        )
        || (
        $self->Output->error(
                  "failed to connect to "
                . $self->Node->Host . ":"
                . $self->Node->Port . " $!"
        )
        && return undef
        );
    $self->Socket($server);
    return $self;
}

sub send_file {
    my $self   = shift;
    my $File   = shift;
    my $server = IO::Socket::INET->new(
        Proto    => "tcp",
        PeerPort => $self->Node->Port,
        PeerAddr => $self->Node->Host,
        Timeout  => 2000
        )
        || (
        $self->Output->error(
                  "failed to connect to "
                . $self->Node->Host . ":"
                . $self->Node->Port . " $!"
        )
        && return undef
        );
    if ($server) {
        open FILE, "<" . $File
            or ( $self->Output->error("Error $File: $!") and return 0 );
        if ( flock( FILE, 1 ) ) {
            print $server $_ while (<FILE>) ;
            close FILE;
            $server->close();
            $self->Output->info( "recording sent to "
                    . $self->Node->Host
                    . " type: "
                    . $self->Node->type );
            return 1;
        }
        else {
            $server->close();
            $self->Output->error("Cannot send file, it's LOCKED!"); # avoids file that are currently being writed
            return 0;
        }
    }
}

sub send_command {
    my $self    = shift;
    my $Command = shift;
    if ( $self->Socket ) {
        my $Sock = $self->Socket();
        my $buf;
        print $Sock $Command;
        $buf .= $_ while (<$Sock>);
        $Sock->close();
        return $buf;
    }
    else {
        $self->connect();
        $self->send_command($Command);
    }
}

1;
