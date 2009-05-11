require 5.006;
use inc::Module::Install;
all_from('lib/Metabase/Fact.pm');

requires('Data::GUID'         => 0); # minimum version unknown
requires('JSON'               => 0); # minimum version unknown
requires('Encode'             => 0); # minimum version unknown

test_requires('Test::More'      => 0.62);
test_requires('Test::Exception' => 0.26); # avoid bugs

install_script('bin/metabase-profile');
 
extra_tests;
tests_recursive;

WriteAll;
