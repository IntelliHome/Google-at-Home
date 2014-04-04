package IntelliHome::Workers::Process;

=head1 NAME

IntelliHome::Workers::Process - Base class for workers that are processes

=head1 DESCRIPTION

This Object is a wrapper for processes 

=head1 METHODS

=over 4

=item stop()

Stops the process

=item start()

Start the process

=item is_running()

return L<Unix::PID> C<is_running()> on the pid

=back

=cut

use Moose::Role;

#use IPC::Open3;
use Cwd;
use Unix::PID;
has 'Pid' => ( is => "rw" );

has 'Writer' => ( is => "rw" );
has 'Reader' => ( is => "rw" );
has 'Error'  => ( is => "rw" );

has 'UnixPid' => ( is => "rw", default => sub { return new Unix::PID; } );
has 'Directory' => ( is => "rw", default => "/var/tmp" );

sub start {
    my $self = shift;

    $SIG{'KILL'} = $SIG{'INT'} = sub { $self->stop(); };
    $SIG{'CHLD'} = 'IGNORE';

    $self->_generateOutputCommand();
    my $CWD = cwd();
    chdir( $self->Directory );
    my ( $wtr, $rdr, $err );
    use Symbol 'gensym';
    $err = gensym;
    if ( eval { $self->can("clean") } ) {
        $self->clean;
    }

    #my $pid = open3( $wtr, $rdr, $err, $self->command() );
    my $pid = fork();
    if ( !$pid ) {
        open( STDIN,  "< /dev/null" ) || die "can't read /dev/null: $!";
        open( STDERR, ">&STDOUT" )    || die "can't dup stdout: $!";
        open( STDOUT, "> /dev/null" ) || die "can't write to /dev/null: $!";
        exec( $self->command );
    }
    else {
        $self->Pid($pid);
    }
    chdir($CWD);

    #  $self->Writer($wtr);
    #  $self->Reader($rdr);
    #  $self->Error($err);
}

sub stop {
    my $self = shift;
    $self->UnixPid->kill( $self->Pid() );
    waitpid( $self->Pid(), 0 );
}

sub is_running {
    my $self = shift;
    $self->UnixPid->is_running( $self->Pid() );
}

1;
