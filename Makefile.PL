require 5.006;
use inc::Module::Install;
all_from('lib/CPAN/Metabase/Fact.pm');

requires('CPAN::DistnameInfo' => 0); # minimum version unknown
requires('Carp'               => 0); # minimum version unknown
requires('Data::GUID'         => 0); # minimum version unknown
requires('Params::Validate'   => 0); # minimum version unknown

extra_tests;

WriteAll;
