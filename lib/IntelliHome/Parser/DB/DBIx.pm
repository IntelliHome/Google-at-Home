package IntelliHome::Parser::DB::DBIx;
use Moose;
extends 'IntelliHome::Parser::DB::Base';
use IntelliHome::Schema::SQLite::Schema;
my $schema = IntelliHome::Schema::SQLite::Schema->connect('dbi:SQLite:db/intellihome.db');

sub search_gpio {
    my $self = shift;
    my $tag  = shift;
    return $schema->resultset('GPIO')->search(
    {
        'tag.tag' => $tag
    },
    {
        join => [qw/ gpioid /]
    });
}

sub getTriggers {
    my $self = shift;
    return $schema->resultset('Trigger')->all;
}

sub installTrigger {
    my $self    = shift;
    my $Options = shift;
    my $Command = shift;
    my $comm = $schema->resultset('Command')->search(
                { command => $Command->{'command'},
                  plugin => $Command->{'plugin'} });
    return 0 unless ($comm);
    my $Trigger = $schema->resultset('Trigger')->search(
                { trigger => $Options->{'trigger'}});
    return 0 unless ($Trigger);
    my $new_trigger = $schema->resultset('Trigger')->new(%{$Options});
    $new_trigger->command($comm->commandid);
    return $new_trigger->insert;
}

sub removeTrigger {
    my $self    = shift;
    my $Options = shift;
    my $Trigger = $schema->resultset('Trigger')->search(
                { trigger => $Options->{'trigger'}})->delete_all;
}

sub newHypo {
    my $self  = shift;
    my $Hypos = shift;

#  return $_ if IntelliHome::Schema::Mongo::Hypo->find_one( {hypo => $Hypos->{hypo} });
    return IntelliHome::Schema::Mongo::Hypo->new( %{$Hypos} );
}

sub addTask {
    my $self = shift;
    my $Task = shift;
    return IntelliHome::Schema::Mongo::Task->new( %{$Task} );

}

sub addNode {
    my $self = shift;
    my $Options = shift;
    my $Room = shift;
    my $r = $schema->resultset('Room')->search(
                { name => $Room->{'name'} });
    return 0 unless ($r);
    my $Node = $schema->resultset('Node')->search(
                { host => $Options->{'host'}});
    return 0 unless ($Node);
    my $new_node = $schema->resultset('Node')->new(%{$Options});
    $new_node->room($r->roomid);
    return $new_node->insert;
}

sub getNodes {
    my $self  = shift;
    my $Query = shift;
    return $schema->resultset('Node')->all;
}

sub getActiveTasks {
    my $self = shift;
    return IntelliHome::Schema::Mongo::Task->query(
        { status => 1, node => shift->Host } )->all();
}

1;
