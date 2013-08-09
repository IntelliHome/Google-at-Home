package IH::Config;

#Handles configuration import
use YAML::Tiny;
use Moose;
use IH::Interfaces::Terminal;
use Data::Dumper;
use File::Find::Object;

has 'Nodes' => ( is => "rw" );
has 'Dirs'  => ( is => "rw" );
has 'Output' =>
    ( is => "rw", default => sub { return new IH::Interfaces::Terminal } );

sub read() {
    my $self   = shift;
    my $output = $self->Output;
    my $Tiny   = YAML::Tiny->new;
    $output->info("Scanning for configuration files");
    if ( $self->Dirs ) {
        my $tree = File::Find::Object->new( {}, @{ $self->Dirs } );
        my $Nodes;
        while ( my $r = $tree->next_obj() ) {
            if ( $r->is_file ) {
                my $yaml = $Tiny->read( $r->path )
                    or $output->error( "Error occourred reading "
                        . $r->path
                        . " YAML Syntax error?" );

            #Importing data in my hash with an index by host (for convenience)
                foreach my $Key ( @{$yaml} ) {
                    if (    exists( $Key->{host} )
                        and exists( $Key->{port} )

                        #         	and exists($Key->{username})
                        #            	and exists ($Key->{password})

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
                            $Nodes->{ $Key->{host} }->{username} =
                                $Key->{username};
                            $Nodes->{ $Key->{host} }->{password} =
                                $Key->{password};
                            $Nodes->{ $Key->{host} }->{deployer} =
                                $Key->{deployer};

                        }
                        $Nodes->{ $Key->{host} }->{description} =
                            $Key->{description};

                        $Nodes->{ $Key->{host} }->{port} = $Key->{port};
                        $Nodes->{ $Key->{host} }->{type} = $Key->{type};

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
