package Module::Build::IntelliHome;
use strict;
use warnings;
use Module::Build 0.35;
use base 'Module::Build';

sub new {
    my ( $class, %p ) = @_;
    my $self = $class->SUPER::new(%p);
    $self->add_build_element('mo');
    return $self;
}
1;
