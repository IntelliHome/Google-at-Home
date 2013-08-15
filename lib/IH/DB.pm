package IH::DB;
use Moose;
use IH::Schema::NodeExtractor;
extends qw(KiokuX::Model);
has '+extra_args' => (
    default => sub {
        {   extract =>
                IH::Schema::NodeExtractor->new( Class => "IH::Schema::Task" ),

            # ...
        };
    },
);

sub add_user {
    my ( $self, @args ) = @_;

    #    my $user = MyApp::User->new(@args);

    $self->txn_do(
        sub {
            #         $self->insert($user);
        }
    );

    #     return $user;
}

sub class_search() {
    my ( $self, $Class ) = @_;

    # create query
    my $query = Search::GIN::Query::Class->new( class => $Class );

    # get results
    return $self->search($query);
}
1;