#!/usr/bin/env perl

use strict;
use Carp::Always;
use warnings;
use 5.010;
use DBIx::Class::DeploymentHandler;
use feature qw/ switch /;
use Getopt::Long;
use lib '../../../';
use IntelliHome::Schema::SQLite::Schema;
my $schema = IntelliHome::Schema::SQLite::Schema->connect('dbi:SQLite:intellihome.db');

my $cmd = '';
my $from_version;
my $to_version;
my $version;
GetOptions(
    'command|cmd|c=s' => \$cmd,
    'from-version=i'  => \$from_version,
    'to-version=i'    => \$to_version,
    'version=i'       => \$version,
);

sub usage {
    say <<'HERE';
usage:
  database.pl --cmd prepare [ --from-version $from --to-version $to ]
  database.pl --cmd install [ --version $version ]
  database.pl --cmd upgrade
  database.pl --cmd database-version
  database.pl --cmd schema-version
HERE
    exit(0);
}

#my $schema = '...'; # wherever you get your schema from.
my $deployment_handler_dir = './db_upgrades';

my $dh = DBIx::Class::DeploymentHandler->new(
    {   schema           => $schema,
        script_directory => $deployment_handler_dir,
        databases        => 'SQLite',
        force_overwrite  => 1,
	schema_version => $version
    }
);

#die "We only support positive integers for versions."
#    unless $version and $dh->schema_version =~ /^\d+$/;

for ($cmd) {
    when ('prepare')          { prepare() }
    when ('install')          { install() }
    when ('upgrade')          { upgrade() }
    when ('database-version') { database_version() }
    when ('schema-version')   { schema_version() }
    default                   { usage() }
}

sub prepare {
    say "running prepare_install()";
    $dh->prepare_install;

    if ( defined $from_version && defined $to_version ) {
        say
            "running prepare_upgrade({ from_version => $from_version, to_version => $to_version })";
        $dh->prepare_upgrade(
            {   from_version => $from_version,
                to_version   => $to_version,
            }
        );
    }
}

sub install {
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
