package Alien::bz2::ModuleBuild;

use strict;
use warnings;
use base qw( Alien::Base::ModuleBuild );
use File::Spec;
use File::Path qw( mkpath );
use File::Spec qw( copy );

sub new
{
  my $class = shift;
  my %args = @_;

  $args{alien_repository}->{location} = File::Spec->catdir(qw( src win ))
    if $^O eq 'MSWin32';

  if($^O eq 'MSWin32')
  {
    $args{requires}->{$_} = 0 for qw( Alien::MSYS Alien::o2dll );
  }
  
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
    do {
      open my $fh, '<', 'Makefile';
      my $makefile = do { local $/; <$fh> }; 
      close $fh;
      
      $makefile =~ s/\to2dll/\tpo2dll/g;
      
      open $fh, '>', 'Makefile';
      print $fh $makefile;
      close $fh;
    };
    
    eval q{ require Alien::MSYS };
    die $@ if $@;
    Alien::MSYS::msys(sub {
      _system 'make', 'all';
    });
    unlink 'libbz2.a';
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
    eval q{ require Alien::MSYS };
    die $@ if $@;
    Alien::MSYS::msys(sub {
      print "dir = $dir\n";
      $dir =~ s/\\/\//g;
      print "dir = $dir\n";
      print "% make install PREFIX=$dir\n";
      _system 'make', 'install', "PREFIX=$dir";
      unlink(File::Spec->catfile($dir, 'lib', 'libbz2.a'));
      copy('libbz2.dll.a', File::Spec->catfile($dir, 'lib', 'libbz2.dll.a'));
    });
  }
  else
  {
    _system $make, 'install', "PREFIX=$dir";
    _system $cp, '-a', 'libbz2.so.1.0.6', 'libbz2.so.1.0', "$dir/lib";
  }
}

1;
