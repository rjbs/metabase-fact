package Metabase::User::EmailAddress;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.007';
$VERSION = eval $VERSION; ## no critic

use base 'Metabase::Fact::String';
  
1;

__END__

=head1 NAME

Metabase::User::EmailAddress - Metabase fact for user email address

=head1 SYNOPSIS

  my $email = Metabase::User::EmailAddress->new(
    resource => 'metabase:user:B66C7662-1D34-11DE-A668-0DF08D1878C0',
    content => 'jdoe@example.com',
  );

=head1 DESCRIPTION

This is a simple string fact meant to be used to represent the email address of
a user.

At present, no email address validation is performed, but this may change in
the future.

=head1 BUGS

Please report any bugs or feature using the CPAN Request Tracker.  
Bugs can be submitted through the web interface at 
L<http://rt.cpan.org/Dist/Display.html?Queue=Metabase-Fact>

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

=head1 AUTHOR

=over 

=item * David A. Golden (DAGOLDEN)

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009 by David A. Golden

Licensed under the same terms as Perl itself (the "License").  You may not use
this file except in compliance with the License.  A copy of the License was
distributed with this file or you may obtain a copy of the License from
http://dev.perl.org/licenses/

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See the License for the
specific language governing permissions and limitations under the License.

=cut

