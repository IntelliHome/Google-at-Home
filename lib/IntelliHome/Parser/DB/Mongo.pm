package IntelliHome::Parser::DB::Mongo;
use Moo;
extends 'IntelliHome::Parser::DB::Base';
use IntelliHome::Schema::Mongo::Need;
use IntelliHome::Schema::Mongo::Question;
use IntelliHome::Schema::Mongo::Task;
use IntelliHome::Schema::Mongo::Token;
use IntelliHome::Schema::Mongo::Trigger;
use IntelliHome::Schema::Mongo::Hypo;

sub search_gpio {
    my $self = shift;
    my $tag  = shift;
    return IntelliHome::Schema::Mongo::GPIO->query( { tags => qr/$tag/ } )
        ->all();
}

sub search_gpio_pin {
    return IntelliHome::Schema::Mongo::GPIO->find_one(
        { '$or' => [ { pin_id => $_[1] }, { pins => $_[1] } ] } );
}

sub search_gpio_id {
    return IntelliHome::Schema::Mongo::GPIO->find_one( { id => $_[1] } );
}

sub getTriggers {
    my $self = shift;
    my $language;
    $language = shift @_ if (@_);
    return IntelliHome::Schema::Mongo::Trigger->query( {} )->all()
        if ( !defined $language );
    return IntelliHome::Schema::Mongo::Trigger->query(
        { language => $language } )->all()
        if ( defined $language );
}

sub installPlugin {
    shift->installTrigger($_) for @_;
}

sub installTrigger {
    my $self    = shift;
    my $Options = shift;
    $Options->{'plugin'} = ( split( /::/, caller ) )[-1]
        if ( !exists $Options->{'plugin'} );
    my $Trigger = IntelliHome::Schema::Mongo::Trigger->find_one($Options);
    return $Trigger if ($Trigger);
    $Trigger = IntelliHome::Schema::Mongo::Trigger->new( %{$Options} );
    return $Trigger->save();
}

sub removePlugin {
    my $self    = shift;
    my $Options = shift;
    IntelliHome::Schema::Mongo::Trigger->find($Options)->each(
        sub {
            my $obj = shift;
            $obj->delete();
        }
    );
}

sub updatePlugin {
    my $self          = shift;
    my $Options       = shift;
    my $UpdateOptions = shift;
    return IntelliHome::Schema::Mongo::Trigger->update( %{$Options},
        %{$UpdateOptions} );
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
    my $Args = shift;
    my $Node = IntelliHome::Schema::Mongo::Node->find_one($Args);
    return $Node if ($Node);
    $Node = IntelliHome::Schema::Mongo::Node->new( %{$Args} );
    return $Node->save();
}

sub getNodes {
    my $self  = shift;
    my $Query = shift;
    return IntelliHome::Schema::Mongo::Node->query($Query)->all();
}

sub updateNode {
    my $self          = shift;
    my $Options       = shift;
    my $UpdateOptions = shift;
    return IntelliHome::Schema::Mongo::Node->update( %{$Options},
        %{$UpdateOptions} );
}

sub getActiveTasks {
    my $self = shift;
    return IntelliHome::Schema::Mongo::Task->query(
        { status => 1, node => shift->Host } )->all();
}

1;
