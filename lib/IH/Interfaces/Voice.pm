package IH::Interfaces::Voice;
use Moo;
use IH::Google::TTS;
use IPC::Open3;
use Data::Dumper;
use IH::Connector;

extends 'IH::Interfaces::Interface';
#override display to change: has this arguments (caller, method,@message)
has 'TTS' => (is=>"rw", default=> sub{return new IH::Google::TTS;});
has 'failback' => (is=>"rw", default=> sub {return new IH::Interfaces::Terminal });
has 'Node' => (is=>"rw");
sub display (){
	my $self=shift;	



	  my $caller=shift;
    my $method=shift;
    my @message=@_;
    $self->TTS->text(@message);

			if($self->TTS->tts()){
				    if(defined($self->Node())){
 						 my $conn=IH::Connector->new(Node=>$self->Node);


   	 					  $conn->send_raw($self->TTS->Result) if($self->TTS->tts());
				   	   } else {

				   	   		#if(!system('madplay', $self->TTS->out)){
							#				unlink($self->TTS->out);
							#	}

				   	   }



			} else {
				$self->failback->failback( $caller,$method,"[FailBack Mode from TTS] ",@message);

				#if(!system('madplay', $self->TTS->out)){
				#			unlink($self->TTS->out);
				#}
			}

 	 

    if(defined($self->Node())){

	} else {
			if($self->TTS->tts()){
				
			} else {
				$self->failback->failback( $caller,$method,"[FailBack Mode from TTS] ",@message);
			}

	}

}




1;
