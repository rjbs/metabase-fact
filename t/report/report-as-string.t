# Copyright (c) 2008 by Ricardo Signes. All rights reserved.
# Licensed under terms of Perl itself (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://dev.perl.org/licenses/

use strict;
use warnings;

use Test::More;
use Test::Exception;

plan tests => 13;

require_ok( 'Metabase::Report' );
require_ok( 'Metabase::Fact::TestFact' );

#--------------------------------------------------------------------------#
# fixtures
#--------------------------------------------------------------------------#    

require t::lib::ReportSubclasses;
require t::lib::FactSubclasses;

my %params = (
  resource => "JOHNDOE/Foo-Bar-1.23.tar.gz",
);

my %facts = (
  FactOne     => FactOne->new( %params, content => "FactOne" ),
  FactTwo     => FactTwo->new( %params, content => "FactTwo" ),
);

my ($report, $err);

#--------------------------------------------------------------------------#
# report that takes 1 fact
#--------------------------------------------------------------------------#

lives_ok { 
  $report = JustOneFact->open( %params )
} "lives: open() given no facts";

isa_ok( $report, 'JustOneFact' );

lives_ok {
  $report->add( 'FactOne' => 'This is FactOne' );
} "lives: add( 'Class' => 'foo' )";

lives_ok {
  $report->close;
} "lives: close()";

#--------------------------------------------------------------------------#
# round trip
#--------------------------------------------------------------------------#

my $class = ref $report;

my $report2;
lives_ok {
  $report2 = $class->from_struct( $report->as_struct );
} "lives: as_struct->from_struct";

isa_ok( $report2, $class );
    
is_deeply( $report, $report2, "report2 is a clone of report" );

# set_creator_id
for my $fact ($report, $report->facts) {
  is($fact->creator_id, undef, "no creator id (round 1)");
}

my $guid = '351E99EA-1D21-11DE-AB9C-3268421C7A0A';

$report->set_creator_id($guid);

for my $fact ($report, $report->facts) {
  is($fact->creator_id, $guid, "creator set properly (round 2)");
}
