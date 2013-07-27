package IH::DB;
use Moose;
 
extends qw(KiokuX::Model);
 
sub add_user {
        my ( $self, @args ) = @_;
 
    #    my $user = MyApp::User->new(@args);
 
        $self->txn_do(sub {
       #         $self->insert($user);
        });
 
   #     return $user;
}
