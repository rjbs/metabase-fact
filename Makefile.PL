require 5.006;
use inc::Module::Install;
all_from('lib/CPAN/Metabase/Fact.pm');

requires('base'               => 0);
requires('Carp'               => 0); # minimum version unknown
requires('Params::Validate'   => 0); # minimum version unknown
requires('Storable'           => 0); # minimum version unknown

test_requires('Test::More'      => 0.62);
test_requires('Test::Exception' => 0.26); # avoid bugs
  
extra_tests;
tests_recursive;

WriteAll;
