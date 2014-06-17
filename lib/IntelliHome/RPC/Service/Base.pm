package IntelliHome::RPC::Service::Base;

use Carp::Always;
use Mojo::Base 'MojoX::JSON::RPC::Service';
has 'IntelliHome';

sub new {
    my $self = shift;
    $self = $self->SUPER::new(@_);
    $self->{'_rpcs'}->{ lc(( split( "::", ( $self =~ /(.*)\=/ )[0] ) )[-1]) }
        ->{'with_mojo_tx'} = 1;
    return $self;
}

1;

