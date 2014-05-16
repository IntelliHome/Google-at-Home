package IntelliHome::Schema::Mongo::Token;
use Moose;
use namespace::autoclean;
use Mongoose::Class;

## Token it's an identification for a trigger(or other) that is needed by plugins and stuff to be run
## triggers can have needs(arguments) to be satisfied(in the same way of the tokens) before launching the plugin
with 'Mongoose::Document' => {
    -collection_name => 'tokens',

    #-pk              => [qw/ regex /]
};

has 'language' => ( is => "rw" );
has 'regex'    => ( is => "rw" );
has 'result'   => ( is => "rw", default => sub { [] } );
has 'content'  => ( is => "rw" );

sub compile {
    my $self  = shift;
    my $hypo  = shift;
    my $regex = $self->regex;
    @{ $self->{'result'} } = $hypo =~ /$regex/gi;
    return $self;
}

sub compile_regex {
    my $self  = shift;
    my $regex = shift;
    my $match = $self->content;
    push( @{ $self->{'result'} }, $_ )
        while ( $match =~ m/$regex/gi );    #it's the opposite
    return $self;
}

sub satisfy {
    return ( scalar @{ shift->{'result'} } > 0 ) ? 1 : 0;
}

1;
