package IntelliHome::Parser::DB::SQLite;
use Moose;
extends 'IntelliHome::Parser::DB::Base';
use IntelliHome::Schema::SQLite::Schema;
use IntelliHome::Utils qw(load_module);

has 'dsn' => (
    is      => "rw",
    default => 'dbi:SQLite:/var/lib/intellihome/intellihome.db'
);

sub Schema {
    return IntelliHome::Schema::SQLite::Schema->connect( shift->dsn );
}

sub search_gpio {
    my $self = shift;
    my $tag  = shift;
    return $self->Schema->resultset('GPIO')
        ->search( { 'tag.tag' => $tag }, { join => [qw/ gpioid /] } )->all();
}

sub search_gpio_pin {
    my $self = shift;
    my $id   = shift;

    my $gpio_rs
        = $self->Schema->resultset('GPIO')->single( { gpioid => $id } );
    return $gpio_rs->search_related('pins')->all;
}

sub search_gpio_id {
    my $self = shift;
    my $id   = shift;
    return $self->Schema->resultset('GPIO')->single( { gpioid => $id } );
}

sub get_all_gpio {
    my $self = shift;
    return $self->Schema->resultset('GPIO')->all();
}

sub get_all_gpio_data {
    my $self = shift;
    return map {
        $_ = {
            title  => $_->tags->first()->tag,
            id     => $_->gpioid,
            image  => 0,
            driver => $_->driver,
            status => $_->status,
            toggle => ( ( split( /::/, $_->driver ) )[-1] eq "Mono" ) ? 1 : 0,
            gpio   => $_->pin_id,
            node_data => [ $_->node ],
            type      => $_->type,
            room      => $_->node->room->name,
            tags_data => [ $_->tags->all() ],
            pins_data => [ $_->pins->all() ]
        };
        $_;
    } $self->Schema->resultset('GPIO')->all();
}

sub get_all_rooms {
    my $self = shift;
    return map {
        $_ = {
            id          => $_->roomid,
            name        => $_->name,
            location    => $_->location,
            description => $_->description,
            notes       => $_->notes,
            nodes_data  => [ $_->nodes->all() ]
        };
        $_;
    } $self->Schema->resultset('Room')->all();
}

sub get_all_nodes {
    my $self = shift;
    return map {
        $_ = {
            id          => $_->nodeid,
            name        => $_->name,
            description => $_->description,
            host        => $_->host,
            port        => $_->port,
            type        => $_->type,
            username    => $_->username,
            password    => $_->password,
            gpios_data  => [ $_->gpios->all() ],
            room_data   => [ $_->room ]
        };
        $_;
    } $self->Schema->resultset('Node')->all();
}

sub search_room {
    my $self = shift;
    my $room = shift;
    return $self->Schema->resultset('Room')
        ->search( { name => { 'like', '%' . $room . '%' } } )->all();
}

sub search_node {
    my $self = shift;
    my $node = shift;
    return $self->Schema->resultset('Node')
        ->search( { name => { 'like', '%' . $node . '%' } } )->all();
}

sub search_trigger {
    my $self    = shift;
    my $trigger = shift;
    return $self->Schema->resultset('Trigger')
        ->search( { trigger => { 'like', '%' . $trigger . '%' } } );
}

sub getTriggers {
    my $self = shift;
    return $self->Schema->resultset('Trigger')->all;
}

sub installPlugin {
    shift->installTrigger($_) for @_;
}

sub installTrigger {
    my $self    = shift;
    my $Options = shift;
    my $Command = shift;
    my $comm    = $self->Schema->resultset('Command')->search(
        {   command => $Command->{'command'},
            plugin  => $Command->{'plugin'}
        }
    );
    return 0 unless ($comm);
    my $Trigger = $self->Schema->resultset('Trigger')
        ->search( { trigger => $Options->{'trigger'} } );
    return 0 unless ($Trigger);
    my $new_trigger = $self->Schema->resultset('Trigger')->new( %{$Options} );
    $new_trigger->command( $comm->commandid );
    return $new_trigger->insert;
}

sub removeTrigger {
    my $self    = shift;
    my $Options = shift;
    my $Trigger = $self->Schema->resultset('Trigger')
        ->search( { trigger => $Options->{'trigger'} } )->delete_all;
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
    my $node = shift;
    my $room = shift;
    my $r    = $self->Schema->resultset('Room')
        ->search( { name => $room->{'name'} } );
    return 0 unless ($r);
    return 0
        if ( $self->Schema->resultset('Node')
        ->search( { host => $node->{'host'}, type => $node->{'type'} } ) );
    $node->{'roomid'} = $r->roomid;
    return $self->Schema->resultset('Node')->create( %{$node} );
}

sub add_room {
    my $self = shift;
    my $room = shift;
    return 0
        if ( $self->Schema->resultset('Room')
        ->search( { name => $room->{'name'} } ) );
    return $self->Schema->resultset('Room')->create( %{$room} );
}

sub add_tag {
    my $self = shift;
    my $tag  = shift;
    my $gpio = shift;
    my $g    = $self->Schema->resultset('GPIO')
        ->search( { gpioid => $gpio->{'id'} } );
    return 0 unless ($g);
    return 0
        if (
        $self->Schema->resultset('Tag')->search( { tag => $tag->{'tag'} } ) );
    $tag->{'gpioid'} = $g->gpioid;
    return $self->Schema->resultset('GPIO')->create( %{$tag} );
}

sub add_pin {
    my $self = shift;
    my $pin  = shift;
    my $gpio = shift;
    my $g    = $self->Schema->resultset('GPIO')
        ->search( { gpioid => $gpio->{'id'} } );
    return 0 unless ($g);
    return 0
        if ( $self->Schema->resultset('Pin')
        ->search( { pin => $pin->{'pin'}, gpioid => $g->gpioid } ) );
    $pin->{'gpioid'} = $g->gpioid;
    return $self->Schema->resultset('Pin')->create( %{$pin} );
}

sub add_gpio {
    my $self = shift;
    my $gpio = shift;
    my $node = shift;
    my $n    = $self->Schema->resultset('Node')
        ->search( { nodeid => $node->{'id'} } );
    return 0 unless ($n);
    return 0
        if ( $self->Schema->resultset('GPIO')
        ->search( { pin_id => $gpio->{'pin_id'}, nodeid => $n->nodeid } ) );
    $gpio->{'nodeid'} = $n->nodeid;
    return $self->Schema->resultset('GPIO')->create( %{$gpio} );
}

sub delete_element {
    my $self   = shift;
    my $entity = shift;
    my $id     = shift;
    our @available_classes = qw(GPIO Node Pin Room Tag Trigger User Command);
    return 0
        if ( !defined $entity
        or !( grep { $_ eq $entity } @available_classes ) );
    return $self->Schema->resultset($entity)
        ->search(
        { lc($entity)."id" => $id } )
        ->delete();
}

sub getNodes {
    my $self  = shift;
    my $Query = shift;
    return $self->Schema->resultset('Node')->search($Query);
}

sub getActiveTasks {
    my $self = shift;
    return IntelliHome::Schema::Mongo::Task->query(
        { status => 1, node => shift->Host } )->all();
}

sub node {
    my $self = shift;
    my $node = "IntelliHome::Schema::SQLite::Schema::Result::Node";
    return $node->new() if ( load_module($node) );
}

sub selectFromHost {
    return
        shift->Schema->resultset('Node')
        ->search( { Host => shift, type => shift } )->single;
}

sub selectFromType {
    return
        shift->Schema->resultset('Node')->search( { type => shift } )->single;

}

1;
