#!/usr/bin/perl

use strict;
use warnings;
use lib './lib';
use IntelliHome::Schema::SQLite::Schema;

my $schema = IntelliHome::Schema::SQLite::Schema->connect(
    'dbi:SQLite:/var/lib/intellihome/intellihome.db');

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
    'nodeid'   => $node_two->id,
    'pin_id' => 1,
    'type'     => 3,
    'value'    => 0,
    'driver'   => "IntelliHome::Driver::GPIO::Mono"
};

my $gpio_data2 = {
    'nodeid'   => $node_two->id,
    'pin_id' => 2,
    'type'     => 1,
    'value'    => 1,
    'driver'   => "IntelliHome::Driver::GPIO::Dual"
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


