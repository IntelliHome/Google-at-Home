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

sub installPlugin {
    my $self    = shift;
    my $Options = shift;
    my $Trigger = IH::Schema::Mongo::Trigger->find_one($Options);
    return $Trigger if ($Trigger);
    $Trigger = IH::Schema::Mongo::Trigger->new( %{$Options} );
    return $Trigger->save();
}

sub removePlugin {
    my $self    = shift;
    my $Options = shift;
    my $Trigger = IH::Schema::Mongo::Trigger->find_one($Options);
    return $Trigger->remove();
}

sub updatePlugin {
    my $self          = shift;
    my $Options       = shift;
    my $UpdateOptions = shift;
    return IH::Schema::Mongo::Trigger->update( %{$Options},
        %{$UpdateOptions} );
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

sub addNode {
    my $self = shift;
    my $Args = shift;
    my $Node = IH::Schema::Mongo::Node->find_one($Args);
    return $Node if ($Node);
    $Node = IH::Schema::Mongo::Node->new( %{$Args} );
    return $Node->save();
}

sub getNodes {
    my $self  = shift;
    my $Query = shift;
    return IH::Schema::Mongo::Node->query($Query)->all();
}

sub updateNode {
    my $self          = shift;
    my $Options       = shift;
    my $UpdateOptions = shift;
    return IH::Schema::Mongo::Node->update( %{$Options}, %{$UpdateOptions} );
}

sub getActiveTasks {
    my $self = shift;
    return IH::Schema::Mongo::Task->query(
        { status => 1, node => shift->Host } )->all();
}

1;
