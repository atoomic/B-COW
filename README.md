# NAME

B::COW - B::COW additional B helpers to check COW status

# VERSION

version 0.007

# SYNOPSIS

```perl
#!perl

use strict;
use warnings;

use Test::More;    # just used for illustration purpose

use B::COW qw{:all};

if ( can_cow() ) {    # $] >= 5.020
    ok !is_cow(undef);

    my $str = "abcdef";
    ok is_cow($str);
    is cowrefcnt($str), 1;

    my @a;
    push @a, $str for 1 .. 100;

    ok is_cow($str);
    ok is_cow( $a[0] );
    ok is_cow( $a[99] );
    is cowrefcnt($str), 101;
    is cowrefcnt( $a[-1] ), 101;

    delete $a[99];
    is cowrefcnt($str), 100;
    is cowrefcnt( $a[-1] ), 100;

    {
        my %h = ( 'a' .. 'd' );
        foreach my $k ( sort keys %h ) {
            ok is_cow($k);
            is cowrefcnt($k), 0;
        }
    }

}
else {
    my $str = "abcdef";
    is is_cow($str),    undef;
    is cowrefcnt($str), undef;
    is cowrefcnt_max(), undef;
}

done_testing;
```

# DESCRIPTION

B::COW provides some naive additional B helpers to check the COW status of one SvPV.

## COW or Copy On Write introduction

A COWed SvPV is sharing its string (the PV) with other SvPVs.
It's a (kind of) Read Only C string, that would be Copied On Write (COW).

More than one SV can share the same PV, but when one PV need to alter it,
it would perform a copy of it, decrease the COWREFCNT counter.

One SV can then drop the COW flag when it's the only one holding a pointer
to the PV.

The COWREFCNT is stored at the end of the PV, after the the "\\0".

That value is limited to 255, when we reach 255, a new PV would be created,

[![](https://github.com/atoomic/B-COW/workflows/linux/badge.svg)](https://github.com/atoomic/B-COW/actions) [![](https://github.com/atoomic/B-COW/workflows/macos/badge.svg)](https://github.com/atoomic/B-COW/actions) [![](https://github.com/atoomic/B-COW/workflows/windows/badge.svg)](https://github.com/atoomic/B-COW/actions)

# FUNCTIONS

## can\_cow()

Return a boolean value. True if your Perl version support Copy On Write for SvPVs

## is\_cow( PV )

Return a boolean value. True if the SV is cowed SvPV. (check the SV FLAGS)

## cowrefcnt( PV )

Return one integer representing the COW RefCount value.
If the string is not COW, then it will return undef.

## cowrefcnt\_max()

Will return the SV\_COW\_REFCNT\_MAX of your Perl. (if COW is supported, this should
be 255 unless customized).

# AUTHOR

Nicolas R. <atoomic@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2018 by Nicolas R.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
