use strict;
use warnings;
use Test::More tests => 1;
use Test::CChecker;
use Alien::bz2;
use Env qw( @LD_LIBRARY_PATH );

compile_with_alien 'Alien::bz2';

compile_output_to_note;

unshift @LD_LIBRARY_PATH, Alien::bz2->dist_dir;

my $ok = compile_run_ok do { local $/; <DATA> }, "basic compile test";

unless($ok)
{
  diag "LD_LIBRARY_PATH = $ENV{LD_LIBRARY_PATH}";
  foreach my $dir (@LD_LIBRARY_PATH)
  {
    diag "\n\ndir = $dir\n";
    if($^O eq 'MSWin32')
    { diag `dir $dir` }
    else
    { diag `ls -la $dir` }
  }
}

__DATA__

#include <bzlib.h>

int
main(int argc, char *argv[])
{
  printf("version = %s\n", BZ2_bzlibVersion());
  return 0;
}
