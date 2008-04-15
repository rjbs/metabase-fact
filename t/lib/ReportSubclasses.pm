use strict;
use warnings;

package JustOneFact;
our @ISA = ('CPAN::Metabase::Report');
sub report_spec { return {'CPAN::Metabase::Fact' => 1} }

package OneOrMoreFacts;
our @ISA = ('CPAN::Metabase::Report');
sub report_spec { return {'CPAN::Metabase::Fact' => '1+'} }

package OneOfEach;
our @ISA = ('CPAN::Metabase::Report');
sub report_spec { 
  return {
    'FactOne' => '1',
    'FactTwo' => '1',
  }
}

package OneSpecificAtLeastThreeTotal;
our @ISA = ('CPAN::Metabase::Report');
sub report_spec { 
  return {
    'FactOne' => '1',
    'CPAN::Metabase::Fact' => '3',
  }
}

1;
