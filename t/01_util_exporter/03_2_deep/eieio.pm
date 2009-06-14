package eieio;

# $Id:$
use API::RPC::Generator::Util::Exporter;
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

