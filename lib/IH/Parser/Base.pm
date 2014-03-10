package IH::Parser::Base;
use Moose;
has 'Config' => ( is => "rw" );
has 'Plugins' => ( is => "rw", default => sub{{}} );

sub detectTasks() {

}

sub detectTriggers() {

}

sub parse() {

}

sub prepare() {

}

sub run_plugin() {
    my $self = shift;
    my $name = shift;
    my @args = @_;
    my $Plugin;
    if ( exists $self->Plugins->{$name} ) {
        $Plugin = $self->Plugins->{$name};
    }
    else {
        $Plugin = 'IH::Plugin::' . $name;
        load $Plugin;
        $self->Plugins->{$name}
            = $Plugin->new( Config => $self->Config, Parser => $self );
        $self->Plugins->{$name}->prepare();
        $Plugin = $self->Plugins->{$name};
    }
    $Plugin->run(@args);
}

1;
