package IntelliHome::Deployer::Schema::SQLite;

use strict;
use Carp::Always;
use warnings;
use 5.010;
use DBIx::Class::DeploymentHandler;
use lib '../../';
use IntelliHome::Schema::SQLite::Schema;
use File::Path qw(make_path remove_tree);
use Moo;
extends 'IntelliHome::Deployer::Schema::Base';

has 'dh' => (
    is      => "rw",
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $path
            = ( $self->Config->DBConfiguration->{'db_name'} =~ /(.*)\//g )[0];
        make_path $path unless -d $path;
        return DBIx::Class::DeploymentHandler->new(
            {   schema => IntelliHome::Schema::SQLite::Schema->connect(
                    'dbi:SQLite:'
                        . $self->Config->DBConfiguration->{'db_name'}
                ),
                script_directory => $path . '/db_upgrades',
                databases        => 'SQLite',
                force_overwrite  => 1,
                schema_version   => 1                       #TODO pass version
            }
        );
    }
);

sub prepare {
    my $self         = shift;
    my $from_version = shift;
    my $to_version   = shift;
    $self->Output->info(
        "Preparing db on " . $self->Config->DBConfiguration->{'db_name'} );
    $self->dh->prepare_install;
    if ( defined $from_version && defined $to_version ) {
        $self->dh->prepare_upgrade(
            {   from_version => $from_version,
                to_version   => $to_version,
            }
        );
    }
}

sub install {
    my $self    = shift;
    my $version = shift;
    $self->Output->info(
        "Installing db on " . $self->Config->DBConfiguration->{'db_name'} );
    if ( defined $version ) {
        $self->dh->install( { schema_version => $version } );
    }
    else {
        $self->dh->install;
    }
    $self->example_data;
}

sub upgrade {
    return shift->upgrade;
}

sub database_version {
    return shift->database_version;
}

sub schema_version {
    return shift->schema_version;
}

sub remove {
    my $self = shift;
    remove_tree(
        ( $self->Config->DBConfiguration->{'db_name'} =~ /(.*)\//g )[0]
            . "/db_upgrades" );
    unlink( $self->Config->DBConfiguration->{'db_name'} );
}

sub example_data {

    my $self   = shift;
    my $schema = $self->dh->schema;

    my $room_data = {
        'name'     => "bedroom",
        'location' => "bedroom first floor"
    };

    my $room = $schema->resultset('Room')->create($room_data);
    $schema->resultset('Room')->create(
        {   'name'     => "bedroom 2",
            'location' => "bedroom second floor"
        }
    );
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
        'tag'    => "shutter 1"
    };

    my $tag_data2 = {
        'gpioid' => $gpio_two->id,
        'tag'    => "shutter 2"
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

}

1;
__END__
=head1 NAME

IntelliHome::Deployer::Schema::SQLite - Prepare, install and upgrade the database for IntelliHome

=head1 SYNOPSIS

    $ sudo perl bin/intellihome-deployer -b SQLite -c prepare
    $ sudo perl bin/intellihome-deployer -b SQLite -c install

=head1 DESCRIPTION

IntelliHome::Deployer::Schema::SQLite is a module that handles the prepare/installation/upgrade phase for the SQLite database. The deployer can be invoked by command line using the C<intellihome-deployer> shipped bin. The argument C<-b SQLite> will address to this module while C<-c> will invoke it's methods.

=head1 ATTRIBUTES

It inherits all attributes from L<IntelliHome::Deployer::Schema::Base> and implement the new ones:

=over

=item dh()

Database handle

=back

=head1 FUNCTIONS

=over

=item prepare()

prepare the SQLite database specified in the configuration file

=item install()

install the SQLite database specified in the configuration file

=item upgrade()

upgrade the SQLite database version specified in the configuration file

=item version()

print the SQLite database version

=item remove()

remove the database

=back

=cut
