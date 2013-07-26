package IH::Delegate;
use Moo;
use IH::GSynth;
has 'GSynth'       =>(is=>"rw",default=>sub{return new IH::GSynth});

has 'Output' => (is=>"rw",default=> sub{ return new IH::Interfaces::Terminal});

sub process(){
	my $self=shift;
	my $fh=shift;
	my $audio;
	while(<$fh>){
		$audio.=$_;
	}
	$self->GSynth->audiosynth($audio);
	        my @hypotheses=@{$self->GSynth->hypotheses()};
        if(@hypotheses <= 0){
            $self->Output->info("No result from google elapsed ".$self->GSynth->Time."s");
        } else {
            $self->Output->info("Google result : ".join("\t",  @hypotheses)." ".$self->GSynth->Time."s")  ;
        }
}

1;