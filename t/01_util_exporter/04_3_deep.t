use strict;
use warnings;

use Test::More tests => 3;
use Test::Exception;
use Find::Lib './04_3_deep';

{

  package cat;
  use dog;
  use namespace::autoclean;

  __PACKAGE__->meta->make_immutable;

  ::note("These tests check exporters setup works");
  ::can_ok( 'dog', qw( import unimport init_meta ) );

  ::note("Now Checking 3rd level exports ");
  ::can_ok( __PACKAGE__, qw( emeta ) );
  1;
}

::note("Checking it didn't get harvested by autoclean");
::can_ok( 'cat', 'emeta' );

