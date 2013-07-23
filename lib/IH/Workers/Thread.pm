package IH::Workers::Thread;
use Moo::Role;
use threads (
    'yield',
    'stack_size' => 64 * 4096,
    'exit'       => 'threads_only',
    'stringify'
);
use Carp qw( croak );
has 'Directory' => ( is => "rw", default => "/tmp" );
has 'callback'  => ( is => "rw" );
has 'args'      => ( is => "rw" );
has 'thread'    => ( is => "rw" );

sub start() {
    my $self = shift;
    if ( !defined $self->callback ) {
        croak 'No callback defined for thread';
    }
    my $thr = threads->create(

        $self->callback()

        , @{ $self->args() }
    );
    $self->thread($thr);

}

sub stop() {
    my $self = shift;
    if ( !$self->thread->is_detached ) {
        $self->thread->kill('KILL')->detach;
    }
}

sub is_running() {
    my $self = shift;
    return $self->thread->is_running();

}

sub is_detached() {
    my $self = shift;
    return $self->thread->is_detached();

}
1;
