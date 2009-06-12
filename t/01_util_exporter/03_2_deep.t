use strict;
use warnings;

use Test::More tests => 9;
use Test::Exception;

BEGIN {
  {

    package eieio;
    use ok 'API::RPC::Generator::Util::Exporter';
    use namespace::autoclean;

    auto_meta( __PACKAGE__,
      setup => sub {
        my ( $meta, $class, $exporter ) = @_;
        $meta->add_method( 'emeta',     sub { $meta } );
        $meta->add_method( 'eclass',    sub { $class } );
        $meta->add_method( 'eexporter', sub { $exporter } );
      }
    );
    __PACKAGE__->meta->make_immutable;
    1;
  }
}
{

  package dog;
  BEGIN { eieio->import(); }
  use namespace::autoclean;

  __PACKAGE__->meta->make_immutable;

  ::note("These tests check exporters setup works");
  ::can_ok( __PACKAGE__, qw( emeta eclass eexporter ) );
  ::isa_ok( __PACKAGE__->emeta, 'Moose::Meta::Class' );
  ::is( __PACKAGE__->eclass,    'dog',   'Exporter exports right class name to setup ' );
  ::is( __PACKAGE__->eexporter, 'eieio', 'Exporter tells what its exporting properly' );
  1;
}
::note("Now Checking to make sure things are still there after namespace clean");
::can_ok( 'dog', qw( emeta eclass eexporter ) );
::isa_ok( 'dog'->emeta, 'Moose::Meta::Class' );
::is( 'dog'->eclass,    'dog',   'Exporter exports right class name to setup ' );
::is( 'dog'->eexporter, 'eieio', 'Exporter tells what its exporting properly' );

