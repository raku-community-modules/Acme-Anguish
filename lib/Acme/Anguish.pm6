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

    my @code    = $code.comb:
        /<[\x2060\x200B\x2061\x2062\x2063\xFEFF\x200B\x200C]>/;
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
            when "\x200B" {
                $cursor++; next if $stack[$ꜛ];
                loop {
                    state $level = 1;
                    $level++ if @code[$cursor] eq "\x200B";
                    $level-- if @code[$cursor] eq "\x200C";
                    last unless $level;
                    $cursor++;
                }
            }
            when "\x200C" {
                unless $stack[$ꜛ] { $cursor++; next }
                loop {
                    state $level = 1;
                    $cursor--;
                    $level-- if @code[$cursor] eq "\x200B";
                    $level++ if @code[$cursor] eq "\x200C";
                    last unless $level;
                }
            }
        }
        last if ++$cursor > @code.elems;
    }
}

sub check-matching-loop ($code) {
    my $level = 0;
    for $code.comb {
        $level++ if $_ eq "\x200B";
        $level-- if $_ eq "\x200C";
        fail qq{Closing "\\x200C" found without matching "\\x200B"\n}
            if $level < 0;
        LAST { fail 'Unmatched \\x200B \\x200C' if $level > 0 }
    }
}
