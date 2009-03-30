# Copyright (c) 2009 by David Golden. All rights reserved.
# Licensed under terms of Perl itself (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://dev.perl.org/licenses/

package CPAN::Metabase::User::Profile;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.001';
$VERSION = eval $VERSION; ## no critic

use base 'CPAN::Metabase::Report';

use CPAN::Metabase::User::EmailAddress;
use CPAN::Metabase::User::FullName;
use CPAN::Metabase::User::Secret;

sub report_spec { 
  return {
    'CPAN::Metabase::User::EmailAddress'  => '1+',
    'CPAN::Metabase::User::FullName'      => '1',
    'CPAN::Metabase::User::Secret'        => '1',
  }
}
  
1;

__END__

=head1 NAME

CPAN::Metabase::User::Profile - Metabase report class for user-related facts

=head1 SYNOPSIS

  my $profile = CPAN::Metabase::User::Profile->open(
    resource => 'metabase:user:B66C7662-1D34-11DE-A668-0DF08D1878C0'
  );

  $profile->add( 'CPAN::Metabase::User::EmailAddress' => 'jdoe@example.com' );
  $profile->add( 'CPAN::Metabase::User::FullName'     => 'John Doe' );
  $profile->add( 'CPAN::Metabase::User::Secret'       => 'aixuZuo8' );
    
  $profile->close();

=head1 DESCRIPTION

Metabase report class encapsulating Facts about a metabase user

=head1 USAGE


=head1 BUGS

Please report any bugs or feature using the CPAN Request Tracker.  
Bugs can be submitted through the web interface at 
L<http://rt.cpan.org/Dist/Display.html?Queue=CPAN-Testers-Report>

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

=head1 AUTHOR

=over 

=item * David A. Golden (DAGOLDEN)

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009 by David A. Golden

Licensed under the same terms as Perl itself (the "License").
You may not use this file except in compliance with the License.
A copy of the License was distributed with this file or you may obtain a 
copy of the License from http://dev.perl.org/licenses/

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut



