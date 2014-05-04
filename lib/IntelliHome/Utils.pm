package IntelliHome::Utils;

use warnings;
use strict;
use base qw(Exporter);

use constant SEPARATOR => ":";
our @EXPORT_OK = qw(
    message_expand SEPARATOR message_compact daemonize
);

sub message_expand {
    my $message = shift;
    split( SEPARATOR, $message );
}

sub message_compact {
    my @message = @_;
    join( SEPARATOR, @message );
}

sub daemonize {
    use POSIX;
    POSIX::setsid or die "setsid: $!";
    my $pid = fork();
    if ( $pid < 0 ) {
        die "fork: $!";
    }
    elsif ($pid) {
        exit 0;
    }

    #chdir "/";
    umask 0;
    foreach ( 0 .. ( POSIX::sysconf(&POSIX::_SC_OPEN_MAX) || 1024 ) ) {
        POSIX::close $_;
    }
    open( STDIN,  "</dev/null" );
    open( STDOUT, ">/dev/null" );
    open( STDERR, ">&STDOUT" );
}

1;
