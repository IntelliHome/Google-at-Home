package IntelliHome::Workers::Base;
use Moo;

=head1 NAME

IntelliHome::Workers::Base - Base class for workers, Processes the voice hypothesis thru a defined parser

=head1 DESCRIPTION

This Object implement process() that is called by the master node to parse and process the given command

=head1 ATTRIBUTES

=over

=item Config()

Get/Set the IntelliHome::Config object that has all the loaded configurations (required)

=item Output()

Get/Set the answer output interface (default to IntelliHome::Interfaces::Voice)

=back

=head1 IMPLEMENTS

=over

=item process()

Process the worker request

=back

=cut

has 'Config' => ( is => "rw" );
has 'Output' => (
    is      => "rw",
    default => sub {
        return IntelliHome::Interfaces::Voice->new;
    }
);

sub process() { }

1;
