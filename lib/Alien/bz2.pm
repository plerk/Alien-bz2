package Alien::bz2;

use strict;
use warnings;
use base qw( Alien::Base );
use File::ShareDir qw( dist_dir );

# ABSTRACT: Build and make available libbz2
# VERSION

sub cflags { '-I' . dist_dir('Alien-bz2') . '/include'   }
sub libs   { '-L' . dist_dir('Alien-bz2') . '/lib -lbz2' }

1;
