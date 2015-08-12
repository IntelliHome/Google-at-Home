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
if ( $Config{usethreads} or $Config{useithreads} ) {
    require threads;
    threads->import();
}
else {
    require Child;
    Child->import();
}

use Carp qw( croak );
use IntelliHome::Utils qw(class_inner_name);
has 'Directory' => ( is => "rw", default => "/tmp" );
has 'callback'  => ( is => "rw" );
has 'args'      => ( is => "rw" );
has 'thread'    => ( is => "rw" );

sub start {
    my $self = shift;
    croak 'No callback defined for thread' if ( !defined $self->callback );
    $self->thread(
        Child->new( sub { &$self->callback( @{ $self->args() } ) } )->start );
}

sub launch {
    my $self = shift;
    $self->callback( class_inner_name($self) . "::run" );
    $self->args( [ $self, @_ ] );
    $self->start();
    return $self;
}

sub join {
    $_[0]->thread->wait
        if ( defined $_[0]->thread );
    return $_[0];
}

sub stop {
    $_[0]->thread->unix_exit()
        if ( defined $_[0]->thread );
    return $_[0];
}

sub detach {
    return $_[0];
}

sub signal {
    $_[0]->thread->kill( $_[1] )
        if ( defined $_[0]->thread );
    return $_[0];
}

sub is_running { !$_[0]->thread->is_complete; }

sub is_detached {1}
1;
