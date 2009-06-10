package API::RPC::Generator::Util::Exporter;

# $Id:$
use strict;
use warnings;
use Moose;
use Moose::Util     ();
use Moose::Exporter ();
use namespace::autoclean;

# This init_meta is called when people 'use API::RPC::Generator'
# This in turn creates an "init_meta", "import", and "unimport"
# method on that class, which respectively export/unimport
# symbols from API::RPC::Generator::Meta::API

sub build_metas {
  my $class  = shift;
  my %extras = @_;
  my $setup  = ( delete $extras{setup} || sub { return shift; } );
# my $also   = ( delete $extras{also}  || [] );
# $also = [ $also ] unless ref $also  eq 'ARRAY';
# push @{$also}, 'Moose';
  my ( $import, $unimport ) = Moose::Exporter->build_import_methods(
    exporting_package => $class,
#    also => $also,
    %extras,
  );
  my $init_meta = sub {
    my $self   = shift;
    my %params = @_;
    my $meta   = Moose->init_meta(%params);
    return $setup->( $meta, $params{'for_class'} );
  };
  return ( $import, $unimport, $init_meta );
}

sub attach_metas {
  my $meta = shift;
  my @keys = qw( import unimport init_meta );
  map { $meta->add_method( $keys[$_], $_[$_] ) } 0 .. $#keys;
  return $meta;
}

# auto_meta is just like sub_exporter, except it requires things to have records on a MOOSE
# tree, which gets around complications with namespace::autoclean erasing things.
# also adds a convenient 'setup' function that can be called after the meta-model is done.
#
sub auto_meta {
  my $class  = shift;
  my %params = @_;
  my $meta   = Moose->init_meta( 'for_class' => $class );
  my @bm     = build_metas( $class, %params );
  attach_metas( $meta, @bm );
}

auto_meta( __PACKAGE__, as_is => [qw( auto_meta )], );

1;

