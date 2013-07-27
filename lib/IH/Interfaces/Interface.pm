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

sub display(){
    my $self=shift;
    my $caller=shift;
    my $method=shift;
    my @message=@_;

    my $methodcolor="green on_black bold";
    my $messagecolor="blue on_black bold";
    if($method =~ /error|alert|warning/) {
        $methodcolor="red on_black blink";
        $messagecolor="red on_black bold";
    }
my $time = Time::Piece->new->strftime( "%Y-%m-%d %H:%M");
    print colored( "[",            "magenta on_black bold" )
        . colored( $time,        "green on_black bold" )
        . colored( "]",            "magenta on_black bold" )
        . colored( "[",            "magenta on_black bold" )
        . colored( $caller,        "green on_black bold" )
        . colored( "]",            "magenta on_black bold" )
        . colored( "[",            "magenta on_black bold" )
        . colored( "**" . $method, $methodcolor)
        . colored( "]",            "magenta on_black bold" )
        . colored( " # ",           "magenta on_black bold" )
        . colored( join( " ", @_ ), $messagecolor )

        . colored( " # ", "magenta on_black bold" ) . "\n";
    eval { $log->$method( "[$caller][$method] " . join( " ", @_ ) ); };
}

sub AUTOLOAD {
    our $AUTOLOAD;
    my $self   = shift;
    my $caller = caller();
    ( my $method = $AUTOLOAD ) =~ s/.*:://s;    # remove package name
    my $printable = uc($method);
    &setLogFile();
    $self->display($caller,$method,@_);

}

return 1;

__DATA__
