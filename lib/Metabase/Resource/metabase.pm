package Metabase::Resource::metabase;
use 5.006;
use strict;
use warnings;
use Carp ();

our $VERSION = '0.001';
$VERSION = eval $VERSION;

our @ISA = qw(Metabase::Resource);

sub validate {
  my ($self) = @_;
  my $scheme = $self->scheme;
  my $content = $self->content;
  my ($type, $string) = $content =~ m{\A$scheme:([^:]+):(.+)\z};
  unless ( defined $type && length $type ) {
    Carp::confess("Could not determine $scheme subtype from '$content'")
  }
  $self->{type} = $type;
  my $method = "_validate_$type";
  if ( $self->can($method) ) {
    $self->$method($string);
  }
  else {
    Carp::confess("Unknown $scheme subtype '$type' in '$content'");
  }
  return 1;
}

my $hex = '[0-9a-f]';
my $guid_re = qr(\A$hex{8}-$hex{4}-$hex{4}-$hex{4}-$hex{12}\z)i;

sub _validate_user {
  my ($self, $string) = @_;
  if ( $string !~ $guid_re ) {
    Carp::confess("'$string' is not formatted as a GUID string");
  }
  $self->{string} = $string;
  return 1;
}

my %metadata_types = (
  user => {
    user    => '//str'
  },
);

sub metadata_types {
  my ($self) = @_;
  return {
    scheme  => '//str',
    %{ $metadata_types{ $self->{type} } },
  };
}

sub metadata {
  my ($self) = @_;
  my $method = "_metadata_$self->{type}";
  return {
    scheme => $self->scheme,
    %{ $self->$method },
  };
}

sub _metadata_user {
  my ($self) = @_;
  return {
    user => $self->{string},
  };
}

1;

__END__

=head1 NAME

Metabase::Resource::metabase - class for Metabase resources

=head1 SYNOPSIS

  my $resource = Metabase::Resource->new(
    "metabase:user:B66C7662-1D34-11DE-A668-0DF08D1878C0"
  );

  my $resource_meta = $resource->metadata();

=head1 DESCRIPTION

Generates resource metadata for resources of the scheme 'metabase:'.

The L<Metabase::Resource::metabase> class supports the followng sub-types.

=head2 user

  my $resource = Metabase::Resource->new(
    "metabase:user:B66C7662-1D34-11DE-A668-0DF08D1878C0"
  );

The resource metadata structure will contain the following elements:

  scheme       => metabase
  type         => user
  user         => B66C7662-1D34-11DE-A668-0DF08D1878C0

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

