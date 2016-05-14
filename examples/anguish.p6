#!perl6

use lib 'lib';
use Inline::Brainfuck;

brainfuck 't/bf-programs/hello-world.bf'.IO.slurp;
