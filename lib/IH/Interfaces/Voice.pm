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
    $self->TTS->text(@message);

    # print Dumper($self->Node);

    if ( $self->TTS->tts() ) {
        if ( defined( $self->Node() ) ) {
            my $conn = IH::Connector->new( Node => $self->Node );
            $self->failback->debug("sending raw audio");
            $conn->send_file( $self->TTS->out );
        }
        else {

            $self->failback->failback( $caller, $method,
                "[FailBack Mode from TTS] ", @message );

            #if(!system('madplay', $self->TTS->out)){
            #               unlink($self->TTS->out);
            #}

        }

    }
    else {
        $self->failback->failback( $caller, $method,
            "[FailBack Mode from TTS] ", @message );
    }

        #if(!system('madplay', $self->TTS->out)){
        #           unlink($self->TTS->out);
        #}
    



}

1;
