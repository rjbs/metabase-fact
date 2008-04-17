# Copyright (c) 2008 by Ricardo Signes. All rights reserved.
# Licensed under terms of Perl itself (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://dev.perl.org/licenses/

use strict;
use warnings;

use Test::More;
use Test::Exception;

plan tests => 8;

require_ok( 'CPAN::Metabase::Report' );
require_ok( 'CPAN::Metabase::Fact::TestFact' );

#--------------------------------------------------------------------------#
# fixtures
#--------------------------------------------------------------------------#    

require t::lib::ReportSubclasses;
require t::lib::FactSubclasses;

my %params = (
  dist_author => "JOHNDOE",
  dist_file => "Foo-Bar-1.23.tar.gz",
);

my %facts = (
  FactOne     => FactOne->new( %params, content => "FactOne" ),
  FactTwo     => FactTwo->new( %params, content => "FactTwo" ),
);

my ($obj, $err);

#--------------------------------------------------------------------------#
# report that takes 1 fact
#--------------------------------------------------------------------------#

lives_ok { 
  $obj = JustOneFact->open( %params )
} "lives: open() given no facts";

isa_ok( $obj, 'JustOneFact' );

lives_ok {
  $obj->add( 'FactOne', content => 'FactOne' );
} "lives: add( 'Class', content => 'foo' )";

lives_ok {
  $obj->close;
} "lives: close()";

#--------------------------------------------------------------------------#
# stringify round trip
#--------------------------------------------------------------------------#

my $meta = $obj->core_meta;
my $content = $obj->content_as_string;

my $class = $meta->{type};
$class =~ s{-}{::}g;

my $obj2;
lives_ok {
  $obj2 = $class->new( 
    %$meta, content => $class->content_from_string( $content ) 
  );
} "lives: new object with roundtrip content";

is( $obj->content->[0]->content, 
    $obj2->content->[0]->content, 
    "obj1 content eq obj2 content" 
);


