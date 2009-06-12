package API::RPC::Generator;

# $Id:$
use API::RPC::Generator::Util::Exporter qw( auto_meta );
use API::RPC::Generator::Util::Debug qw( export_message );
use MooseX::Types::Moose qw( :all );
use MooseX::Has::Sugar;
use namespace::autoclean also => qr/^__/;

#
# Called on YourPackage::API->import();
#
sub __import_user_api {
  my ( $meta, $class, $metaclass ) = @_;
  export_message("&P<${class}::_API_NAME>=sub{ $metaclass }");
  $meta->add_method(
    _API_NAME => sub {
      return $metaclass;
    }
  );
}

# called on ::Generator->import();
sub __setup_user_api_importer {
  my ( $meta, $class, $metaclass ) = @_;

  # things calling that thing get methods from ::API
  # Which also produce moose
  require API::RPC::Generator::Meta::API;
  auto_meta(
    $class,
    also  => [ 'API::RPC::Generator::Meta::API', ],
    setup => \&__import_user_api,
  );
  return $meta;
}

# Using ::Generator Exports symbols
auto_meta( __PACKAGE__,
  with_caller => ['backend'],
  setup       => \&__setup_user_api_importer,
);

sub backend {

}

1;

