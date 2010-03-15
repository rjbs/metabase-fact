package Metabase::User::Secret;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.006';
$VERSION = eval $VERSION; ## no critic

use base 'Metabase::Fact::String';

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  $self->set_creator($self->resource) unless $self->creator;
  return $self;
}

1;

__END__

=head1 NAME

Metabase::User::Secret - Metabase fact for user shared authentication secret

=head1 SYNOPSIS

  my $secret = Metabase::User::Secret->new(
    resource => 'metabase:user:B66C7662-1D34-11DE-A668-0DF08D1878C0',
    content  => 'aixuZuo8',
  );

=head1 DESCRIPTION

This fact is a simple string, storing the shared secret that will be used to
authenticate user during fact submission.

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

Copyright (c) 2009-2010 by David A. Golden and Contributors.

Licensed under the same terms as Perl itself (the "License").  You may not use
this file except in compliance with the License.  A copy of the License was
distributed with this file or you may obtain a copy of the License from
http://dev.perl.org/licenses/

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See the License for the
specific language governing permissions and limitations under the License.

=cut

