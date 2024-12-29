use Term::termios;

my sub anguish(Str:D $code) is export {
    check-matching-loop $code;
    my $saved-term;
    try {
        $saved-term = Term::termios.new(:1fd).getattr;
        given Term::termios.new(:1fd).getattr {
            .makeraw;
            .setattr(:DRAIN);
        }
    };
    LEAVE { try $saved-term.setattr(:DRAIN) }

    my @code    = $code.NFC.map(*.chr).grep:
                    * eq "\x2062"|"\x200B"|"\x2060"
                        |"\x2061"|"\x2063"|"\xFEFF"|"\x200C"|"\x200D";
    my $ꜛ       = 0;
    my $cursor  = 0;
    my $stack   = Buf[uint8].new: 0;
    loop {
        given @code[$cursor] {
            when "\x2060" { $stack.append: 0 if $stack.elems == ++$ꜛ;       }
            when "\x200B" { $ꜛ--; fail "Negative cell pointer\n" if $ꜛ < 0; }
            when "\x2061" { $stack[$ꜛ]++;               }
            when "\x2062" { $stack[$ꜛ]--;               }
            when "\x2063" { $stack[$ꜛ].chr.print;       }
            when "\xFEFF" { $stack[$ꜛ] = $*IN.getc.ord; }
            when "\x200C" {
                $cursor++; next if $stack[$ꜛ];
                loop {
                    state $level = 1;
                    $level++ if @code[$cursor] eq "\x200C";
                    $level-- if @code[$cursor] eq "\x200D";
                    last unless $level;
                    $cursor++;
                }
            }
            when "\x200D" {
                unless $stack[$ꜛ] { $cursor++; next; }
                loop {
                    state $level = 1;
                    $cursor--;
                    $level-- if @code[$cursor] eq "\x200C";
                    $level++ if @code[$cursor] eq "\x200D";
                    last unless $level;
                }
            }
        }
        last if ++$cursor > @code.elems;
    }
}

my sub check-matching-loop($code) {
    my $level = 0;
    for $code.NFC.map: *.chr {
        $level++ if $_ eq "\x200C";
        $level-- if $_ eq "\x200D";
        fail qq{Closing "\\x200D" found without matching "\\x200C"\n}
            if $level < 0;
        LAST { fail 'Unmatched \\x200C \\x200D' if $level > 0 }
    }
}

=begin pod

=head1 NAME

Acme::Anguish - Use Anguish programming language in your Raku programs

=head1 SYNOPSIS

=begin code :lang<raku>

use Acme::Anguish;

anguish "\x2061" x 72 ~ "\x2063"; # prints "H"

=end code

=head1 DESCRIPTION

I<Anguish> is a L<Brainfuck|https://en.wikipedia.org/wiki/Brainfuck>
variant that uses invisible Unicode characters instead of traditional
Brainfuck's ones.

Here's the mapping of Brainfuck operators to *Anguish*:

=begin table
> |  [⁠] | U+2060 WORD JOINER [Cf]
< |  [​] | U+200B ZERO WIDTH SPACE [Cf]
+ |  [⁡] | U+2061 FUNCTION APPLICATION [Cf]
- |  [⁢] | U+2062 INVISIBLE TIMES [Cf]
. |  [⁣] | U+2063 INVISIBLE SEPARATOR [Cf]
, |  [﻿] | U+FEFF ZERO WIDTH NO-BREAK SPACE [Cf]
[ |  [‌] | U+200C ZERO WIDTH NON-JOINER [Cf]
] |  [‍] | U+200D ZERO WIDTH JOINER [Cf]
=end table

All other characters are silently ignored.

The meaning of original Brainfuck characters are as follows:

=begin table
> | increment the data pointer (to point to the next cell to the right).
< | decrement the data pointer (to point to the next cell to the left).
+ | increment (increase by one) the byte at the data pointer.
- | decrement (decrease by one) the byte at the data pointer.
. | output the byte at the data pointer.
, | accept one byte of input, storing its value in the byte at the data pointer.
[ | if the byte at the data pointer is zero, then instead of moving the instruction pointer forward to the next command, jump it forward to the command after the matching ] command.
] | if the byte at the data pointer is nonzero, then instead of moving the instruction pointer forward to the next command, jump it back to the command after the matching [ command.
=end table

=head1 SUBROUTINES

=head2 anguish

Takes a single positional argument: string of I<Anguish> code to evaluate.

=head1 EXAMPLES

See C<examples> directory of this distribution for example I<Anguish>
programs.

=head1 BUGS AND CAVEATS

The C<U-FEFF> character also serves as a file
L<BOM|https://en.wikipedia.org/wiki/Byte_order_mark>, so avoid using it
as the first character in your file.

=head1 AUTHOR

Zoffix Znet

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Zoffix Znet

Copyright 2018 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
