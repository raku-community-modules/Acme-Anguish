unit module Acme::Anguish;
use Term::termios;

sub anguish (Str:D $code) is export {
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

sub check-matching-loop ($code) {
    my $level = 0;
    for $code.NFC.map: *.chr {
        $level++ if $_ eq "\x200C";
        $level-- if $_ eq "\x200D";
        fail qq{Closing "\\x200D" found without matching "\\x200C"\n}
            if $level < 0;
        LAST { fail 'Unmatched \\x200C \\x200D' if $level > 0 }
    }
}
