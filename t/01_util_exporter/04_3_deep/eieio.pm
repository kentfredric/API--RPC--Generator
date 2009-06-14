package eieio;

# $Id:$
use API::RPC::Generator::Util::Exporter;
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


