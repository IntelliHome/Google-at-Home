#!/usr/bin/env perl

use warnings FATAL => 'all';
use strict;
use IntelliHome::Utils qw(search_modulesd);

use Test::More;

BEGIN {
	use_ok( $_ ) or BAIL_OUT("$_ failed") for search_modulesd("IntelliHome");
}

done_testing();
