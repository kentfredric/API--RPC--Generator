use strict;
use warnings;

use Test::More tests => 10;    # last test to print
use Test::Warn;
use Test::Output;
{

  package eieio;

  use ok 'API::RPC::Generator::Util::Debug';
  use namespace::clean;

  local %ENV = %ENV;
  delete $ENV{'DEBUG_API_RPC_GENERATOR'};

  ::warnings_are(
    sub {
      ::stdout_is( sub { export_message("hello") }, '', 'No Trace without request' );
    },
    [],
    'No warnings with trace off'
  );

  $ENV{'DEBUG_API_RPC_GENERATOR'} = 1;
  ::warnings_are(
    sub {
      ::stdout_like( sub { export_message("hello") }, qr/hello/, 'Outputs with tracing=1' );
    },
    [],
    'No warnings with trace off'
  );
  $ENV{'DEBUG_API_RPC_GENERATOR'} = 2;
  ::warning_like(
    sub {
      ::stdout_is( sub { export_message("hello") }, '', 'Outputs no stdout with tracing=2' );
    },
    qr/hello/,
    'Warnings with trace=2'
  );

  $ENV{'DEBUG_API_RPC_GENERATOR'} = 1;
  ::warnings_are(
    sub {
      ::stdout_like(
        sub { export_message( [ { a => 'b' } ] ) },
        qr{ \[\s*{\s*['"]?a['"]?\s*=>\s*['"]?b['"]?\s*}\] }x,
        'AutoDumping Support',
      );
      ::stdout_unlike( sub { export_message('example P<Foo>') }, qr{ P<[^>]+> }, 'Pretty formatting support', );
    },
    [],
    'no excess warnings'
  );
}

