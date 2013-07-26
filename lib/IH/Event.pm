package IH::Event;
use IH::Interfaces::Terminal;
use IH::GSynth;
use IH::Connector;
use Data::Dumper;
use Moo;
has 'LastModified' =>(is=>"rw");
has 'Output'       =>(is=>"rw",default=>sub{return new IH::Interfaces::Terminal});
has 'GSynth'       =>(is=>"rw",default=>sub{return new IH::GSynth});
has 'Connector'    => (is=>"rw",default=> sub{return new IH::Connector});
sub events() {
    my $self = shift;
    foreach my $event (@_) {
        $self->process_created_file( $event->path )  if $event->is_created;
        $self->process_modified_file( $event->path ) if $event->is_modified;
        $self->process_deleted_file( $event->path )  if $event->is_deleted;
    }
}

sub process_modified_file {
    my $self = shift;
    my $File = shift;
    $self->Output->info("\^$File\^ modified");
    $self->LastModified($File);

}

sub process_deleted_file {
    my $self = shift;
    my $File = shift;
    $self->Output->info("\^$File\^ deleted");
}

sub process_created_file { 
    my $self = shift;
    my $File = shift;
    $self->Output->info("\^$File\^ created");
    if($self->LastModified){
        $self->Output->info("processing \^".$self->LastModified."\^");
        $self->Connector->send_file($self->LastModified);

        # my $Synth=$self->GSynth;
        # $Synth->File($self->LastModified);
        # $Synth->synth();
        # my @hypotheses=@{$Synth->hypotheses()};
        # if(@hypotheses <= 0){
        #     $self->Output->info("No result from google elapsed ".$Synth->Time."s");
        # } else {
        #     $self->Output->info("Google result : ".join("\t",  @hypotheses)." ".$Synth->Time."s")  ;
        # }
        $self->LastModified(0);
    }

}
1;
