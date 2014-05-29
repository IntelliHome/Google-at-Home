package IntelliHome::RPC::Service::Dummy;

#this is a dummy rpc module only for testing

use Mojo::Base 'MojoX::JSON::RPC::Service';

sub dummy {
    my ( $self, @params ) = @_;
    return "DUMMY-YUMMY! ".join("\s",@params); #giving back params
}

__PACKAGE__->register_rpc_method_names('dummy');

1;
