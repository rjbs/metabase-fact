use strict;
use warnings;

package FactOne;
our @ISA = ('CPAN::Metabase::Fact::TestFact');
sub content_as_string   { return reverse($_[0]->{content})  };
sub content_from_string { return reverse($_[1])             };

package FactTwo;
our @ISA = ('CPAN::Metabase::Fact::TestFact');
sub content_as_string   { return reverse($_[0]->{content})  };
sub content_from_string { return reverse($_[1])             };

1;
