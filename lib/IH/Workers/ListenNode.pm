package IH::Workers::ListenNode;

use Moo;

has 'Output' => (is=>"rw",default=> sub{ return new IH::Interfaces::Voice});
has 'tmp' => (is=>"rw", default=>"/var/tmp/ih");

sub process(){
	my $self=shift;
	my $fh=shift; ## IO::Socket
	my $audio;
	mkdir($self->tmp()) || die("Cannot create temporary directory")  if (!-d $self->tmp());

      my     $host=$fh->peerhost();
	while(my $line= <$fh>){
		if($line=~/exit/){
		#do stuff
		} else {
		$audio.=$_;	
		}
	}

			my $out=$self->tmp()."/".time().".mp3";

	open FILE,">".$out;
	print FILE $audio;
	close FILE;
		if(!system('madplay', $out)){
					unlink($out);
		}
}




1;