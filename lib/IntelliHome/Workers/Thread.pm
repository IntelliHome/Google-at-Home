package IntelliHome::Workers::Thread;

=head1 NAME

IntelliHome::Workers::Thread - Base class for workers that are threads

=head1 DESCRIPTION

This Object is a wrapper for threads

=head1 METHODS

=over 4

=item stop()

Stops the thread

=item start()

Start the thread

=item is_running()

return L<threads> C<is_running()> on the thread

=item is_detached()

return L<threads> C<is_detached()> on the thread

=back

=cut

use Moo::Role;
use Config;
if ( $Config{usethreads} ) {
    require threads;
    threads->import();
}
else {
    require forks;
    forks->import();
}

use Carp qw( croak );
use IntelliHome::Utils qw(class_inner_name);
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

sub launch {
    my $self = shift;
    $self->callback( class_inner_name($self) . "::run" );
    $self->args( [ $self, @_ ] );
    $self->start();
}

sub join {
    my $self = shift;
    if ( defined $self->thread ) {
        $self->thread->join;
    }
}

sub stop {
    my $self = shift;
    if ( defined $self->thread and !$self->thread->is_detached ) {
        $self->thread->kill('KILL')->detach;
    }
}

sub signal {
    my $self   = shift;
    my $signal = shift;
    if ( defined $self->thread and !$self->thread->is_detached ) {
        $self->thread->kill($signal);
    }
    return $self->thread;
}

sub is_running { shift->thread->is_running(); }

sub is_detached { shift->thread->is_detached(); }
1;
