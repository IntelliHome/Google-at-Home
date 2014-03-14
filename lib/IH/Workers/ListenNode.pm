package IH::Workers::ListenNode;

use Moose;

has 'Output' =>
    ( is => "rw", default => sub { return new IH::Interfaces::Terminal } );
has 'tmp' => ( is => "rw", default => "/var/tmp/ih" );
has 'Process' => ( is => "rw" );

sub process {
    my $self = shift;
    my $fh   = shift;    ## IO::Socket
    my $audio;
    mkdir( $self->tmp() ) || die("Cannot create temporary directory")
        if ( !-d $self->tmp() );

    my $host = $fh->peerhost();

    #        $self->Output->info->("received answer from $host");

    while ( my $line = <$fh> ) {
        if ( $line =~ /exit/ ) {

            #do stuff
        }
        else {
            $audio .= $line;
        }
    }

    my $out = $self->tmp() . "/" . time() . ".mp3";

    open FILE, ">" . $out;
    print FILE $audio;
    close FILE;

    #$self->Process->stop() if $self->Process;
    print "Arrivato\n";
    $self->acquire_audio_lock();
    if ( !system( 'mplayer', $out ) ) {
        $self->Output->debug("Error launching mplayer");
    }
    unlink($out);
    $self->redeem_audio_lock();

}

sub acquire_audio_lock {
    my $self = shift;
    open FILE, "<" . $self->tmp() . "/.audio.lock";
    my @LOCK = <FILE>;
    close FILE;
    if ( $LOCK[0] == 1 ) {
        sleep 1;
        return $self->acquire_audio_lock;
    }
    else {
        open FILE, ">" . $self->tmp() . "/.audio.lock";
        print FILE "1";
        close FILE;
    }
}

sub redeem_audio_lock {
    my $self = shift;

    open FILE, ">" . $self->tmp() . "/.audio.lock";
    print FILE "0";
    close FILE;

}
1;
