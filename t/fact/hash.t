# Copyright (c) 2008 by Ricardo Signes. All rights reserved.
# Licensed under terms of Perl itself (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://dev.perl.org/licenses/

use strict;
use warnings;

use Test::More;
use Test::Exception;
use JSON;

use lib 't/lib';

plan tests => 16;

require_ok( 'FactSubclasses.pm' );

#--------------------------------------------------------------------------#
# fixtures
#--------------------------------------------------------------------------#    

my ($obj, $err);

my $struct = {
  first => 'alpha',
  second => 'beta',
};

my $meta = {
  size => [ Num => 2 ],
};

my $args = {
  resource => "cpan:///JOHNDOE/Foo-Bar-1.23.tar.gz",
  content  => $struct,
};

my $test_args = {
  resource => $args->{resource},
  content => { },
};

throws_ok { $obj = FactFour->new( $test_args ) } qr/missing required keys.+?first/, 
  'missing required dies';

$test_args->{content}{first} = 1;

lives_ok{ $obj = FactFour->new( $test_args ) } 
    "new( <hashref> ) doesn't die";

$test_args->{content}{third} = 3;

throws_ok { $obj = FactFour->new( $test_args ) } qr/invalid keys.+?third/, 
  'invalid key dies';

isa_ok( $obj, 'CPAN::Metabase::Fact::Hash' ); 

lives_ok{ $obj = FactFour->new( %$args ) } 
    "new( <list> ) doesn't die";

isa_ok( $obj, 'CPAN::Metabase::Fact::Hash' );
is( $obj->type, "FactFour", "object type is correct" );
is( $obj->{metadata}{core}{type}[1], "FactFour", "object type is set internally" );

is( $obj->resource, $args->{resource}, "object refers to distribution" );
is_deeply( $obj->content_metadata, $meta, "object content_metadata() correct" );
is_deeply( $obj->content, $struct, "object content correct" );

my $want_struct = {
  content  => to_json($struct),
  metadata => {
    core    => {
      type           => [ Str => 'FactFour'        ],
      schema_version => [ Num => 1                 ],
      guid           => [ Str => $obj->guid        ],
      resource       => [ Str => $args->{resource} ],
    },
  }
};

my $have_struct = $obj->as_struct;
ok(
  (delete $have_struct->{metadata}{core}{created_at}) - time < 60,
  'we created the fact recently',
);

is_deeply($have_struct, $want_struct, "object as_struct correct"); 

my $guid = '351E99EA-1D21-11DE-AB9C-3268421C7A0A';
$obj->set_creator_id($guid);
$want_struct->{metadata}{core}{creator_id} = [ Str => $guid ];

is_deeply($have_struct, $want_struct, "object as_struct correct w/creator"); 

#--------------------------------------------------------------------------#

$obj = FactFour->new( %$args );
my $obj2 = FactFour->from_struct( $obj->as_struct );
is_deeply( $obj2, $obj, "roundtrip as->from struct" );

