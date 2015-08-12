package IntelliHome::Utils;

use warnings;
use strict;
use base qw(Exporter);
use Mojo::Loader qw(load_class);
use File::Basename qw(fileparse);
use File::Spec::Functions qw(catdir catfile splitdir);
use constant SEPARATOR => ":";
our @EXPORT_OK = qw(
    message_expand SEPARATOR message_compact daemonize cleanup stop_process load_module search_modules
    class_inner_name search_modulesd
);

sub load_module($) {
    my $module = shift;
    my $e      = load_class $module;
    warn qq{Loading "$module" failed: $e} and next if ref $e;
    return 1;
}

sub class_inner_name($) { ( shift =~ /(.*)\=/ )[0]; }

sub search_modules($) {
    return find_modules(shift);
}

sub search_modulesd($) {
    my $ns = shift;
    my %modules;
    for my $directory (@INC) {
        next unless -d ( my $path = catdir $directory, split( /::|'/, $ns ) );

        # List "*.pm" files in directory
        opendir( my $dir, $path );
        for my $file ( readdir $dir ) {
            next if $file eq '..' or $file eq '.';
            if ( -d catdir $path, $file ) {
                $modules{$_}++
                    for ( &search_modulesd("${ns}::${file}") )
                    ;    #making recursive
            }
            elsif ( $file =~ /\.pm/ ) {
                next if -d catfile splitdir($path), $file;
                $modules{ "${ns}::" . fileparse $file, qr/\.pm/ }++;
            }

        }
    }

    wantarray ? ( keys %modules ) : return [ keys %modules ];
}

sub stop_process($) {
    my $runner = shift;
    use IntelliHome::Interfaces::Terminal;              # lazy load
    my $IHOutput
        = IntelliHome::Interfaces::Terminal->instance;  #set up output (debug)
    my $pid = Unix::PID->new->get_pid_from_pidfile("/var/tmp/ih/$runner.pid");
    if ( $pid != 0 ) {
        kill -10 => $pid;
        $IHOutput->info("Terminating");
    }
    else {
        $IHOutput->error("nothing appear to be running");
    }
    exit 0;
}

sub cleanup {
    unlink
        for (
        ( glob "/var/tmp/sox/*" ),

        #( glob "/var/tmp/ih/*" )
        );
}

sub message_expand($) {
    my $message = shift;
    split( SEPARATOR, $message );
}

sub message_compact(@) {
    my @message = @_;
    join( SEPARATOR, @message );
}

# here is where we make ourself a daemon
sub daemonize($) {
    my $runner = shift;
    use POSIX qw(setsid);

    #chdir ‘/’ or die “Can’t chdir to /: $!”;
    defined( my $pid = fork ) or die "Can’t fork: $!";
    exit if $pid;
    setsid or die "Can’t start a new session: $!";
    umask 0;
    use Unix::PID;
    Unix::PID->new()->pid_file( '/var/tmp/ih/' . $runner . '.pid' )
        or return undef;
    open STDIN,  "/dev/null"   or die "Can’t read /dev/null: $!";
    open STDOUT, ">>/dev/null" or die "Can’t write to /dev/null: $!";
    open STDERR, ">>/dev/null" or die "Can’t write to /dev/null: $!";
    return 1;
}

1;
