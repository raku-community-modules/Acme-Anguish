[![Actions Status](https://github.com/raku-community-modules/Acme-Anguish/actions/workflows/test.yml/badge.svg)](https://github.com/raku-community-modules/Acme-Anguish/actions)

NAME
====

Acme::Anguish - Use Anguish programming language in your Raku programs

SYNOPSIS
========

```raku
use Acme::Anguish;

anguish "\x2061" x 72 ~ "\x2063"; # prints "H"
```

DESCRIPTION
===========

*Anguish* is a [Brainfuck](https://en.wikipedia.org/wiki/Brainfuck) variant that uses invisible Unicode characters instead of traditional Brainfuck's ones.

Here's the mapping of Brainfuck operators to *Anguish*:

    >   [⁠] U+2060 WORD JOINER [Cf]
    <   [​] U+200B ZERO WIDTH SPACE [Cf]
    +   [⁡] U+2061 FUNCTION APPLICATION [Cf]
    -   [⁢] U+2062 INVISIBLE TIMES [Cf]
    .   [⁣] U+2063 INVISIBLE SEPARATOR [Cf]
    ,   [﻿] U+FEFF ZERO WIDTH NO-BREAK SPACE [Cf]
    [   [‌] U+200C ZERO WIDTH NON-JOINER [Cf]
    ]   [‍] U+200D ZERO WIDTH JOINER [Cf]

All other characters are silently ignored.

The meaning of original Brainfuck characters are as follows:

    >   increment the data pointer (to point to the next cell to the right).
    <   decrement the data pointer (to point to the next cell to the left).
    +   increment (increase by one) the byte at the data pointer.
    -   decrement (decrease by one) the byte at the data pointer.
    .   output the byte at the data pointer.
    ,   accept one byte of input, storing its value in the byte at the
        data pointer.
    [   if the byte at the data pointer is zero, then instead of moving
        the instruction pointer forward to the next command, jump it
        forward to the command after the matching ] command.
    ]   if the byte at the data pointer is nonzero, then instead of moving
        the instruction pointer forward to the next command, jump it back
        to the command after the matching [ command.

EXPORTED SUBROUTINES
====================

anguish
-------

Takes a single positional argument: string of *Anguish* code to evaluate.

EXAMPLES
========

See `examples` directory of this distribution for example *Anguish* programs.

BUGS AND CAVEATS
================

The `U-FEFF` character also serves as a file [BOM](https://en.wikipedia.org/wiki/Byte_order_mark), so avoid using it as the first character in your file.

AUTHOR
======

Zoffix Znet

COPYRIGHT AND LICENSE
=====================

Copyright 2017 Zoffix Znet

Copyright 2018 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

