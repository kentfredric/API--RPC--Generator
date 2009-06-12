package API::RPC::Generator::Meta::API;

# $Id:$
use API::RPC::Generator::Util::Exporter;
use MooseX::Types::Moose qw( :all);
use MooseX::Has::Sugar;
use namespace::autoclean;

auto_meta( __PACKAGE__,
  with_caller => [ 'root', 'leaf', 'subspace', 'dynamic_call', ],
  also        => 'Moose',
);

sub root() {
  my ( $caller, @args ) = @_;
  my $api = $caller->_API_NAME->new();
  $caller->meta->add_method( 'api',  sub { return $api; } );
  $caller->meta->add_method( 'path', sub { return () } );
}

sub leaf() {
  my ( $caller, @args ) = @_;
  $caller->meta->add_attribute( '_api', isa => Object, ro, required );
  $caller->meta->add_method( 'api', sub { my $self = shift; $self->_api } );

  #  $caller->meta->add_method( '
}

sub subspace($) {
  my ( $caller, $spacename, @args ) = @_;

  #  $caller $caller->meta->add_method( '

}

sub dynamic_call($;) {

}

1;

