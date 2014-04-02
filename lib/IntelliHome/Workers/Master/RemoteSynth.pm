package IntelliHome::Workers::Master::RemoteSynth;

=head1 NAME

IntelliHome::Workers::Master::RemoteSynth - Processes the voice hypothesis thru a defined parser

=head1 DESCRIPTION

This Object implement process() that is called by the master node to parse and process the given command


=head1 ARGUMENTS 

RemoteSynth implements the IntelliHome::Workers::Base arguments and implement the follow one

=over
=item GSynth() 
Get/Set the used Synthetizer (defaults to IntelliHome::Google::Synth)
=back
=item Parser()
Get/Set the parser used to process the command (default loaded from Config)
=back

=head1 FUNCTIONS
=over
=item process()
Process the request with the parser specified in the config file
=back


=cut

use Moo;
extends 'IntelliHome::Workers::Base';
use IntelliHome::Google::Synth;
use IntelliHome::Interfaces::Voice;
use Module::Load;
with("IntelliHome::Workers::Role::Parser");
has 'GSynth' => (
    is      => "rw",
    default => sub {
        return IntelliHome::Google::Synth->new;
    }
);


sub process {
    my $self = shift;
    my $fh   = shift;    ## IO::Socket
    my $audio;
    my $host = $fh->peerhost();
    my $node
        = "IntelliHome::Schema::"
        . $self->Config->DBConfiguration->{'database_backend'}
       #    . "YAML" #XXX: we force to yaml for now, but the backend will be switchable when autoconfiguration would be ready

        . "::Node";
    load $node;
    my $Client = $node->new( Config => $self->Config );
    $Client->selectFromHost( $host, "node" );
    $self->Output->Node($Client);

    while (<$fh>) {
        $audio .= $_;
    }

    $self->GSynth->audiosynth($audio);
    my @hypotheses = @{ $self->GSynth->hypotheses() };
        $self->Output->debug("audio received from $host");
    $self->Output->debug("Hypothesis: ".join("\t",@hypotheses));

    if ( @hypotheses > 0 ) {

        $self->Parser->Node($Client);
        $self->Parser->Output( $self->Output );
        $self->Parser->parse(@hypotheses);

        #$self->Output->info( $hypotheses[0] );

        # $self->Output->info( "Google result for "
        #         . $host . ": "
        #         . join( "\t", @hypotheses ) . " "
        #         . $self->GSynth->Time
        #         . "s" );

        #Let's visualize the hypotesis for now
    }
}

1;
