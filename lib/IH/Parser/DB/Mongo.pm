package IH::Parser::DB::Mongo;
use Moose;
extends 'IH::Parser::DB::Base';
use IH::Schema::Mongo::Need;
use IH::Schema::Mongo::Question;
use IH::Schema::Mongo::Task;
use IH::Schema::Mongo::Token;
use IH::Schema::Mongo::Trigger;
use IH::Schema::Mongo::Hypo;

sub getTriggers {
    my $self = shift;
    return IH::Schema::Mongo::Trigger->query( {} )->all();
}

sub newHypo {
    my $self  = shift;
    my $Hypos = shift;

#  return $_ if IH::Schema::Mongo::Hypo->find_one( {hypo => $Hypos->{hypo} });
    return IH::Schema::Mongo::Hypo->new( %{$Hypos} );
}

sub addTask {
    my $self = shift;
    my $Task = shift;
    return IH::Schema::Mongo::Task->new( %{$Task} );

}

sub getActiveTasks {
    my $self = shift;
    return IH::Schema::Mongo::Task->query(
        { status => 1, node => shift->Host } )->all();
}

1;
