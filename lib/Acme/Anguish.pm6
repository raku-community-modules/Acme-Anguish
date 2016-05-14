unit module Inline::Brainfuck:ver<1.001001>;
use Term::termios;

sub brainfuck (Str:D $code) is export {
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

    my @code    = $code.comb: /<[-<\>+.,[\]]>/;
    my $ꜛ       = 0;
    my $cursor  = 0;
    my $stack   = Buf[uint8].new: 0;
    loop {
        given @code[$cursor] {
            when '>' { $stack.append: 0 if $stack.elems == ++$ꜛ;       }
            when '<' { $ꜛ--; fail "Negative cell pointer\n" if $ꜛ < 0; }
            when '+' { $stack[$ꜛ]++;               }
            when '-' { $stack[$ꜛ]--;               }
            when '.' { $stack[$ꜛ].chr.print;       }
            when ',' { $stack[$ꜛ] = $*IN.getc.ord; }
            when '[' {
                $cursor++; next if $stack[$ꜛ];
                loop {
                    state $level = 1;
                    $level++ if @code[$cursor] eq '[';
                    $level-- if @code[$cursor] eq ']';
                    last unless $level;
                    $cursor++;
                }
            }
            when ']' {
                unless $stack[$ꜛ] { $cursor++; next }
                loop {
                    state $level = 1;
                    $cursor--;
                    $level-- if @code[$cursor] eq '[';
                    $level++ if @code[$cursor] eq ']';
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
        $level++ if $_ eq '[';
        $level-- if $_ eq ']';
        fail qq{Closing "]" found without matching "["\n} if $level < 0;
        LAST { fail 'Unmatched [ ]' if $level > 0 }
    }
}
