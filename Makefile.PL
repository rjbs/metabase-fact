require 5.006;
use inc::Module::Install;
all_from('lib/Metabase/Fact.pm');

requires('Data::GUID'         => 0); # minimum version unknown
requires('JSON'               => 0); # minimum version unknown
requires('Encode'             => 0); # minimum version unknown
requires('Time::Piece'        => 0); # minimum version unknown
requires('CPAN::DistnameInfo' => 0); # XXX remove later? -- dagolden, 2010-01-28

test_requires('Test::More'      => 0.88); # done_testing
test_requires('Test::Exception' => 0.26); # avoid bugs

install_script('bin/metabase-profile');
 
auto_manifest;
extra_tests;
tests_recursive;

WriteAll;
