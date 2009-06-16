use strict;
use warnings;

use aliased 'API::RPC::Generator::Meta::Request';

my @objs;

sub teval {
  my ( $code, $message ) = @_;
  my $tb = Test::More->builder;
  my ( $success, $error ) = $tb->_try( sub { $code->(); 1; } );
  if ( !$success ) {
    $tb->ok( 0, $message );
    $tb->diag("     Error was $error");
    return;
  }
  return 1;
}

sub xtruefalse {
  my ( $expect, $actual, $message ) = @_;
  my $tb = Test::More->builder;
  if ( $expect ? !$actual : $actual ) {
    $tb->ok( 0, "Unexpected result for ``$message``" );
    $actual = "'undef'" if not defined $actual;
    $tb->diag(" Expected: $expect\n Got: $actual");
    return;
  }
  return 1;
}

sub newt($$$$;$) {
  my $params     = shift;
  my $name       = shift;
  my $xpossible  = shift;
  my $xmandatory = shift;
  my $xmandpos   = shift // 1;

  my @t;
  push @t, 'xfail possible'  if !$xpossible;
  push @t, 'xfail mandatory' if !$xmandatory;
  push @t, 'xfail mand|pos'  if !$xmandpos;

  my $tb = Test::More->builder;
  my ( $obj, $ispossible, $ismandatory, $ispossormand );

  return unless teval( sub { $obj = Request->new(%$params); }, 'new() died', );

  return unless teval( sub { $ispossible = $obj->all_parameters_possible; }, 'all_parameters_possible() died', );

  return unless xtruefalse( $xpossible, $ispossible, " all parameters are possible for `$name`" );

  return
    unless teval( sub { $ispossormand = $obj->all_parameters_possible_or_mandatory; },
        'all_parameters_possible_or_mandatory() died', );

  return unless xtruefalse( $xmandpos, $ispossormand, " all parameters are possible or mandatory for `$name`" );

  return
    unless teval(
    sub { $ismandatory = $obj->all_mandatory_parameters_fullfilled; 1; },
    "all_mandatory_parameters_fullfilled() died for `$name`",
    );
  return unless xtruefalse( $xmandatory, $ismandatory, "all mandatory parameter are provided for `$name`" );

  $tb->ok( 1, "Can execute and run `$name` properly : [" . join( ',', @t ) . ']' );
}

sub xfail() { 0 }
sub xpass() { 1 }
use Test::More tests => 18;
use Test::Exception;

# General Cases to Test functioning.
newt {}, 'No Init Parameters', xpass, xpass,;
newt { path => [], }, 'Empty Path', xpass, xpass,;
newt { path => [ 'a', ], }, '1 Token Path', xpass, xpass,;
newt { path => [ 'a', 'b' ], }, '2 Token Path', xpass, xpass,;
newt { parameters => {}, }, 'No Request Parameters', xpass, xpass,;
newt { parameters => { foo => 'bar', }, }, '1 Request Parameter', xfail, xpass, xfail,;
newt { possible_parameters => [] }, 'Empty possibles', xpass, xpass,;
newt { possible_parameters => [ 'foo', ], }, '1 possibles', xpass, xpass,;
newt { possible_parameters => [ 'foo', 'bar', ], }, '2 possibles', xpass, xpass,;
newt { mandatory_parameters => [] }, 'Empty mandatory', xpass, xpass,;
newt { mandatory_parameters => [ 'foo', ], }, '1 mandatory', xpass, xfail,;
newt { mandatory_parameters => [ 'foo', 'bar', ], }, '2 mandatory', xpass, xfail,;

# More specific

newt {
  possible_parameters => [ 'a', ],
  parameters          => { a => '1' },
  },
  'Possbile+param', xpass, xpass,;

newt {
  possible_parameters => [ 'a', ],
  parameters          => { a => '1', 'b' => 2, },
  },
  'Possbile+param+extras', xfail, xpass, xfail;

newt {
  possible_parameters => [ 'a', 'b', ],
  parameters => { a => '1', 'b' => 2, },
  },
  'Possbile+param+extras+', xpass, xpass,;

newt {
  mandatory_parameters => [ 'a', ],
  parameters           => { a => '1' },
  },
  'Mandatory+param', xfail, xpass,;

newt {
  mandatory_parameters => [ 'a', 'b', ],
  parameters => { a => '1', },
  },
  'Mandatory+param+extras', xfail, xfail,;

newt {
  mandatory_parameters => [ 'a', 'b', ],
  parameters => { a => '1', 'b' => 2, },
  },
  'Mandatory+param+extras+', xfail, xpass,;


