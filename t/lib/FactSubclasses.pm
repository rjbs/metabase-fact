package FactSubClasses;
use strict;
use warnings;

package FactOne;
our @ISA = ('CPAN::Metabase::Fact::TestFact');
sub content_as_bytes    { return reverse($_[0]->{content})  };
sub content_from_bytes  { return reverse($_[1])             };

package FactTwo;
our @ISA = ('CPAN::Metabase::Fact::TestFact');
sub content_as_bytes    { return reverse($_[0]->{content})  };
sub content_from_bytes  { return reverse($_[1])             };

package FactThree;
use base 'CPAN::Metabase::Fact::String';
sub validate_content    { length $_[0]->content > 0 }
sub content_metadata    { return { 'length' => length $_[0]->content } }


1;
