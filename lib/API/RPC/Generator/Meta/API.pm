package API::RPC::Generator::Meta::API;

# $Id:$
use API::RPC::Generator::Util::Exporter;
use namespace::autoclean;

auto_meta( __PACKAGE__,
  with_caller => [ 'root', 'leaf', 'subspace', 'dynamic_call', ], );

sub root() {

}

sub leaf() {

}

sub subspace($) {

}

sub dynamic_call {

}

1;

