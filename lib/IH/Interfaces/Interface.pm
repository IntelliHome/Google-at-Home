package IH::Interfaces::Interface;
use Term::ANSIColor;
use Log::Any::Adapter ( 'File', './intellihome.log' );
use Log::Any qw($log);
use Time::Piece;

use Moo;
sub setLogFile() {
    my $month = Time::Piece->new->strftime('%m');
    my $day   = Time::Piece->new->strftime('%d');
    my $year  = Time::Piece->new->strftime('%Y');
    mkdir("/var/log/intellihome") if ( !-d "/var/log/intellihome" );
    mkdir( "/var/log/intellihome/" . $year )
        if ( !-d "/var/log/intellihome/" . $year );
    mkdir( "/var/log/intellihome/" . $year . "/" . $month )
        if ( !-d "/var/log/intellihome/" . $year . "/" . $month );
    Log::Any::Adapter->set( 'File',
              "/var/log/intellihome/"
            . $year . "/"
            . $month . "/"
            . $day
            . "-intellihome.log" )
        if ( -d "/var/log/intellihome/" . $year . "/" . $month );

}


sub print() {

    my $self = shift;
    my $caller= caller();
    &setLogFile();
    print 
colored( "[", "magenta on_black bold" )
        . colored( $caller, "green on_black bold" )
        . colored( "]",   "magenta on_black bold" )
        . colored( "[", "magenta on_black bold" )
        . colored( $_[1] || "**", "green on_black bold" )
        . colored( "]",   "magenta on_black bold" )
        . colored( " (",  "magenta on_black bold" )
        . colored( $_[0], "blue on_black bold" )

        . colored( ") ", "magenta on_black bold" ) . "\n";

    $log->info( $_[0] );
}

sub print_ascii() {
    my $self  = shift;
    my $FH    = $_[0];
    my $COLOR = $_[1];

    while ( my $line = <$FH> ) {
        print colored( $line, $COLOR );

    }
}

sub AUTOLOAD {
    our $AUTOLOAD;
    my $self = shift;

    ( my $method = $AUTOLOAD ) =~ s/.*:://s;    # remove package name
    my $printable = uc($method);
    $self->print( "[$method] " . join( " ", @_ ) );
    eval { $log->$method(@_); }

}

return 1;

__DATA__