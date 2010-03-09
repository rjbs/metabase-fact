package Metabase::Resource::metabase;
use 5.006;
use strict;
use warnings;
use Carp ();

our $VERSION = '0.003';
$VERSION = eval $VERSION;

use Metabase::Resource;
our @ISA = qw(Metabase::Resource);

my $hex = '[0-9a-f]';
my $guid_re = qr(\A$hex{8}-$hex{4}-$hex{4}-$hex{4}-$hex{12}\z)i;

sub _validate_guid {
  my ($self, $string) = @_;
  if ( $string !~ $guid_re ) {
    Carp::confess("'$string' is not formatted as a GUID string");
  }
  return $string;
}

sub _init {
  my ($self) = @_;
  my $scheme = $self->scheme;

  # determine subtype
  my ($subtype) = $self =~ m{\A$scheme:([^:]+)};
  Carp::confess("could not determine URI subtype from '$self'\n")
    unless defined $subtype && length $subtype;
  $self->_add( subtype => '//str' =>  $subtype);

  # rebless into subclass and finish initialization
  my $subclass = __PACKAGE__ . "::$subtype";
  $self->_load($subclass);
  bless $self, $subclass;
  return $self->_init;
}

1;

__END__

=head1 NAME

Metabase::Resource::metabase - class for Metabase resources

=head1 SYNOPSIS

  my $resource = Metabase::Resource->new(
    "metabase:user:B66C7662-1D34-11DE-A668-0DF08D1878C0"
  );

  my $resource_meta = $resource->metadata;
  my $typemap       = $resource->metadata_types;

=head1 DESCRIPTION

Generates resource metadata for resources of the scheme 'metabase'.

The L<Metabase::Resource::metabase> class supports the followng sub-type(s).

=head2 fact 

  my $resource = Metabase::Resource->new(
    "metabase:fact:bd83d51e-0eea-11df-8413-0018f34ec37c"
  );

This resource is for a generic Metabase Fact.  (I.e. for a Fact about another
Fact).  For the example above, the resource metadata structure would contain
the following elements:

  scheme       => metabase
  type         => user
  fact         => bd83d51e-0eea-11df-8413-0018f34ec37c

=head2 user

  my $resource = Metabase::Resource->new(
    "metabase:user:b66c7662-1d34-11de-a668-0df08d1878c0"
  );

This resource is for a Metabase user. (I.e. corresponding to the GUID of a
Metabase::User::Profile.) For the example above, the resource metadata
structure would contain the following elements:

  scheme       => metabase
  subtype      => user
  user         => b66c7662-1d34-11de-a668-0df08d1878c0

=head1 BUGS

Please report any bugs or feature using the CPAN Request Tracker.
Bugs can be submitted through the web interface at
L<http://rt.cpan.org/Dist/Display.html?Queue=Metabase-Fact>

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

=head1 AUTHOR

Primary Authors and other Contributors are listed below:

  * David A. Golden (DAGOLDEN)
  * Ricardo Signes  (RJBS)

=head1 COPYRIGHT AND LICENSE

  Copyright (c) 2010 by David A. Golden, Ricardo Signes and Contributors

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

