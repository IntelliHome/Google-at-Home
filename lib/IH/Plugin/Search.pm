package IH::Plugin::Search;
use Moose;
use IH::Schema::Mongo::Trigger;

extends 'IH::Plugin::Base';

sub run {
    my $self       = shift;
    my @hypothesis = @_;
}

sub echo {
    my $self = shift;
    my $Said = shift;
    $self->Parser->Output->info(
        "Hai detto " . join( " ", @{ $Said->result } ) );

}



1;
