package IH::ListenAgent;
use Moo;

has 'Output' => (is=>"rw",default=> sub{ return new IH::Interfaces::Terminal});

sub process(){
	my $self=shift;
	my $fh=shift;
	my $command;
	while(<$fh>){
		$command.=$_;
	}
	$self->Output->debug("I received - $command -");
}

1;