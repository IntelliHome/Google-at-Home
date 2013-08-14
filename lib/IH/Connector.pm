package IH::Connector;

use Moose;
use IH::Workers::SocketListener;
use IH::Workers::SocketAsync;
use Fcntl qw(:DEFAULT :flock);

use IO::Socket;

has 'Output' =>
    ( is => "rw", default => sub { return new IH::Interfaces::Terminal } );
has 'Worker' => ( is => "rw" );
has 'Config' => ( is => "rw" )
    ;    #if has config can auto select where things must be done
has 'Socket'   => ( is => "rw" );
has 'Node'     => ( is => "rw" );
has 'Thread'   => ( is => "rw" );
has 'blocking' => ( is => "rw", default => 0 );

sub broadcastMessage() {
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

sub listen() {
    my $self = shift;

    return 0 if ( !$self->Worker );

    my ( $filename, $new, $fh, @ready );

    my $lsn = IO::Socket::INET->new(
        Listen    => 1,
        LocalAddr => $self->Node->Host,
        LocalPort => $self->Node->Port,
    ) or ( $self->Output->error("$!") && exit 1 );

    if ( $self->blocking ) {

        #oldaway
        while ( my $client = $lsn->accept() ) {
            my $Thread = IH::Workers::SocketListener->new(
                Worker => $self->Worker,
                Socket => $client
            );
            $Thread->launch();
        }
    }
    else {

        my $Thread = IH::Workers::SocketAsync->new(
            Worker => $self->Worker,
            Socket => $lsn
        );
        $Thread->launch();
        $self->Thread($Thread);

    }

    return $self->Thread->is_running ? 1 : 0;

}

sub connect() {
    my $self   = shift;
    my $server = IO::Socket::INET->new(
        Proto    => "tcp",
        PeerPort => $self->Node->Port,
        PeerAddr => $self->Node->Host,
        Timeout  => 2000
        )
        || ( $self->Output->error("failed to connect to the server")
        && return 0 );

    $self->Socket($server);
    return $self;
}

sub send_file() {
    my $self   = shift;
    my $File   = shift;
    my $server = IO::Socket::INET->new(
        Proto    => "tcp",
        PeerPort => $self->Node->Port,
        PeerAddr => $self->Node->Host,
        Timeout  => 2000
        )
        || ( $self->Output->error("failed to connect to the server")
        && return 0 );
    if ($server) {
        open FILE, "<" . $File or $self->Output->error("Error $File: $!");

        if ( flock( FILE, 1 ) ) {

            while (<FILE>) {
                print $server $_;
            }
            close FILE;
            $server->close();
            return 1;
        }
        else {
            $server->close();
            $self->Output->error("Cannot send file, it's LOCKED!");
            return 0;

        }
    }
}

sub send_command() {
    my $self    = shift;
    my $Command = shift;
    if ( $self->Socket ) {
        my $Sock = $self->Socket();
        print $Sock $Command;
        $self->Socket->close();
    }
    else {
        $self->connect();
        $self->send_command($Command);
    }
}

1;
