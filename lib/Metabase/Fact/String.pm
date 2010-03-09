package Metabase::Fact::String;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.003';
$VERSION = eval $VERSION;

use base 'Metabase::Fact';
use Carp ();
use Encode ();

# document that content must be characters, not bytes -- dagolden, 2009-03-28 

sub validate_content {
  my ($self) = @_;
  Carp::confess "content must be scalar value" 
    unless defined $self->content && ref \($self->content) eq 'SCALAR';
}

sub content_as_bytes {
  my ($self) = @_;
  return Encode::encode_utf8($self->content);
}

sub content_from_bytes { 
  my ($class, $bytes) = @_;
  return Encode::decode_utf8($bytes);
}

1;

__END__

=head1 NAME

Metabase::Fact::String - fact subtype for simple strings

=head1 SYNOPSIS

  # defining the fact class
  package MyFact;
  use base 'Metabase::Fact::String';

  sub content_metadata {
    my $self = shift;
    return {
      'size' => [ '//num' => length $self->content ],
    };
  }

  sub validate_content {
    my $self = shift;
    $self->SUPER::validate_content;
    die __PACKAGE__ . " content length must be greater than zero\n"
      if length $self->content < 0;
  }

...and then...

  # using the fact class
  my $fact = MyFact->new(
    resource => 'RJBS/Metabase-Fact-0.001.tar.gz',
    content  => "Hello World",
  );

  $client->send_fact($fact);

=head1 DESCRIPTION

Base class for facts that are just strings of text.  Strings must be
characters, not bytes.

You may wish to implement a C<content_metadata> method to generate metadata
about the hash contents.

You should also implement a C<validate_content> method to validate the
structure of the hash you're given.

=head1 BUGS

Please report any bugs or feature using the CPAN Request Tracker.  
Bugs can be submitted through the web interface at 
L<http://rt.cpan.org/Dist/Display.html?Queue=Metabase-Fact>

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

=head1 AUTHOR

=over 

=item * David A. Golden (DAGOLDEN)

=item * Ricardo J. B. Signes (RJBS)

=back

=head1 COPYRIGHT AND LICENSE

 Portions copyright (c) 2008-2009 by David A. Golden
 Portions copyright (c) 2008-2009 by Ricardo J. B. Signes

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
