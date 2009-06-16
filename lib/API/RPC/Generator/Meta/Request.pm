package API::RPC::Generator::Meta::Request;

# $Id:$
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw( :all );
use MooseX::Types::Set::Object;
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
  isa => 'Set::Object',
  coerce,
  rw,
  lazy_build,
  handles => {
    set_possible   => 'insert',
    is_possible    => 'has',
    unset_possible => 'delete',
  },

);

has mandatory_parameters => (
  isa => 'Set::Object',
  coerce,
  rw,
  lazy_build,
  handles => {
    set_mandatory   => 'insert',
    is_mandatory    => 'has',
    unset_mandatory => 'delete',
  },
);

sub _build_possible_parameters {
  return [];
}

sub _build_mandatory_parameters {
  return [];
}

sub all_parameters_possible {
  my $self = shift;
  return $self->is_possible( $self->param_names );
}

sub all_parameters_possible_or_mandatory {
  my $self = shift;
  return $self->mandatory_parameters->union( $self->possible_parameters )->has( $self->param_names );
}

sub all_mandatory_parameters_fullfilled {
  my $self = shift;
  for ( @{ $self->mandatory_parameters } ) {
    return if !$self->has_param($_);
  }
  return 1;
}

__PACKAGE__->meta->make_immutable;
1;

