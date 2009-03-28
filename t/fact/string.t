# Copyright (c) 2008 by Ricardo Signes. All rights reserved.
# Licensed under terms of Perl itself (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://dev.perl.org/licenses/

use strict;
use warnings;

use Test::More;
use Test::Exception;

use lib 't/lib';

plan tests => 9;

require_ok( 'CPAN::Metabase::Fact::String' );

#--------------------------------------------------------------------------#
# fixtures
#--------------------------------------------------------------------------#    

my ($obj, $err);

my $string = "Who am I?";

my $args = {
    resource => "JOHNDOE/Foo-Bar-1.23.tar.gz",
    content  => $string,
};

lives_ok{ $obj = CPAN::Metabase::Fact::String->new( $args ) } 
    "new( <hashref> ) doesn't die";

isa_ok( $obj, 'CPAN::Metabase::Fact::String' ); 

lives_ok{ $obj = CPAN::Metabase::Fact::String->new( %$args ) } 
    "new( <list> ) doesn't die";

isa_ok( $obj, 'CPAN::Metabase::Fact::String' );

is( $obj->type, "CPAN-Metabase-Fact-String", "object type is correct" );
is( $obj->resource, $args->{resource}, "object refers to distribution" );
is( $obj->content, $string, "object content correct" );
ok( ! $obj->is_submitted, "object is_submitted() is false" );

