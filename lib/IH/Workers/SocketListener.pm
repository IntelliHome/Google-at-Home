package IH::Workers::SocketListener;
use Moose;
has 'Socket' =>( is=>"rw");
has 'Worker' =>( is=>"rw");

with("IH::Workers::Thread"); #is a thread

sub run(){
	my $socket=shift;
	my $worker=shift;
	$worker->process($socket);

}

sub launch() {
    my $self = shift;
    if ( !defined $self->Worker or !defined $self->Socket ) {
        die ' shame on you ';
    }
    $self->callback( \&run );
    $self->args( [ $self->Socket, $self->Worker] );
    $self->start();#actually starts the real thread
}

1;

