package IntelliHome::Workers::Node::Event;


=head1 NAME

IntelliHome::Workers::Node::Event - Process the event for the sox created files

=head1 DESCRIPTION

This Object process an action for modify/creation/deletion events of file 

=head1 USAGE 

This object is used internally by G@H and takes care of dispatching the event to be processed

=cut

use Moo;
use IntelliHome::Interfaces::Terminal;
use IntelliHome::Connector;

has 'LastModified' => ( is => "rw" );
has 'Output' =>
    ( is => "rw", default => sub { return  IntelliHome::Interfaces::Terminal->new } );

has 'Connector' =>
    ( is => "rw", default => sub { return IntelliHome::Connector->new } );

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
