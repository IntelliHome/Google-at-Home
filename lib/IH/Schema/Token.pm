package IH::Schema::Token;
use Moose;
use namespace::autoclean;

has 'language' => ( is => "rw" );
has 'regex'    => ( is => "rw" );
has 'result'   => ( is => "rw" );
has 'hypo'     => ( is => "rw" );

sub compile() {
    my $self = shift;
    if ( $self->test ) {
        my @matches = ( $self->hypo =~ /$r/ );
        $self->result(@matches);
    }
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

sub test() {
    my $self=shift;
        my $r    = $self->regex();
    $self->hypo =~ /$r/i ? return 1 : return 0;
}

1;
