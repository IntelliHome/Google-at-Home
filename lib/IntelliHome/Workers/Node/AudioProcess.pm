package IntelliHome::Workers::Node::AudioProcess;

=head1 NAME

IntelliHome::Workers::Node::AudioProcess - Receive the answer from the master and play it

=head1 DESCRIPTION

This Object implement process() that is called by the node to retrieve the audio to be played back as an answer


=head1 ARGUMENTS 

=head1 FUNCTIONS
=over
=item process()
Process the request and plays the mp3 answer
=back


=cut


use Moo;
has 'Output' =>
    ( is => "rw", default => sub { return IntelliHome::Interfaces::Terminal->new } );
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
    $self->Output->debug("Received audio, saved to $out");
    #$self->Process->stop() if $self->Process;
    $self->Output->debug("Error launching mplayer")
        if ( !system( 'mplayer', $out ) );

# If we don't play it's gone forever. think about a message response delayed: that's not what we want
    unlink($out);
}

1;
