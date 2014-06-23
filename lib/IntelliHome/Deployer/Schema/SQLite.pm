package IntelliHome::Deployer::Schema::SQLite;

use strict;
use Carp::Always;
use warnings;
use 5.010;
use DBIx::Class::DeploymentHandler;
use lib '../../';
use IntelliHome::Schema::SQLite::Schema;
my $schema = IntelliHome::Schema::SQLite::Schema->connect('dbi:SQLite:/var/lib/intellihome/intellihome.db');



#my $schema = '...'; # wherever you get your schema from.
my $deployment_handler_dir = '/var/lib/intellihome/db_upgrades';

my $dh = DBIx::Class::DeploymentHandler->new(
    {   schema           => $schema,
        script_directory => $deployment_handler_dir,
        databases        => 'SQLite',
        force_overwrite  => 1,
	    schema_version => $version
    }
);


sub prepare {
    my $from_version = shift;
    my $to_version = shift;
    $dh->prepare_install;

    if ( defined $from_version && defined $to_version ) {
        $dh->prepare_upgrade(
            {   from_version => $from_version,
                to_version   => $to_version,
            }
        );
    }
}

sub install {
    my $version = shift;
    $dh->prepare_install;
    if ( defined $version ) {
        $dh->install({ schema_version => $version });
    }
    else {
        $dh->install;
    }
}

sub upgrade {
    $dh->upgrade;
}

sub database_version {
    say $dh->database_version;
}

sub schema_version {
    say $dh->schema_version;
}
