package IH::DB;
use MooseX::Singleton;
use IH::Schema::Need;
use IH::Schema::Question;
use IH::Schema::Task;
use IH::Schema::Token;
use IH::Schema::Trigger;
use IH::Schema::Hypo;
### XXX: untested
sub addHypo {
    my %Hypos = shift;
    return $_ if IH::Schema::Hypo->find_one( hypo => $Hypos{hypo} );
    return IH::Schema::Hypo->new(%Hypos);
}

sub addTask {
    my %Task = shift;
    return IH::Schema::Task->new(%Task);

}

sub getActiveTasks {
    return IH::Schema::Task->query( { status => 1, node => shift->Host } )
        ->all();
}

1;
