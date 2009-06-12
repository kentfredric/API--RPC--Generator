use strict;
use warnings;

use Test::More tests => 4;
use Test::Exception;

BEGIN {
  {

    package eieio;
    use ok 'API::RPC::Generator::Util::Exporter';
    use namespace::autoclean;

    auto_meta( __PACKAGE__,
      setup => sub {
        my ( $meta, $class, $exporter ) = @_;
        auto_meta(
          $class,
          setup => sub {
            my ( $imeta, $iclass, $iexporter ) = @_;

            $imeta->add_method( 'emeta', sub { $meta } );
          }
        );
      },
    );

    __PACKAGE__->meta->make_immutable;
    1;
  }
}

BEGIN {
  {

    package dog;
    BEGIN { eieio->import(); }
    use namespace::autoclean;

    __PACKAGE__->meta->make_immutable;

    ::note("These tests check exporters setup works");
    ::can_ok( __PACKAGE__, qw( import unimport init_meta ) );
    1;
  }
}
{

  package cat;
  BEGIN { dog->import(); }
  use namespace::autoclean;

  __PACKAGE__->meta->make_immutable;

  ::note("Now Checking 3rd level exports ");
  ::can_ok( __PACKAGE__, qw( emeta ) );
  1;
}

::note("Checking it didn't get harvested by autoclean");
::can_ok( 'cat', 'emeta' );

