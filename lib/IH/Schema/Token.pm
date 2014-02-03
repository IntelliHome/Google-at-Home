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
has 'result'   => ( is => "rw", default => sub { [] } );
has 'content'  => ( is => "rw" );

sub compile() {
    my $self  = shift;
    my $hypo  = shift;
    my $regex = $self->regex;
    @{$self->{'result'}} = $hypo =~ /$regex/g;

    return $self;
}

sub compile_regex() {
    my $self  = shift;
    my $regex = shift;
    my $match = $self->content;
    push( @{ $self->{'result'} }, $_ ) while ( $match =~ m/$regex/g );
    return $self;

}

sub satisfy() {

    my $self = shift;
    if ( scalar @{ $self->{'result'} } > 0 ) {
        return 1;
    }
    else {
        return 0;
    }

}

1;
