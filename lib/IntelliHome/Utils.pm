package IntelliHome::Utils;

use warnings;
use strict;
use base qw(Exporter);

use constant SEPARATOR => ":";
our @EXPORT_OK = qw(
	message_expand SEPARATOR message_compact
	);
sub message_expand{
	my $message=shift;
	split(SEPARATOR,$message);
}

sub message_compact{
	my @message=@_;
	join(SEPARATOR,@message);
}

1;