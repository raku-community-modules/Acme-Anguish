#!perl6

use lib 'lib';
use Acme::Anguish;

anguish 'examples/hello-world.ang'.IO.slurp;
