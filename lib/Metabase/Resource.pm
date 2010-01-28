package Metabase::Resource;
use 5.006;
use strict;
use warnings;
use Carp ();

our $VERSION = '0.001';
$VERSION = eval $VERSION;

#--------------------------------------------------------------------------#
# main API methods -- shouldn't be overridden
#--------------------------------------------------------------------------#

use overload ('""'     => sub { $_[0]->content },
              '=='     => sub { _obj_eq(@_) },
              '!='     => sub { !_obj_eq(@_) },
              fallback => 1,
             );

# Check if two objects are the same object
sub _obj_eq {
    return overload::StrVal($_[0]) eq overload::StrVal($_[1]);
}

sub new {
  my ($class, $resource) = @_;
  Carp::confess("no resource string provided")
    unless defined $resource && length $resource;

  # parse scheme
  my ($scheme) = $resource =~ m{\A([^:]+):};
  Carp::confess("could not determine URI scheme from '$resource'\n")
    unless defined $scheme && length $scheme;

  # load subclass
  my $subclass = "Metabase::Resource::$scheme";
  eval "require $subclass; 1"
    or Carp::confess("Could not load '$subclass': $@");

  # construct & validate subclass object
  my $self = { 
    content => $resource,
    scheme  => $scheme,
    _cache  => {},
  };
  bless $self, $subclass;
  $self->validate;

  return $self;
}

sub content {
  return $_[0]->{content}
}

sub scheme {
  return $_[0]->{scheme}
}

sub _cache {
  return $_[0]->{_cache}
}

#--------------------------------------------------------------------------#
# abstract methods -- fatal
#--------------------------------------------------------------------------#

sub validate {
  my ($self) = @_;
  Carp::confess "validate not implemented by " . (ref $self || $self)
}

sub metadata {
  my ($self) = @_;
  Carp::confess "metadata not implemented by " . (ref $self || $self)
}

sub metadata_types {
  my ($self) = @_;
  Carp::confess "metadata_types not implemented by " . (ref $self || $self)
}

1;

__END__

=head1 NAME

Metabase::Resource - factory class for Metabase resource descriptors

=head1 SYNOPSIS

  my $resource = Metabase::Resource->new(
    'cpan:///distfile/RJBS/Metabase-Fact-0.001.tar.gz',
  );

  my $resource_meta = $resource->metadata();

=head1 DESCRIPTION

L<Metabase> is a framework for associating metadata with arbitrary resources.
A Metabase can be used to store test reports, reviews, coverage analysis
reports, reports on static analysis of coding style, or anything else for which
datatypes are constructed.

Metabase::Resource is a factory class for resource descriptors. It provide
a common interface to extract resource-type-specific metadata from
resource subclasses.

Resources in Metabase are URI's that consist of a scheme and scheme 
specific information.  For example, a standard URI framework for a 
CPAN distribution is provided by the L<URI::cpan> class.

  cpan:///distfile/RJBS/URI-cpan-1.000.tar.gz

The L<Metabase::Resource::cpan> class will deconstruct this into a Metabase
resource metadata structure with the following elements:

  scheme       => cpan
  type         => distfile
  author       => RJBS
  dist_name    => URI-cpan
  dist_version => 1.000

=head1 METHODS

=head2 new

  my $resource = Metabase::Resource->new(
    'cpan:///distfile/RJBS/Metabase-Fact-0.001.tar.gz',
  );

Takes a single resource string argument and constructs a new Resource object
from a resource type determined by the URI scheme.  Throws an error if the
required resource subclass is not available.

=head2 content

Returns the string used to initialize the resource object.

=head1 OVERLOADING

Resources have stringification overloaded to call C<content>.  Equality
(==) and inequality (!=) are overloaded to perform string comparison instead.

=head1 SUBCLASSING

Metabase::Resource relies on subclasses to implement scheme-specific parsing
of the URI into relevant metadata.

Subclasses SHOULD NOT implement a C<new> constructor, as the Metabase::Resource
constructor will rebless the object into the appropriate subclass and then
call C<validate> on the object.

Subclasses SHOULD use the C<content> method to access the resource string.

All subclasses MUST implement the C<validate> and C<metadata> methods.

Methods MUST throw an exception if an error occurs.

=head2 validate

  $resource->validate

This method is called by the constructor.  It MUST return true if the resource
string is valid according to scheme-specific rules.  It MUST die if the
resource string is invalid.

=head2 metadata

  $meta = $resource->metadata;

This method MUST return a hash reference with resource-specific indexing
metadata for the Resource.  The key MUST be the name of the field for indexing.

Hash values MUST be an array_ref containing a type and the value for either
simple scalars (strings or numbers) or array references.  Type MUST be one
of:

  //str
  //num

It MUST return C<undef> if no content-specific metadata is available.

Here is a hypothetical example of content metadata for a metabase user
resource like 'metabase:user:ec2726a4-070c-11df-a2e0-0018f34ec37c':

  sub metadata {
    my $self = shift;
    my ($uuid) = $self =~ m{\Ametabase:user:(.+)\z};
    return unless $uuid;
    return {
      scheme  => [ '//str' => 'metabase' ],
      type    => [ '//str' => 'user' ],
      user    => [ '//str' => 'ec2726a4-070c-11df-a2e0-0018f34ec37c' ],
    }
  }

=head1 BUGS

Please report any bugs or feature using the CPAN Request Tracker.
Bugs can be submitted through the web interface at
L<http://rt.cpan.org/Dist/Display.html?Queue=Metabase-Resource>

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

=head1 AUTHOR

=over

=item * David A. Golden (DAGOLDEN)

=back

=head1 COPYRIGHT AND LICENSE

  Copyright (c) 2010 by David A. Golden and Contributors

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

