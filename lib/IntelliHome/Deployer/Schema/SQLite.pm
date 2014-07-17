package IntelliHome::Deployer::Schema::SQLite;

use strict;
use Carp::Always;
use warnings;
use 5.010;
use DBIx::Class::DeploymentHandler;
use lib '../../';
use IntelliHome::Schema::SQLite::Schema;
use File::Path qw(make_path);
use constant DBDIR => "/var/lib/intellihome/";
use Moo;

has 'dh' => (
    is      => "rw",
    lazy    => 1,
    default => sub {
        make_path DBDIR unless -d DBDIR;
        return DBIx::Class::DeploymentHandler->new(
            {   schema => IntelliHome::Schema::SQLite::Schema->connect(
                    'dbi:SQLite:' . DBDIR . 'intellihome.db'
                ),
                script_directory => DBDIR . 'db_upgrades',
                databases        => 'SQLite',
                force_overwrite  => 1,
                schema_version   => 1 #TODO pass version 
            }
        );
    }
);

sub prepare {
    my $self         = shift;
    my $from_version = shift;
    my $to_version   = shift;
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
    if ( defined $version ) {
        $self->dh->install( { schema_version => $version } );
    }
    else {
        $self->dh->install;
    }
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

1;