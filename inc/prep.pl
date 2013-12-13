#!/usr/bin/perl

use strict;
use warnings;
use autodie qw( :all );
use Path::Class qw( dir );
use File::Temp qw( tempdir );

my $root = dir()->absolute;

$root->subdir('src', $_)->mkpath(0, 0755) for qw( unix win );

chdir "src/unix";

system 'wget', 'http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz' unless -e 'bzip2-1.0.6.tar.gz';

exit if $root->subdir('src', 'win')->children > 0;

my $tmp = dir( tempdir( CLEANUP => 1 ) );

system "wget -O- http://gnuwin32.sourceforge.net/downlinks/bzip2-src-zip.php | ( cd $tmp ; bsdtar xf - )";

$tmp = $tmp->subdir('src', 'bzip2');
$tmp = ($tmp->children)[0];

chdir $tmp;

my $basename = ($tmp->children)[0]->basename;

system 'bsdtar', 'zcvf', $root->subdir('src', 'win') . "/" . $basename . '.tar.gz', $basename;

chdir "/";
