package API::RPC::Generator::Meta::SharedData;

# $Id:$
use strict;
use warnings;
use Moose::Role;
use MooseX::Types::Moose qw( :all );
use MooseX::Has::Sugar;
use namespace::autoclean;

has 'root_node' => ( 
    isa => Object,
    rw

);
1;

