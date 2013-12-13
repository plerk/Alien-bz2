use strict;
use warnings;
use Test::More tests => 1;
use Test::CChecker;
use Alien::bz2;

compile_with_alien 'Alien::bz2';

compile_output_to_note;

compile_run_ok do { local $/; <DATA> }, "basic compile test";

__DATA__

#include <bzlib.h>

int
main(int argc, char *argv[])
{
  printf("version = %s\n", BZ2_bzlibVersion());
  return 0;
}
