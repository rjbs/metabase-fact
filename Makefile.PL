require 5.006;
use inc::Module::Install;
all_from('lib/Metabase/Fact.pm');

requires      ('CPAN::DistnameInfo'           => 0.09    );
requires      ('Carp'                         => 0       );
requires      ('Data::GUID'                   => 0.045   );
requires      ('Encode'                       => 2.35    );
requires      ('JSON'                         => 2.17    );
requires      ('Time::Piece'                  => 1.15    );
requires      ('base'                         => 2.14    );
requires      ('overload'                     => 1.07    );
build_requires('Cwd'                          => 3.31    );
build_requires('File::Find'                   => 0       );
build_requires('File::Spec'                   => 3.31    );
build_requires('File::Temp'                   => 0.20    );
build_requires('Test::Exception'              => 0.27    );
build_requires('Test::More'                   => 0.88    );
build_requires('perl'                         => 5.006   );

install_script('bin/metabase-profile');
 
auto_manifest;
extra_tests;
tests_recursive;

WriteAll;
