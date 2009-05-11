use strict;
use warnings;

use Test::More;
use Test::Exception;
use File::Spec;
use File::Temp;

#--------------------------------------------------------------------------#
# fixtures
#--------------------------------------------------------------------------#

sub _compare {
  my ($report1, $report2) = @_;
  is( $report1->core_metadata->{resource}[1], 
      $report2->core_metadata->{resource}[1],
      "Checking URI");
  is ( $report1->guid,  $report2->guid, "Checking GUID" );
  for my $i ( 0 .. 2 ) {
    is_deeply( $report1->{content}[$i]->as_struct, 
        $report2->{content}[$i]->as_struct,
        "Checking fact $i",
    );
  }
  return 1;
}

#--------------------------------------------------------------------------#
# start testing
#--------------------------------------------------------------------------#

plan 'no_plan';

require_ok( 'Metabase::User::Profile' );

#--------------------------------------------------------------------------#
# new profile creation
#--------------------------------------------------------------------------#

my $profile;

lives_ok {
  $profile = Metabase::User::Profile->create(
    full_name => "John Doe",
    email_address => 'jdoe@example.com',
    secret => '1234567890',
  );
} "create new profile";

isa_ok($profile, 'Metabase::User::Profile');

#--------------------------------------------------------------------------#
# save and load profiles
#--------------------------------------------------------------------------#

my $tempdir = File::Temp::tempdir( CLEANUP => 1 );

my $profile_file = File::Spec->catfile( $tempdir, 'profile.json' );

$profile->save( $profile_file );

ok( -r $profile_file, 'profile saved to file' );

my $profile_copy = Metabase::User::Profile->load( $profile_file );
ok( $profile_copy, "Loaded profile file (created with ->create)" );
isa_ok($profile_copy, 'Metabase::User::Profile');

_compare( $profile, $profile_copy );

# try profile-generator
my $profile_file2 = File::Spec->catfile( $tempdir, 'myprofile.json' );
my $bin = File::Spec->catfile( qw/bin metabase-profile/ );
qx/$^X $bin -o $profile_file2 --name "JohnPublic" --email jp\@example.com --secret 3.14159/;
ok( -r $profile_file2, 'created  profile with metabase-profile' );
my $profile_copy2 = Metabase::User::Profile->load( $profile_file2 );
ok( $profile_copy2, "Loaded profile file" );
