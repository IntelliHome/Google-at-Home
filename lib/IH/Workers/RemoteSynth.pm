package IH::Workers::RemoteSynth;
use Moo;
use IH::Google::Synth;
use IH::Interfaces::Voice;
use IH::Parser;
use Data::Dumper;
has 'GSynth' =>
    ( is => "rw", default => sub { return new IH::Google::Synth } );
has 'Config' => ( is => "rw" );
has 'Output' =>
    ( is => "rw", default => sub { return new IH::Interfaces::Voice } );
has 'Parser' => ( is => "rw", default => sub { return new IH::Parser } );

sub process() {
    my $self = shift;
    my $fh   = shift;    ## IO::Socket
    my $audio;
    my $host = $fh->peerhost();
    while (<$fh>) {
        $audio .= $_;
    }

    $self->GSynth->audiosynth($audio);
    my @hypotheses = @{ $self->GSynth->hypotheses() };
    if ( @hypotheses <= 0 ) {

        $self->Output->info( " ["
                . $host
                . "] No result from google elapsed "
                . $self->GSynth->Time
                . "s" );

    }
    else {

        my $Client = IH::Node->new( Config => $self->Config );
        $Client->selectFromHost($host);
        # $self->Parser->Node($Client);
        # $self->Parser->parse(@hypotheses);

        $self->Output->info( $hypotheses[0] );

#     $self->Output->info("Google result for ".$host.": ".join("\t",  @hypotheses)." ".$self->GSynth->Time."s")  ;
    }
}

1;
