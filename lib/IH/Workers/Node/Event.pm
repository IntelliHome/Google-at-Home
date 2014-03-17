package IH::Workers::Node::Event;
use IH::Interfaces::Terminal;
use IH::Google::Synth;
use IH::Connector;
use Data::Dumper;
use Moo;
has 'LastModified' => ( is => "rw" );
has 'Output' =>
    ( is => "rw", default => sub { return  IH::Interfaces::Terminal->new } );

#has 'GSynth'       =>(is=>"rw",default=>sub{return new IH::GSynth});
has 'Connector' =>
    ( is => "rw", default => sub { return IH::Connector->new } );

sub events {
    my $self = shift;
    foreach my $event (@_) {
        $self->process_created_file( $event->path )  if defined $event and $event->is_created;
        $self->process_modified_file( $event->path ) if defined $event and $event->is_modified;
        $self->process_deleted_file( $event->path )  if defined $event and $event->is_deleted;
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

sub process {
    my $self = shift;
    if ( $self->LastModified ) {
        $self->Output->info( "processing \^" . $self->LastModified . "\^" );
        $self->Connector->send_file( $self->LastModified );
        unlink( $self->LastModified );
        $self->LastModified(0);
    }
}

sub process_created_file {
    my $self = shift;
    my $File = shift;
    $self->Output->info("\^$File\^ created");
    $self->process;

}
1;
