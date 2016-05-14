#!perl6

use lib 'lib';
use Test;
use Test::Output;
use Inline::Brainfuck;

output-is {
    brainfuck '++++++++++ ++++++++++ ++++++++++ ++++++++++'
        ~ '++++++++++ ++++++++++ ++++++++++ ++.';
}, "H", 'Output letter "H"';

output-is {
    brainfuck 't/bf-programs/hello-world.bf'.IO.slurp;
}, "Hello World!\n", 'Hello world! program works';


done-testing;
