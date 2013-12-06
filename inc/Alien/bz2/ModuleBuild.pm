package Alien::bz2::ModuleBuild;

use strict;
use warnings;
use base qw( Alien::Base::ModuleBuild );

package
  main;

use Config;
use File::Which qw( which );

my $make = which($Config{gmake}) || which($Config{make}) || 'make';
my $cp   = which($Config{cp});

sub _system
{
  print "% @_";
  system @_;
  die 'execute failed' if $?;
}

sub alien_build
{
  _system $make, -f => 'Makefile-libbz2_so';
  _system $make;
}

sub alien_install
{
  my $dir = shift @ARGV;
  _system $make, 'install', "PREFIX=$dir";
  _system $cp, '-a', 'libbz2.so.1.0.6', 'libbz2.so.1.0', "$dir/lib";
}

1;
