package API::RPC::Generator::Meta::Request;

# $Id:$
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw( :all );
use MooseX::AttributeHelpers;
use namespace::autoclean;

has '_path' => (
  rw,
  init_arg  => 'path',
  isa       => ArrayRef [Str],
  metaclass => 'Collection::Array',
  provides  => {
    push     => 'subdir',
    elements => 'path',
    join     => 'join_path',
  },
  default => sub { [] },
);

has parameters => (
  isa => HashRef,
  rw,
  default   => sub { +{} },
  metaclass => 'Collection::Hash',
  provides  => {
    set    => 'set_param',
    get    => 'get_param',
    keys   => 'param_names',
    exists => 'has_param',
  },
);

has possible_parameters => (
  isa => HashRef,
  rw,
  default   => sub { +{} },
  metaclass => 'Collection::Hash',
  provides  => {
    keys   => 'possible_parameter_names',
    exists => 'is_possible_parameter',
  },
  curries => {
    set => {
      set_possible_param => sub {
        my ( $self, $body, $name ) = @_;
        $body->( $self, $name, 1 );
      },
    },
  },
);
has mandatory_parameters => (
  isa => HashRef,
  rw,
  default   => sub    { +{} },
  metaclass => 'Collection::Hash',
  provides  => { keys => 'mandatory_parameter_names', },
  curries   => {
    set => {
      set_mandatory_param => sub {
        my ( $self, $body, $name ) = @_;
        $body->( $self, $name, 1 );
      },
    },
  },
);

sub all_parameters_possible {
  my $self = shift;
  for ( $self->param_names ) {
    return if !$self->is_possible_parameter($_);
  }
  return 1;
}

sub all_mandatory_parameters_fullfilled {
  my $self = shift;
  for ( $self->mandatory_parameter_names ) {
    return if !$self->has_param($_);
  }
  return 1;
}

1;

