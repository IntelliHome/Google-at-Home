use Test::More;
use_ok("IntelliHome::Schema::SQLite::Schema");
use IntelliHome::Parser::DB::SQLite;
use File::Path qw(make_path remove_tree);
use_ok("IntelliHome::Deployer::Schema::SQLite");
use_ok("DBD::SQLite");

#CLEANING
unlink("/tmp/intellihome.db");
remove_tree("/tmp/db_upgrades");
my $Deployer = IntelliHome::Deployer::Schema::SQLite->new(
    dh => DBIx::Class::DeploymentHandler->new(
        {   schema => IntelliHome::Schema::SQLite::Schema->connect(
                'dbi:SQLite:/tmp/intellihome.db'
            ),
            script_directory => '/tmp/db_upgrades',
            databases        => 'SQLite',
            force_overwrite  => 1,
            schema_version   => 1
        }
    )
);

$Deployer->prepare;
$Deployer->install;
my $schema = IntelliHome::Schema::SQLite::Schema->connect(
    'dbi:SQLite:/tmp/intellihome.db');

my $room_data = {
    'name'     => "bedroom",
    'location' => "bedroom first floor"
};

my $room = $schema->resultset('Room')->create($room_data);

my $node_data1 = {
    'roomid'   => $room->id,
    'name'     => 'master',
    'host'     => 'localhost',
    'port'     => 23459,
    'type'     => 'master',
    'username' => 'username',
    'password' => 'passwd'
};

my $node_data2 = {
    'roomid'   => $room->id,
    'name'     => 'master',
    'host'     => '127.0.0.1',
    'port'     => 23456,
    'type'     => 'node',
    'username' => 'username',
    'password' => 'passwd'
};

my $node_one = $schema->resultset('Node')->create($node_data1);
my $node_two = $schema->resultset('Node')->create($node_data2);

my $gpio_data1 = {
    'nodeid' => $node_two->id,
    'pin_id' => 1,
    'type'   => 3,
    'value'  => 0,
    'driver' => "IntelliHome::Driver::GPIO::Mono"
};

my $gpio_data2 = {
    'nodeid' => $node_two->id,
    'pin_id' => 2,
    'type'   => 1,
    'value'  => 1,
    'driver' => "IntelliHome::Driver::GPIO::Dual"
};

my $gpio_one = $schema->resultset('GPIO')->create($gpio_data1);
my $gpio_two = $schema->resultset('GPIO')->create($gpio_data2);

my $tag_data1 = {
    'gpioid' => $gpio_one->id,
    'tag'    => "serranda 1"
};

my $tag_data2 = {
    'gpioid' => $gpio_two->id,
    'tag'    => "serranda 2"
};

my $tag_one = $schema->resultset('Tag')->create($tag_data1);
my $tag_two = $schema->resultset('Tag')->create($tag_data2);

my $user_data1 = {
    'username' => "user1",
    'password' => "password",
    'name'     => "User 1",
    'admin'    => 0
};

my $user_data2 = {
    'username' => "user2",
    'password' => "password",
    'name'     => "User 2",
    'admin'    => 1
};

my $user_one = $schema->resultset('User')->create($user_data1);
my $user_two = $schema->resultset('User')->create($user_data2);

$schema->DESTROY();

my $Backend = IntelliHome::Parser::DB::SQLite->new(
    dsn => 'dbi:SQLite:/tmp/intellihome.db' );

###### TESTING BACKEND DB CONSISTENCY
is( ( $Backend->get_all_rooms )[0]->{name},
    "bedroom", "Getting first room name" );

is( scalar( $Backend->get_all_rooms ), 1, "One room" );
is( ( $Backend->search_room("bed") )[0]->name,
    "bedroom", "Searching room name" );
is( ( $Backend->get_all_gpio() )[0]->{type},  3, "Get first gpio type" );
is( ( $Backend->get_all_gpio() )[1]->{type},  1, "Get second gpio type" );
is( ( $Backend->get_all_gpio() )[1]->{value}, 1, "Get second gpio value" );
is( scalar( $Backend->get_all_gpio ), 2, "Two GPIOs" );
is( ( $Backend->get_all_gpio_data() )[0]->{title},
    "serranda 1", "Get first gpio title (first tag)" );
is( ( $Backend->get_all_gpio_data() )[0]->{toggle},
    1, "Get first gpio toggle" );
is( ( $Backend->get_all_nodes() )[0]->{type},
    "master", "Get first node type" );
is( $Backend->delete_element( "Node", 42 ),
    0, "Deleting not exitent node ok" );



my $new_gpio = $Backend->add_gpio(
    {   'pin_id' => 22,
        'type'   => 1,
        'driver' => 'IntelliHome::Driver::GPIO::Mono'
    },
    { id => 1 }
);
my $new_room = $Backend->add_room(
        {   name     => "test",
            location => "bedroom first floor"
        }
        );
is( $new_gpio->value, 0, "Adding 1 gpio to first node" );
is( $new_room->name,
    "test",
    "Adding a room"
);

is( $Backend->add_tag( { tag => "test" }, { id => $new_gpio->gpioid } )->tag,
    "test",
    "Adding a tag to the previous created gpio"
);

is( $Backend->add_pin(
        {   pin   => 44,
            type  => 4,
            value => 0
        },
        { id => $new_gpio->gpioid }
        )->pin,
    44,
    "Adding a new pin to the previous created gpio"
);

is( $Backend->addNode(
        {   host=>"test",
            port=> 42,
            type=>"agent",
            name=>"Big tought",
            username=>"arthur",
            password=>"dent"
        },
        {name => $new_room->name, id=>$new_room->id }
        )->type,
    "agent",
    "Adding a new node to the previous created room"
);
is( $Backend->delete_element( "Node", $node_one->nodeid ),
    1, "Deleting Node 1 ok" );

###### TESTING BACKEND DB CONSISTENCY

#CLEANING
unlink("/tmp/intellihome.db");
remove_tree("/tmp/db_upgrades");
done_testing;
