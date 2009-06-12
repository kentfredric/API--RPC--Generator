package API::RPC::Generator::Util::Debug;

# $Id:$
use strict;
use warnings;
use Moose::Exporter;
use Carp         ();
use Data::Dumper ();
use namespace::autoclean also => qr/^__/;

Moose::Exporter->setup_import_methods( as_is => [ 'export_message', 'exporter_message' ] );

sub __debug() {
  return ( exists $ENV{'DEBUG_API_RPC_GENERATOR'} ? $ENV{'DEBUG_API_RPC_GENERATOR'} : undef );
}

sub __print {
  if ( my $level = __debug > 1 ) {
    goto \&Carp::cluck;    # stack duck
  }
  else {
    print @_, "\n";
  }
}

sub __dumpr {
  local $Data::Dumper::Terse  = 1;
  local $Data::Dumper::Indent = 0;
  local $Data::Dumper::Useqq  = 1;
  return Data::Dumper::Dumper(@_);
}

sub __name_export {
  my $str = shift;
  $str =~ s{P<([^>]+)>}{\e[1m$1\e[21m}g;
  return $str;
}

# Pretty Print Processor,
# expands P<> to be bold highlighted ANSI,
# colorises lines,
# auto dumps any token that looks like a ref.
#
sub __print_export {
  __debug or return;
  my $ccode   = "\e[" . shift(@_) . "m";
  my $message = '';
  for ( $ccode, @_, "\e[0m" ) {
    $message .=
      ref $_
      ? ( __dumpr($_) )
      : ( __name_export($_) );
  }
  @_ = ($message);
  goto \&__print;    # backtrace avoidance for carp
}

sub export_message {
  __debug or return;
  unshift @_, '35';
  goto \&__print_export;    # backtrace avoidance for carp
}

sub exporter_message {
  __debug or return;
  unshift @_, '32';
  goto \&__print_export;    # backtrace avoidance for carp
}

1;

