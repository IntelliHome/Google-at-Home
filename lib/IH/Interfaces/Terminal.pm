package IH::Interfaces::Terminal;
use Moo;
use Log::Any qw($log);
use Term::ANSIColor;
use Encode;
extends 'IH::Interfaces::Interface';

#override display to change: has this arguments (caller, method,@message)
sub display {
    my $self    = shift;
    my $caller  = shift;
    my $method  = shift;
    my @message = @_;
    $self->setLogFile();
    my $methodcolor  = "green on_black bold";
    my $messagecolor = "blue on_black bold";
    if ( $method =~ /error|alert|warning/ ) {
        $methodcolor  = "red on_black blink";
        $messagecolor = "red on_black bold";
    }
    my $time = Time::Piece->new->strftime("%Y-%m-%d %H:%M");
    print colored( "[",            "magenta on_black bold" )
        . colored( $time,          "green on_black bold" )
        . colored( "]",            "magenta on_black bold" )
        . colored( "[",            "magenta on_black bold" )
        . colored( $caller,        "green on_black bold" )
        . colored( "]",            "magenta on_black bold" )
        . colored( "[",            "magenta on_black bold" )
        . colored( "**" . $method, $methodcolor )
        . colored( "]",            "magenta on_black bold" )
        . colored( " # ",          "magenta on_black bold" )
        . colored( join( " ", map { $_ = encode_utf8($_) } @message ),
        $messagecolor )

        . colored( " # ", "magenta on_black bold" ) . "\n";
    if ( $method eq "failback" ) {
        $method = "debug";
    }
    eval { $log->$method( "[$caller][$method] " . join( " ", @_ ) ); };
}

1;
