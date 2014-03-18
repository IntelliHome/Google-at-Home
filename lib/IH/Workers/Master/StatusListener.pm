package IH::Workers::Master::StatusListener;

=head1 NAME

IH::Workers::Master::StatusListener - Process the incoming connection

=head1 DESCRIPTION

This Object implement process() that is called by the master node to parse and process the given command


=head1 ARGUMENTS 

StatusListener implements the IH::Workers::Base arguments and implement the new one

=over
=item Output
Override Output and defaults to L<IH::Interfaces::Terminal> interface
=back

=head1 FUNCTIONS
=over
=item process()
Process the request
=back

=cut

use Moo;
extends 'IH::Workers::Base';

has 'Output' => ( is => "rw", default => IH::Interfaces::Terminal->new );

sub process {
    my $self = shift;
    my $fh   = shift;             ## IO::Socket
    my $host = $fh->peerhost();
    my $command;
    $command .= $_ while (<$fh>);
    my @Received = split( /\:/, $command );
    my $status = shift @Received;

    if ( $status eq "STATUS" ) {
        $self->status(@Received);
    }

}

sub status {
    my $self    = shift;
    my @Message = shift;

}

1;
