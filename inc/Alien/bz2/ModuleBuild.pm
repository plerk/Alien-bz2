package Alien::bz2::ModuleBuild;

use strict;
use warnings;
use base qw( Alien::Base::ModuleBuild );
use File::Spec;

sub new
{
  my $class = shift;
  my %args = @_;

  $args{alien_repository}->{location} = File::Spec->catdir(qw( src win ))
    if $^O eq 'MSWin32';
  
  $class->SUPER::new(%args);
}

package
  main;

use Config;
use File::Which qw( which );
use File::Copy qw( copy );
use File::Spec;
use File::Path qw( mkpath );
use FindBin ();

my $make = which($Config{gmake}) || which($Config{make}) || 'make';
my $cp   = which($Config{cp});

sub _system
{
  print "% @_\n";
  system @_;
  die 'execute failed' if $?;
}

sub alien_build
{
  local $ENV{CC} = $Config{cc};
  local $ENV{AR} = $Config{ar};

  my $dir = shift @ARGV;

  if($^O eq 'MSWin32')
  {
    my $dir = File::Spec->catdir(File::Spec->updir, File::Spec->updir);
    print "% copy " . File::Spec->catfile($dir, 'Makefile-windll'), ' Makefile-windll', "\n";
    copy(File::Spec->catfile($dir, 'Makefile-windll'), 'Makefile-windll');
    _system $make, -f => 'Makefile-windll';
  }
  else
  {
    _system $make, -f => 'Makefile-libbz2_so';
    _system $make, 'all';
  }
}

sub alien_install
{
  local $ENV{CC} = $Config{cc};
  local $ENV{AR} = $Config{ar};

  my $dir = shift @ARGV;
  if($^O eq 'MSWin32')
  {
    mkdir "$dir/bin";
    mkdir "$dir/lib";
    mkdir "$dir/include";
    copy 'bz2.dll', "$dir\\bin";
    copy 'libbz2.a', "$dir\\lib";
    copy 'bzlib.h', "$dir\\include";
  }
  else
  {
    _system $make, 'install', "PREFIX=$dir";
    _system $cp, '-a', 'libbz2.so.1.0.6', 'libbz2.so.1.0', "$dir/lib";
  }
}

1;
