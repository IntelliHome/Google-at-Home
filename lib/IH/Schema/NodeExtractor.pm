package IH::Schema::NodeExtractor;
use Moose;
use namespace::autoclean;

with qw(
    Search::GIN::Extract
    Search::GIN::Keys::Deep
);
has 'Class' => (is=>"rw");

sub extract_values {
    my ( $self, $obj, @args ) = @_;
    ref $obj eq $self->Class or return; #if it's the class specified in the attribute go




    # my $set = $obj->members || return; # get the  KiokuDB::Set in the Class attribute
    # my @prefs
    #     = scalar $set->members > 0 # check if there are
    #     ? map { $_->music_prefs } $set->members #map in @prefs only the values of the obj set
    #     : ();
    #\@prefs


    $self->process_keys( { Host => $obj->Host } ); #process the keys thru the given set
}
1;