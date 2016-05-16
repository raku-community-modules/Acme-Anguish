#!perl6

use lib 'lib';
use Test;
use Test::Output;
use Acme::Anguish;

output-is {
    anguish "\x2061" x 72 ~ "\x2063";
}, "H", 'Output letter "H"';

output-is {
    anguish 't/ang-programs/hello-world.ang'.IO.slurp;
}, "Hello World!\n", 'Hello world! program works';


done-testing;
