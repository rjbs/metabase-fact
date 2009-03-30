# Copyright (c) 2009 by David Golden. All rights reserved.
# Licensed under Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://www.apache.org/licenses/LICENSE-2.0

use strict;
use warnings;

use Test::More;
use File::Find;
use File::Spec;

my @pms;
find( sub { return if /^\.\.?$/; push @pms, $File::Find::name if /\.pm/ }, 'lib' );

if ( @pms ) {
  plan tests => scalar @pms;
}
else {
  plan skip_all => 'no .pm files found';
}

my $null = File::Spec->devnull;

for my $file ( @pms ) {
  system("$^X -c $file > $null 2>&1");
  ok( $? == 0, "compiled $file" );
}


