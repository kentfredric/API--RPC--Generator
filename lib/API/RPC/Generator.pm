package API::RPC::Generator;

# $Id:$
use API::RPC::Generator::Util::Exporter;
use API::RPC::Generator::Meta::API;
use namespace::autoclean;

# things calling us
# get moose and backend
#
auto_meta( __PACKAGE__,
  with_caller => ['backend'],
  setup       => sub {
    my ( $meta, $class ) = @_;

    # things calling that thing get methods from ::API
    # Which also produce moose
    auto_meta( $class, also => [ 'API::RPC::Generator::Meta::API', ], );
  }
);

sub backend {

}

1;

