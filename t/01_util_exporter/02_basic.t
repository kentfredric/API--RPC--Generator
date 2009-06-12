use strict;
use warnings;

use Test::More tests => 4;
use Test::Exception;
{

  package eieio;
  use ok 'API::RPC::Generator::Util::Exporter';
  use namespace::autoclean;

  ::lives_ok(
    sub {
      auto_meta(__PACKAGE__);
    },
    'Meta Build Is Good'
  );
  ::can_ok( __PACKAGE__ , qw( meta import unimport init_meta ) );

  1;
}

::can_ok( 'eieio', qw( meta import unimport init_meta ) );

