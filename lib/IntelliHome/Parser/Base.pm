package IntelliHome::Parser::Base;
use Moo;
use Carp qw(croak);
use IntelliHome::Utils qw(load_module);
has 'Config'  => ( is => "rw" );
has 'Plugins' => ( is => "rw", default => sub { {} } );
has 'Output'  => ( is => "rw" );
has 'Backend' => ( is => "rw" );
has 'Node'    => ( is => "rw" );
has 'event' => (is=>"rw");

sub BUILD {
    my $self    = shift;
    my $Backend = "IntelliHome::Parser::DB::"
        . $self->Config->DBConfiguration->{'database_backend'};
    $self->Backend( $Backend->instance( Config => $self->Config ) )
        if ( load_module($Backend) );
}

sub detectTasks() {
    croak 'detectTasks() is not implemented by IntelliHome::Parser::Base';
}

sub detectTriggers() {
    croak 'detectTriggers() is not implemented by IntelliHome::Parser::Base';
}

sub parse() {
    croak 'parse() is not implemented by IntelliHome::Parser::Base';
}

sub prepare() {
    croak 'prepare() is not implemented by IntelliHome::Parser::Base';
}

sub run_plugin {
    my $self   = shift;
    my $name   = shift;
    my $method = shift;
    my @args   = @_;
    my $Plugin;
    if ( exists $self->Plugins->{$name} ) {
        $Plugin = $self->Plugins->{$name};
    }
    else {
        $Plugin = 'IntelliHome::Plugin::' . $name;
        if ( load_module($Plugin) == 0 ) {
            $self->Output->error("Error loading plugin '$name'");
            return 0;
        }
        else {
            $self->Plugins->{$name} = $Plugin->new(
                Config      => $self->Config,
                Parser      => $self,
                IntelliHome => $self
            );
            $self->Plugins->{$name}->prepare()
                if $self->Plugins->{$name}->can("prepare");
            $self->Plugins->{$name}
                ->language( $self->Config->DBConfiguration->{'language'} )
                if $self->Plugins->{$name}->can("language");
            $Plugin = $self->Plugins->{$name};
        }
    }
    return $Plugin->can($method) ? $Plugin->$method(@args) : undef;
}

sub node { shift->Backend->node; }

1;
