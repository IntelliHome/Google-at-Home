package IntelliHome::Config;

#Handles configuration import
use YAML::Tiny;
use IntelliHome::Interfaces::Terminal;
use File::Find::Object;
use Moo;
with 'MooX::Singleton';

has 'Nodes'            => ( is => "rw" );
has 'RPCConfiguration' => ( is => "rw", default => sub { {} } );
has 'DBConfiguration'  => ( is => "rw", default => sub { {} } );

has 'Dirs' => ( is => "rw", default => sub { ['./config'] } );
has 'Output' => (
    is      => "rw",
    default => sub { return IntelliHome::Interfaces::Terminal->instance }
);

sub BUILD {
    my $self = shift;
    $self->read;
}

sub db {
    return $_[0]->DBConfiguration->{'db_dsn'}
        ? $_[0]->DBConfiguration->{'db_dsn'}
        : $_[0]->DBConfiguration->{'db_name'};
}

sub read {
    my $self   = shift;
    my $output = $self->Output;
    my $Tiny   = YAML::Tiny->new;
    $output->info("Scanning for configuration files");
    if ( $self->Dirs ) {
        my $tree = File::Find::Object->new( {}, @{ $self->Dirs } );
        my $Nodes;
        while ( my $r = $tree->next_obj() ) {
            next if $r->path !~ /\.yml$/;
            $output->debug( "Reading " . $r->path );
            if ( $r->is_file ) {
                my $yaml = $Tiny->read( $r->path )
                    or $output->error( "Error occourred reading "
                        . $r->path
                        . " YAML Syntax error?" );

            #Importing data in my hash with an index by host (for convenience)
                foreach my $Key ( @{$yaml} ) {

                    if (    exists( $Key->{database_backend} )
                        and exists( $Key->{language} )

                        #           and exists($Key->{username})
                        #               and exists ($Key->{password})

                        )
                    {
                        if (    exists( $Key->{db_dsn} )
                            and exists( $Key->{db_name} ) )
                        {
                            $self->DBConfiguration->{'db_dsn'}
                                = $Key->{'db_dsn'};
                            $output->info( "Database: "
                                    . $self->DBConfiguration->{'db_dsn'} );
                            $self->DBConfiguration->{'db_name'}
                                = $Key->{'db_name'};
                            $output->info( "Database: "
                                    . $self->DBConfiguration->{'db_name'} );
                        }
                        $self->DBConfiguration->{'database_backend'}
                            = $Key->{'database_backend'};
                        $output->info( "Database backend: "
                                . $self->DBConfiguration->{'database_backend'}
                        );
                        $self->DBConfiguration->{'language'}
                            = $Key->{'language'};
                        $output->info( "Database lang: "
                                . $self->DBConfiguration->{'language'} );

                    }

                    if (    exists( $Key->{host} )
                        and exists( $Key->{port} )

                        #           and exists($Key->{username})
                        #               and exists ($Key->{password})

                        )
                    {
                        $output->info(
                                  "*\t["
                                . $Key->{type} . "] "
                                . $Key->{host} . ":"
                                . $Key->{port}

                                #      . $Key->{username} . ":"
                                #      . $Key->{password},

                        );
                        if (    exists( $Key->{username} )
                            and exists( $Key->{password} )
                            and exists( $Key->{deployer} ) )
                        {
                            $output->info( "Node ["
                                    . $Key->{host}
                                    . "] can be deployed with "
                                    . $Key->{deployer} );
                            $Nodes->{ $Key->{host} }->{username}
                                = $Key->{username};
                            $Nodes->{ $Key->{host} }->{password}
                                = $Key->{password};
                            $Nodes->{ $Key->{host} }->{deployer}
                                = $Key->{deployer};

                        }
                        $Nodes->{ $Key->{host} }->{description}
                            = $Key->{description};

                        $Nodes->{ $Key->{host} }->{port} = $Key->{port};
                        $Nodes->{ $Key->{host} }->{type} = $Key->{type};
                        $Nodes->{ $Key->{host} }->{HW}   = $Key->{HW}
                            if ( exists( $Key->{HW} ) );
                        $Nodes->{ $Key->{host} }->{mic_lower_threshold}
                            = $Key->{mic_lower_threshold}
                            if ( exists( $Key->{mic_lower_threshold} ) );
                        $Nodes->{ $Key->{host} }->{mic_upper_threshold}
                            = $Key->{mic_upper_threshold}
                            if ( exists( $Key->{mic_upper_threshold} ) );
                        $Nodes->{ $Key->{host} }->{mic_capture_level}
                            = $Key->{mic_capture_level}
                            if ( exists( $Key->{mic_capture_level} ) );
                        $Nodes->{ $Key->{host} }->{mic_boost_level}
                            = $Key->{mic_boost_level}
                            if ( exists( $Key->{mic_boost_level} ) );
                        $Nodes->{ $Key->{host} }->{mic_step}
                            = $Key->{mic_step}
                            if ( exists( $Key->{mic_step} ) );
                    }

                    if (    exists( $Key->{rpc_host} )
                        and exists( $Key->{rpc_port} ) )
                    {
                        $self->RPCConfiguration->{'rpc_host'}
                            = $Key->{'rpc_host'};
                        $output->info( "RPC-Host: "
                                . $self->RPCConfiguration->{'rpc_host'} );
                        $self->RPCConfiguration->{'rpc_port'}
                            = $Key->{'rpc_port'};
                        $output->info( "RPC-Port: "
                                . $self->RPCConfiguration->{'rpc_port'} );
                    }
                }

            }
        }

        $self->Nodes($Nodes);
        return $Nodes;
    }
    else {
        $output->ERROR("Config dirs not defined");
        exit 1;
    }
}
1;
