package IH::Workers::Base;
use Moo;

=head1 NAME

IH::Workers::Base - Processes the voice hypothesis thru a defined parser

=head1 DESCRIPTION

This Object implement process() that is called by the master node to parse and process the given command


=head1 ARGUMENTS

=over
=item Config()
Get/Set the IH::Config object that has all the loaded configurations (required)
=item Output()
Get/Set the answer output interface (default to IH::Interfaces::Voice)


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
        return IH::Interfaces::Voice->new;
    }
);

sub process() { }

1;
