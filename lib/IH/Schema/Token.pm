package IH::Schema::Token;
use Moose;
use namespace::autoclean;

has 'language' => ( is => "rw" );
has 'regex'    => ( is => "rw" );
has 'result'   => ( is => "rw" );
has 'hypo'     => ( is => "rw" );

sub compile() {
    my $self = shift;
    my $r    = $self->regex();
    if ( $self->hypo =~ /$r/i ) {
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
