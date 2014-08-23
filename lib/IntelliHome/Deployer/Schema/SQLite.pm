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
