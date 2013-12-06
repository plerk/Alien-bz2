package Alien::bz2;

use strict;
use warnings;
use base qw( Alien::Base );
use File::ShareDir qw( dist_dir );

# ABSTRACT: Build and make available libbz2
# VERSION

sub cflags { '-I' . dist_dir('Alien-bz2') . '/include'   }
sub libs   { '-L' . dist_dir('Alien-bz2') . '/lib -lbz2' }

# workaround for Alien::Base gh#30
sub import
{
  my $class = shift;
  
  if($class->install_type('share'))
  {
    unshift @DynaLoader::dl_library_path, 
      grep { s/^-L// } 
      shellwords( $class->libs );
  }
  
  $class->SUPER::import(@_);
}

1;
