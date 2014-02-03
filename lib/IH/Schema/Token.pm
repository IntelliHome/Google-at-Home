package IH::Schema::Token;
use Moose;
use namespace::autoclean;
use Mongoose::Class;
with 'Mongoose::Document' => {
    -collection_name => 'tokens',

    # -pk              => [qw/ title /]
};

has 'language' => ( is => "rw" );
has 'regex'    => ( is => "rw" );
has 'result'   => ( is => "rw" );

sub compile() {
    my $self  = shift;
    my $regex = shift;
    $self->result( $self->regex =~ /$regex/g );
    return $self;
}

sub satisfy() {

    my $self = shift;
    if ( scalar $self->result > 0 ) {
        return 1;
    }
    else {
        return 0;
    }

}

1;
