package IH::Interfaces::Voice;
use Moo;
use IH::Google::TTS;
use IPC::Open3;
use Data::Dumper;
use IH::Connector;

extends 'IH::Interfaces::Interface';

#declare display to change: has this arguments (caller, method,@message)
has 'TTS' => ( is => "rw", default => sub { return IH::Google::TTS->new } );
has 'failback' =>
    ( is => "rw", default => sub { return IH::Interfaces::Terminal->new } );
has 'Node'   => ( is => "rw" );
has 'Config' => ( is => "rw" );

sub BUILD {
    my $self = shift;
    $self->TTS->Language( $self->Config->DBConfiguration->{'language'} )
        if ( defined $self->Config );
}

sub display {
    my $self = shift;

    my $caller  = shift;
    my $method  = shift;
    my @message = @_;
    $self->setLogFile();
    return $self->failback->debug( $caller, $method,
        "[FailBack Mode from TTS] ", @message )
        if $method eq "debug";

    # print Dumper($self->Node);
    $self->TTS->text(@message);
     my $errors=$self->TTS->tts();
    if (    $self->TTS->text()
        and -e $self->TTS->out
        and defined( $self->Node() )
        )
    {
        my $conn = IH::Connector->new( Node => $self->Node );
      #  $self->failback->debug("sending raw audio");
        $conn->send_file( $self->TTS->out );

        $self->failback->debug("There where ".$errors);
        unlink($self->TTS->out);
        unlink($_) for @{$self->TTS->responses};
    }
    else {
        $self->failback->debug( $caller, $method,
            "[FailBack Mode from TTS] ", @message );
    }
}

1;
