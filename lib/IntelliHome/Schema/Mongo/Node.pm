package IntelliHome::Schema::Node;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with 'Mongoose::Document' => {
    -collection_name => 'nodes',
    -pk              => [qw/ Host /]
};

has 'Host'        => ( is => "rw" );
has 'Port'        => ( is => "rw" );
has 'username'    => ( is => "rw" );
has 'password'    => ( is => "rw" );
has 'description' => ( is => "rw" );
has 'type'        => ( is => "rw" );
has 'GPIO'        => (
    is      => 'rw',
    isa     => 'Mongoose::Join[IntelliHome::Schema::Mongo::GPIO]',
    default => sub {
        Mongoose::Join->new(
            with_class => 'IntelliHome::Schema::Mongo::GPIO' );
    }
);
has 'Config' => ( is => "rw" );

sub selectFromHost() {
    my $self = shift;
    my $host = shift;
    my $type = shift || "node";
    return $self->find_one( { Host => $self->Host, type => $type } );
}

1;
