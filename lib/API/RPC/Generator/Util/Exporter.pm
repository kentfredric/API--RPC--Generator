package API::RPC::Generator::Util::Exporter;

# $Id:$
use strict;
use warnings;
use Moose;
use Moose::Exporter ();
use API::RPC::Generator::Util::Debug    # PRUNE
  exporter_message => { -as => 'Debug_export' },    # PRUNE
  export_message   => { -as => 'Debug_import' };    # PRUNE
use namespace::autoclean also => qr/^__/;

#
# If you're reading this source and can't read it past all the debugging/tracing mess,
# grep -v '#\sPRUNE' Exporter.pm > Exporter.pm.humans
#
sub __fc {                                          # PRUNE
  my $caller = shift;                                  # PRUNE
  return "P<" . $caller->[0] . '>:' . $caller->[2];    # PRUNE
}    # PRUNE

# This init meta is run for everyone.
# Note we need a substantially large information set to provide debugging traces
# as to what package defined what exports as they wont be visible in the class itself.
#
# This is just one of the things you have to put up with if you're writing meta-meta infrastructure.
#
sub __virtual_init_meta {
  my ( $ex, $self, %params ) = @_;

  my (@inner_caller) = caller(1);

  # Init Meta
  my $meta = Moose->init_meta(%params);

  Debug_import(    # PRUNE
    sprintf(       # PRUNE
      '{ package P<%s>; P<%s>->import() } by %s/%s ',    # PRUNE
      $params{'for_class'}, $ex->{'by'}, __fc( \@inner_caller ),    # PRUNE
      , __fc( $ex->{'caller'} ),                                    # PRUNE
    ),                                                              # PRUNE
    $ex->{params},                                                  # PRUNE
  );                                                                # PRUNE

  # Run predefined setup hook for importer
  if ( $ex->{'setup'} ) {

    Debug_import(                                                   # PRUNE
      sprintf(                                                      # PRUNE
        'P<%s>~~setup( %s, %s, %s): %s', $ex->{'by'}, $meta, $params{'for_class'}, $ex->{'by'},    # PRUNE
        __fc( $ex->{'caller'} )                                                                    # PRUNE
      ),                                                                                           # PRUNE
    );                                                                                             # PRUNE

    # Chain into custom post-meta-init bootstrapper
    $ex->{'setup'}->( $meta, $params{'for_class'}, $ex->{'by'} );
  }

  Debug_import( sprintf( '\@P<%s>-meta->get_method_list # ', $params{'for_class'} ), [ $meta->get_method_list ] );    # PRUNE

  return $meta;
}

# auto_meta is just like sub_exporter, except it requires things to have records on a MOOSE
# tree, which gets around complications with namespace::autoclean erasing things.
# also adds a convenient 'setup' function that can be called after the meta-model is done.
#
sub auto_meta {
  my ( $exporter, %export_params ) = @_;
  my (@caller)    = caller;
  my $setup       = delete $export_params{setup};
  my $export_info = {
    by     => $exporter,
    params => \%export_params,    # PRUNE
    setup  => $setup,
    caller => \@caller,           # PRUNE
  };

  Debug_export( "P<$caller[0]>:$caller[2] auto_meta('P<$exporter>',", \%export_params, ", setup => sub { DUMMY })" );    # PRUNE

  # Generate Import/Unimport
  my @subs = Moose::Exporter->build_import_methods( exporting_package => $exporter, %export_params, );

  # Generate A meta package for the importer
  my $exporter_meta = Moose->init_meta( 'for_class' => $exporter );

  # Attach import as a method
  $exporter_meta->add_method( 'import', $subs[0] );

  Debug_export("&P<${exporter}::import>=sub{}");                                                                         # PRUNE

  # Attach unimport as a method
  $exporter_meta->add_method( 'unimport', $subs[1] );

  Debug_export("&P<${exporter}::unimport>=sub{}");                                                                       # PRUNE

  # Attach init_meta as a method
  $exporter_meta->add_method(
    'init_meta',
    sub {

      # Just enough to grab closure information before sending it down to the method
      unshift @_, $export_info;
      goto \&__virtual_init_meta;
    }
  );
  Debug_export("&P<${exporter}::init_meta>=sub{}");                                                                      # PRUNE

  Debug_export( "\@P<$exporter>->meta->get_method_list # ", [ $exporter_meta->get_method_list ] );                       # PRUNE

  return $exporter_meta;
}

auto_meta( __PACKAGE__, as_is => [qw( auto_meta )], );

1;
__END__

This package is essentially like Moose::Exporter, but specialises in making *other* packages exporters,
not ourself.

To do this, we need a bit of symbol quackery, because otherwise, our injections are reaped
by namespace::autoclean, so we inject the symbols into the meta.

To guarantee things have a meta, we also inject Moose.

Behaviourwise, it makes the following possible:


    package TopPackage;
    use API::RPC::Generator::Util::Exporter;
    use namespace::autoclean;

    auto_meta( __PACKAGE__ , setup => sub {
            my( $meta, $class ) = @_;
            auto_meta( $class , setup => sub {
                my ( $cmeta, $cclass ) = @_;
                $cmeta->add_method( 'foo', sub { 'yay' } );
            }
    };
    1;

    package SecondLevel;

    use TopPackage;
    use namespace::autoclean;

    # __PACKAGE__->foo(); # will die
    1;


    package ThirdLevel;
    use SecondLevel;
    use namespace::autoclean;

    __PACKAGE__->foo(); # will work.
    1;
