package IH::Monitor;
use Moose;

use AnyEvent;
use AnyEvent::Filesys::Notify;
use Data::Dumper;
use Carp qw( croak );
with("IH::Workers::Thread"); #is a thread

has 'Process' => ( is => "rw" );
has 'worker'  => ( is => "rw" );

sub run() {
    my $self     = shift;
    my $cv       = AnyEvent->condvar;
    my $notifier = AnyEvent::Filesys::Notify->new(
        dirs => [@_],

   #   interval => 2.0,             # Optional depending on underlying watcher
        filter => sub { shift =~ /\.(flac|FLAC)$/ },
        cb     => sub {
            my (@events) = @_;
            if ( $self->worker ) {
                $self->worker()->events(@events);
            }
            else {
                croak "No worker found\n";
                threads->exit();

                #  print Dumper(@events);
            }
        },
    );
    $cv->recv;

}

sub launch() {
    my $self = shift;
    if ( !defined $self->Process ) {
        croak ' No process defined ';
    }
    $self->callback( \&run );
    $self->args( [ $self, $self->Process->Directory ] );
    $self->start();
}

1;
