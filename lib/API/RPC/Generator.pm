package API::RPC::Generator;

# $Id:$
use API::RPC::Generator::Util::Exporter;
use namespace::autoclean;

# things calling us
# get moose and backend
#
auto_meta( __PACKAGE__,
  with_caller => ['backend'],
  also        => 'Moose',
  setup       => sub {
    my ( $meta, $class ) = @_;
    require API::RPC::Generator::Meta::API;

    # things calling that thing get methods from ::API
    # Which also produce moose
    auto_meta(
      $class,
      also  => [ 'API::RPC::Generator::Meta::API', ],
      setup => sub { }
    );
  }
);

sub backend {

}

1;

