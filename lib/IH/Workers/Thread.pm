package IH::Workers::Thread;
use Moose::Role;
use threads (
    'yield',
    'stack_size' => 64 * 4096,
    'exit'       => 'threads_only',
    'stringify'
);

#Or you want to use forks?
use Carp qw( croak );
has 'Directory' => ( is => "rw", default => "/tmp" );
has 'callback'  => ( is => "rw" );
has 'args'      => ( is => "rw" );
has 'thread'    => ( is => "rw" );

sub start {
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

sub stop {
    my $self = shift;
    if ( !$self->thread->is_detached ) {
        $self->thread->kill('KILL')->detach;
    }
}

sub is_running { shift->thread->is_running(); }

sub is_detached { shift->thread->is_detached(); }
1;
