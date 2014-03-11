package IH::Workers::Process;
use Moose::Role;
use IPC::Open3;
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

    $self->_generateOutputCommand();
    my $CWD = cwd();
    chdir( $self->Directory );
    my ( $wtr, $rdr, $err );
    use Symbol 'gensym';
    $err = gensym;
    if ( eval { $self->can("clean") } ) {
        $self->clean;
    }
    my $pid = open3( $wtr, $rdr, $err, $self->command() );
    chdir($CWD);
    $self->Pid($pid);
    $self->Writer($wtr);
    $self->Reader($rdr);
    $self->Error($err);
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
