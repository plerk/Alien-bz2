package Alien::bz2;

use strict;
use warnings;
use base qw( Alien::Base );
use Text::ParseWords qw( shellwords );
use File::ShareDir qw( dist_dir );
use File::Spec;

# ABSTRACT: Build and make available libbz2
# VERSION

=head1 SYNOPSIS

Build.PL

 use Alien::bz2;
 use Module::Build;
 
 my $alien = Alien::bz2->new;
 my $build = Module::Build->new(
   ...
   extra_compiler_flags => $alien->cflags,
   extra_linker_flags   => $alien->libs,
   ...
 );
 
 $build->create_build_script

Makefile.PL

 use Alien::bz2
 use ExtUtils::MakeMaker;
 
 my $alien = Alien::bz2->new;
 WriteMakefile(
   ...
   CFLAGS => Alien::bz2->cflags,
   LIBS   => Alien::bz2->libs,
 );

FFI

 use Alien::bz2;
 use FFI::Sweet qw( ffi_lib );
 
 ffi_lib(Alien::bz2->new->libs);

=head1 DESCRIPTION

This distribution installs the bzip2 libraries and makes them available L<Alien::Base> style.

Unless you have specific need for this, you probably want L<Compress::Bzip2>.

=head1 SEE ALSO

=over 4

=item L<Compress::Bzip2>

=back

=cut

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
