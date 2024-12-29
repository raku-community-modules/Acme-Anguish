[![Actions Status](https://github.com/raku-community-modules/Acme-Anguish/actions/workflows/linux.yml/badge.svg)](https://github.com/raku-community-modules/Acme-Anguish/actions) [![Actions Status](https://github.com/raku-community-modules/Acme-Anguish/actions/workflows/macos.yml/badge.svg)](https://github.com/raku-community-modules/Acme-Anguish/actions) [![Actions Status](https://github.com/raku-community-modules/Acme-Anguish/actions/workflows/windows.yml/badge.svg)](https://github.com/raku-community-modules/Acme-Anguish/actions)

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

<table class="pod-table">
<tbody>
<tr> <td>&gt;</td> <td>[⁠]</td> <td>U+2060 WORD JOINER [Cf]</td> </tr> <tr> <td>&lt;</td> <td>[​]</td> <td>U+200B ZERO WIDTH SPACE [Cf]</td> </tr> <tr> <td>+</td> <td>[⁡]</td> <td>U+2061 FUNCTION APPLICATION [Cf]</td> </tr> <tr> <td>-</td> <td>[⁢]</td> <td>U+2062 INVISIBLE TIMES [Cf]</td> </tr> <tr> <td>.</td> <td>[⁣]</td> <td>U+2063 INVISIBLE SEPARATOR [Cf]</td> </tr> <tr> <td>,</td> <td>[﻿]</td> <td>U+FEFF ZERO WIDTH NO-BREAK SPACE [Cf]</td> </tr> <tr> <td>[</td> <td>[‌]</td> <td>U+200C ZERO WIDTH NON-JOINER [Cf]</td> </tr> <tr> <td>]</td> <td>[‍]</td> <td>U+200D ZERO WIDTH JOINER [Cf]</td> </tr>
</tbody>
</table>

All other characters are silently ignored.

The meaning of original Brainfuck characters are as follows:

<table class="pod-table">
<tbody>
<tr> <td>&gt;</td> <td>increment the data pointer (to point to the next cell to the right).</td> </tr> <tr> <td>&lt;</td> <td>decrement the data pointer (to point to the next cell to the left).</td> </tr> <tr> <td>+</td> <td>increment (increase by one) the byte at the data pointer.</td> </tr> <tr> <td>-</td> <td>decrement (decrease by one) the byte at the data pointer.</td> </tr> <tr> <td>.</td> <td>output the byte at the data pointer.</td> </tr> <tr> <td>,</td> <td>accept one byte of input, storing its value in the byte at the data pointer.</td> </tr> <tr> <td>[</td> <td>if the byte at the data pointer is zero, then instead of moving the instruction pointer forward to the next command, jump it forward to the command after the matching ] command.</td> </tr> <tr> <td>]</td> <td>if the byte at the data pointer is nonzero, then instead of moving the instruction pointer forward to the next command, jump it back to the command after the matching [ command.</td> </tr>
</tbody>
</table>

SUBROUTINES
===========

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

