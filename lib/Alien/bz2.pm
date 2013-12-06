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

=head1 BUNDLED SOFTWARE

 This distribution comes with bzip2, by Julian Seward with the
 following license:
 
 This program, "bzip2", the associated library "libbzip2", and all
 documentation, are copyright (C) 1996-2010 Julian R Seward.  All
 rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 
 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 
 2. The origin of this software must not be misrepresented; you must 
    not claim that you wrote the original software.  If you use this 
    software in a product, an acknowledgment in the product 
    documentation would be appreciated but is not required.
 
 3. Altered source versions must be plainly marked as such, and must
    not be misrepresented as being the original software.
 
 4. The name of the author may not be used to endorse or promote 
    products derived from this software without specific prior written 
    permission.
 
 THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
 OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Julian Seward, jseward@bzip.org
 bzip2/libbzip2 version 1.0.6 of 6 September 2010

=head1 SEE ALSO

=over 4

=item L<Compress::Bzip2>

=back

=cut
