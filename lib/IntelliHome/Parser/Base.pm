package IntelliHome::Parser::Base;

=head1 NAME

IntelliHome::Parser::Base - Base class for IntelliHome parsers

=head1 DESCRIPTION

This object implement basic features for an IntelliHome parser, it's job is to dispatch the text trigger to the appropriate plugin. At build time it dynamically load the appropriate backend instance according to the value that was set in the configuration file.

=head1 METHODS

IntelliHome::Parser::Base implements run_plugin() and node(), but require the implementation of detectTasks(), detectTriggers(), parse(), prepare().

=over

=item run_plugin($name,$method,@attrs)

Run the plugin C<$name>  invoking the C<$method>  method with C<@attrs>  argument.
The plugin name must be in the relative form (e.g. "Relay")

=item node()

returns a new node object with an injected backend

=back

=head1 ATTRIBUTES

=over

=item Config

Give access to the loaded L<IntelliHome::Config>

=item Plugins

Contains an HashRef of plugins instantiations where the keys represent the relative name of a plugin (e.g. "Relay")

=item event

Contains the L<Deeme>  event emitter instance used internally by plugins

=item Output

Contains the output interface, see L<IntelliHome::Interfaces::Interface>,L<IntelliHome::Interfaces::Terminal>, L<IntelliHome::Interfaces::Voice>

=item Backend

Contains the loaded database backend specified in the configuration file

=back

=head1 SEE ALSO

L<IntelliHome::Parser::Mongo>, L<IntelliHome::Parser::SQLite>

=cut


use Moo;
use Carp qw(croak);
use IntelliHome::Utils qw(load_module);
use IntelliHome::EventEmitter;
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
