package IntelliHome::Workers::Node::Monitor;

=head1 NAME

IntelliHome::Workers::Node::Monitor - This thread is listening for file changes

=head1 DESCRIPTION

This Object listens for changes in the folder where sox is recording, processing the changes thru L<IntelliHome::Node::Event>

=head1 USAGE

This object is used internally by G@H

=cut

use Moo;
use AnyEvent;
use AnyEvent::Filesys::Notify;
use Carp qw( croak );
with("IntelliHome::Workers::Thread");    #is a thread

has 'Process' => ( is => "rw" );
has 'worker'  => ( is => "rw" );

sub run {
    my $self = shift;
    my $cv   = AnyEvent->condvar;

 local $SIG{'KILL'} = $SIG{'INT'} = sub { threads->exit(); };
 local $SIG{'USR1'} = sub { $self->worker->process };

    my $notifier = AnyEvent::Filesys::Notify->new(
        dirs => [@_],

   #   interval => 2.0,             # Optional depending on underlying watcher
        filter => sub { shift =~ /\.flac$/i },
        cb     => sub {
            my (@events) = @_;
            if ( $self->worker ) {
                $self->worker()->events(@events);
            }
            else {
                croak "No worker found\n";
                threads->exit();
            }
        },
    );
    $cv->recv;

}

sub process { shift->thread->kill('SIGUSR1'); }

sub launch {
    my $self = shift;
    if ( !defined $self->Process ) {
        croak ' No process defined ';
    }
    $self->callback( \&run );
    $self->args( [ $self, $self->Process->Directory ] );
    $self->start();
}

1;
