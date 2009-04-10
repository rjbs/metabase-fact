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
      $report2->core_metadata->{resource}[1] );
  is ( $report1->guid,  $report2->guid );
  for my $i ( 0 .. 2 ) {
    is( $report1->{content}[$i]->content_as_bytes, 
        $report2->{content}[$i]->content_as_bytes
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
isa_ok($profile_copy, 'Metabase::User::Profile');

_compare( $profile, $profile_copy );

