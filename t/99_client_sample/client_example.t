
use strict;
use warnings;

use Test::More tests => 1;

use Find::Lib './tlib';

use TestClient;

my $test = TestClient->new();

ok('Test Client didn\'t suicide');
