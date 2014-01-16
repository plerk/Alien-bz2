package Alien::bz2;

use strict;
use warnings;
use 5.008009;
use base qw( Alien::Base );
use Text::ParseWords qw( shellwords );
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
It will use the system version of libbz2 if found.  You can force it to build libbz2 from
source by setting the environment variable C<ALIEN_BZ2> to C<share> when you install this
module.

Unless you have specific need for this, you probably are more interested in one of these:

=over 4

=item L<Compress::Bzip2>

=item L<Compress::Raw::Bzip2>

=item L<IO::Compress::Bzip2>

=back

=head1 CAVEATS

Does not seem to work with 64bit Strawberry Perl on Windows.  This is because we borrow the
sources from GnuWin32, which appear to be hand crafted to build 32bit binaries.

=cut

sub _dir
{
  my($class, $flag, $dir) = @_;
  return () if $class->install_type('system');
  if($class->config('finished_installing'))
  { $dir = File::Spec->catdir($class->dist_dir, $dir) }
  else
  { $dir = File::Spec->catdir($class->dist_dir) }
  $dir =~ s/\\/\//g if $^O eq 'MSWin32';
  ("$flag$dir");
}

sub cflags { join ' ', _dir(shift, -I => 'include')          }
sub libs   { join ' ', _dir(shift, -L => 'lib'),    ' -lbz2' }

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
  
  # TODO: this puts bzip2 executables in the PATH on just Windows,
  # which is undesirable.  Better to have a dll directory and
  # copy the dlls there during the install process
  $ENV{PATH} = $class->dist_dir . "\\bin;$ENV{PATH}" if $^O eq 'MSWin32';
  $ENV{PATH} = $class->dist_dir . "/bin:$ENV{PATH}"  if $^O eq 'cygwin';
  
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
