#!perl6

use lib 'lib';
use Test;
use Test::Output;
use Acme::Anguish;

unless %*ENV<INTERACTIVE_TESTING> {
    diag "INTERACTIVE_TESTING env var not set. Skipping this test";
    done-testing;
    exit;
}

diag 'Type word "test" (press ENTER if nothing happens right after you type it)';

output-is {
    anguish 't/ang-programs/input1.ang'.IO.slurp;
}, "test", 'input -> output program works';


done-testing;
