# Alien::bz2

Build and make available libbz2

# SYNOPSIS

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

# DESCRIPTION

This distribution installs the bzip2 libraries and makes them available [Alien::Base](https://metacpan.org/pod/Alien::Base) style.

Unless you have specific need for this, you probably want [Compress::Bzip2](https://metacpan.org/pod/Compress::Bzip2).

# SEE ALSO

- [Compress::Bzip2](https://metacpan.org/pod/Compress::Bzip2)

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
