# Copyright (c) 2010 by David Golden. All rights reserved.
# Licensed under terms of Perl itself (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://dev.perl.org/licenses/

use strict;
use warnings;

use Test::More;
use Test::Exception;

use lib 't/lib';

plan tests => 12;

require_ok( 'Metabase::Resource' );
require_ok( 'Metabase::Resource::metabase' );

#--------------------------------------------------------------------------#
# fixtures
#--------------------------------------------------------------------------#    

my ($obj, $err);

#--------------------------------------------------------------------------#
# required parameters missing
#--------------------------------------------------------------------------#

eval { $obj = Metabase::Resource->new() };
$err = $@;
like( $err, qr/no resource string provided/, "new() without string throws error" );

#--------------------------------------------------------------------------#
# fake an object and test methods
#--------------------------------------------------------------------------#

# unimplemented
for my $m ( qw/validate metadata/) {
    my $obj = bless {} => 'Metabase::Resource';
    throws_ok { $obj->$m } qr/$m not implemented by Metabase::Resource/,
      "$m not implemented";
}

# bad schema
throws_ok { $obj = Metabase::Resource->new("noschema") }
  qr/could not determine URI scheme from/,
  "no schema found";

#--------------------------------------------------------------------------#
# new should create proper subtype object
#--------------------------------------------------------------------------#

my $string = "metabase:user:B66C7662-1D34-11DE-A668-0DF08D1878C0";

lives_ok{ $obj = Metabase::Resource->new( $string ) } 
    "Metabase::Resource->new(\$string) should not die";

isa_ok( $obj, 'Metabase::Resource::metabase' ); 

is( $obj->content, $string, "object content correct" );
is( "$obj", $string, "string overloading working correctly" );

#--------------------------------------------------------------------------#
# generates typed metadata
#--------------------------------------------------------------------------#

# test metadata

my $metadata_types = {
  scheme => '//str',
  user   => '//str',
};

my $expected_metadata = {
  scheme => 'metabase',
  user   => 'B66C7662-1D34-11DE-A668-0DF08D1878C0',
};

is_deeply( $metadata_types, $obj->metadata_types, "Metadata types" );
is_deeply( $expected_metadata, $obj->metadata, "Metadata" );
