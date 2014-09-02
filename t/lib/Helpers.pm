package Helpers;

use warnings;
use strict;
use base qw(Exporter);
use Mojo::Loader;
use File::Basename qw(fileparse);
use File::Spec::Functions qw(catdir catfile splitdir);
our @EXPORT_OK = qw(
    search_modules
);


sub search_modules($) {
    my $ns = shift;
    my %modules;
    for my $directory (@INC) {
        next unless -d ( my $path = catdir $directory, split( /::|'/, $ns ) );

        # List "*.pm" files in directory
        opendir( my $dir, $path );
        for my $file ( readdir $dir ) {
            next if $file eq '..' or $file eq '.';
            if ( -d catdir $path, $file ) {
                $modules{$_}++
                    for ( &search_modules("${ns}::${file}") )
                    ;    #making recursive
            }
            elsif ( $file =~ /\.pm/ ) {
                next if -d catfile splitdir($path), $file;
                $modules{ "${ns}::" . fileparse $file, qr/\.pm/ }++;
            }

        }
    }

    wantarray ? ( keys %modules ) : return [ keys %modules ];
}


1;
