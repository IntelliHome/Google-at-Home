package IntelliHome::Interfaces::Voice;
use Moo;
use IntelliHome::Google::TTS;
use IPC::Open3;
use IntelliHome::Connector;

extends 'IntelliHome::Interfaces::Interface';

#declare display to change: has this arguments (caller, method,@message)
has 'TTS' =>
    ( is => "rw", default => sub { return IntelliHome::Google::TTS->new } );
has 'failback' => (
    is      => "rw",
    default => sub { return IntelliHome::Interfaces::Terminal->new }
);
has 'Node'   => ( is => "rw" );

sub BUILD {
    my $self = shift;
    $self->TTS->Language( $self->Config->DBConfiguration->{'language'} )
        if ( defined $self->Config );
}

sub display {
    my $self    = shift;
    my $caller  = shift;
    my $method  = shift;
    my @message = @_;
    $self->setLogFile();
    return $self->failback->debug( $caller, $method,
        "[FailBack Mode from TTS] ", @message )
        if $method eq "debug";
    $self->TTS->text(@message);
    my $errors = $self->TTS->tts();

    if (    $self->TTS->text()
        and -e $self->TTS->out
        and defined( $self->Node() ) )
    {
        my $conn = IntelliHome::Connector->new( Node => $self->Node );
        $conn->send_file( $self->TTS->out );
        $self->failback->debug( "There where "
                . $errors
                . " errors in the generation of the response" );
        unlink( $self->TTS->out );
        unlink($_) for @{ $self->TTS->responses };
    }
    else {
        $self->failback->debug( $caller, $method,
            "[FailBack Mode from TTS] ", @message );
    }
}

1;
