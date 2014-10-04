#!/usr/bin/env perl
use lib './t/lib';
use warnings FATAL => 'all';
use strict;
use Helpers qw(search_modules);

use Test::More;

BEGIN {
	use_ok( $_ ) or BAIL_OUT("$_ failed") for search_modules("IntelliHome");
}

done_testing();
