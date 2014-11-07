package IntelliHome::Parser::DB::Base;
use Moo;
use Carp qw(croak);
with("MooX::Singleton");
use IntelliHome::Utils qw(load_module);

has 'Config' => (
    is      => "rw",
    default => sub { IntelliHome::Config->instance( Dirs => ['./config'] ) }
);

sub installPlugin {
    my $self = shift;
    my $plugin = ( split( /::/, caller ) )[-1];
    if ( $self->can("installTrigger") ) {
        $_->{'plugin'} = $plugin and shift->installTrigger($_) for @_;
    }
    else {
        croak
            'installPlugin()/installTrigger() is not implemented by IntelliHome::Parser::DB::Base';
    }
}

sub removePlugin {
    croak
        'removePlugin() is not implemented by IntelliHome::Parser::DB::Base';
}

sub updatePlugin {
    croak
        'updatePlugin() is not implemented by IntelliHome::Parser::DB::Base';
}

sub node {
    my $self = shift;
    my $node
        = "IntelliHome::Schema::"
        . $self->Config->DBConfiguration->{'database_backend'}
        . "::Node";
    return $node->new( Config => $self->Config ) if ( load_module($node) );
}

1;
