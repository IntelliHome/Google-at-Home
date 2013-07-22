package IH::Event;

use Moo;

sub events(){
	my $self=shift;
	foreach my $event(@_){
		$self->process_created_file($event->path)  if $event->is_created;
        $self->process_modified_file($event->path) if $event->is_modified;
        $self->process_deleted_file($event->path)  if $event->is_deleted;
	}
}

sub process_modified_file{
	my $self=shift;
	my $File=shift;
	print "Someone modified $File, that's really bad\n";

}

sub process_deleted_file{
	my $self=shift;
		my $File=shift;

	print "Someone deleted $File, that's really bad\n";

}
sub process_created_file{
		my $self=shift;
			my $File=shift;
	print "Someone created $File, that's really bad\n";


}
1;