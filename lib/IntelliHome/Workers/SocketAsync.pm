package IntelliHome::Workers::SocketAsync;

=head1 NAME

IntelliHome::Workers::SocketAsync - it represent a non blocking socket

=head1 DESCRIPTION

This Object represent a listening socket with a defined Worker to pass the socket response to be processed

=head1 METHODS

=over 4
=item launch()
Start listening
=back

=head1 ARGUMENTS
=over 4
=item Worker()
The defined worker that will be called on receiving a connection, C<process()> would be called on that object with the socket as argument
=back

=cut

use Moo;
has 'Socket' => ( is => "rw" );
has 'Worker' => ( is => "rw" );

with("IntelliHome::Workers::Thread");    #is a thread

sub run {
    my $socket = shift;
    my $worker = shift;

    while ( my $client = $socket->accept() ) {
        my $Thread = IntelliHome::Workers::SocketListener->new(
            Worker => $worker,
            Socket => $client
        );
        $Thread->launch();
    }
}

sub launch {
    my $self = shift;
    if ( !defined $self->Worker or !defined $self->Socket ) {
        die ' shame on you ';
    }
    $self->callback( \&run );
    $self->args( [ $self->Socket, $self->Worker ] );
    $self->start();    #actually starts the real thread
}

1;
