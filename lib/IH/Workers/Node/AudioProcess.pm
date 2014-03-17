package IH::Workers::Node::AudioProcess;
use Moo;
has 'Output' =>
    ( is => "rw", default => sub { return IH::Interfaces::Terminal->new } );
has 'tmp' => ( is => "rw", default => "/var/tmp/ih" );
has 'Process' => ( is => "rw" );

sub process {
    my $self = shift;
    my $fh   = shift;    ## IO::Socket
    my $audio;
    mkdir( $self->tmp() ) || die("Cannot create temporary directory")
        if ( !-d $self->tmp() );
    my $host = $fh->peerhost();
    $audio .= $_ while (  <$fh> );
    my $out = $self->tmp() . "/" . time() . ".mp3";
    open my $FILE, ">" . $out;
    print $FILE $audio;
    close $FILE;

    #$self->Process->stop() if $self->Process;
    print "Arrivato\n";
    $self->Output->debug("Error launching mplayer")
        if ( !system( 'mplayer', $out ) );

# If we don't play it it's gone forever. think about a message response delayed: that's not what we want
    unlink($out);
}

1;
