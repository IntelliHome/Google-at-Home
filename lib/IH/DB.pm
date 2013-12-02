package IH::DB;
use MooseX::Singleton;
use IH::Schema::Need;
use IH::Schema::Question;
use IH::Schema::Task;
use IH::Schema::Token;
use IH::Schema::Trigger;


sub addTask{
    my %$Task=shift;
    return IH::Schema::Task->new(%Task);

}



1;