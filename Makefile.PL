require 5.006;
use inc::Module::Install;
all_from('lib/Metabase/Fact.pm');

requires ('CPAN::DistnameInfo'           => 0       );
requires ('Carp'                         => 0       );
requires ('Data::GUID'                   => 0       );
requires ('JSON'                         => 2       );
build_requires('Cwd'                          => 0       );
build_requires('File::Find'                   => 0       );
build_requires('File::Spec'                   => 0       );
build_requires('File::Temp'                   => 0.20    );
build_requires('Test::Exception'              => 0       );
build_requires('Test::More'                   => 0.88    );
build_requires('perl'                         => 5.006   );

install_script('bin/metabase-profile');
 
auto_manifest;
extra_tests;
tests_recursive;

WriteAll;
