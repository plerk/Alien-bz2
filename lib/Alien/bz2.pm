package Alien::bz2;

use strict;
use warnings;
use base qw( Alien::Base );
use File::ShareDir qw( dist_dir );
use File::Spec;

# ABSTRACT: Build and make available libbz2
# VERSION

sub cflags   { '-I' . File::Spec->catdir(dist_dir('Alien-bz2'), 'include')        }
sub libs     { '-L' . File::Spec->catdir(dist_dir('Alien-bz2'), 'lib') . ' -lbz2' }
sub dll_path { File::Spec->catfile(dist_dir('Alien-bz2'), qw( bin bz2.dll ))      }

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
  
  if($^O eq 'MSWin32')
  {
    $ENV{PATH} = dist_dir("Alien-bz2") . "\\bin;$ENV{PATH}";
  }
  
  $class->SUPER::import(@_);
}

1;
