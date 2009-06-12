use strict;
use warnings;

use Test::More tests => 5;
use Test::Exception;

{

  package eieio;
  use ok 'API::RPC::Generator';
  use namespace::autoclean;

  ::lives_ok( sub { backend; }, 'Exports Needed Symbols' );
  ::can_ok( __PACKAGE__, qw( import init_meta unimport ) );
  1;
}

::dies_ok(
  sub {
    eieio->backend;
  },
  'No Residual Symbolics'
);

::can_ok( 'eieio', qw( import init_meta unimport ) );
