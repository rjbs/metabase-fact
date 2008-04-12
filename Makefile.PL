require 5.006;
use inc::Module::Install;
all_from('lib/CPAN/Metabase/Fact.pm');

requires('Carp'               => 0); # minimum version unknown
requires('Params::Validate'   => 0); # minimum version unknown

# Maybe I'll keep this stuff all in one test with a SKIP...
# test_requires('YAML::Tiny'    => 0); # minimum version unknown
# test_requires('Data::GUID'    => 0); # minimum version unknown

extra_tests;

WriteAll;
