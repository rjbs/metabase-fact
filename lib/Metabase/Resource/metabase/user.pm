package Metabase::Resource::metabase::user;
use 5.006;
use strict;
use warnings;
use Carp ();

our $VERSION = '0.004';
$VERSION = eval $VERSION;

use Metabase::Resource::metabase;
our @ISA = qw(Metabase::Resource::metabase);

sub _init {
  my ($self) = @_;
  my ($scheme, $subtype) = ($self->scheme, $self->subtype);
  my ($guid) = $self =~ m{\A$scheme:$subtype:(.+)\z};
  Carp::confess("could not determine guid from '$self'\n")
    unless defined $guid && length $guid;
  $self->_add( guid => '//str' =>  $guid);
  return $self;
}

sub validate {
  my $self = shift;
  $self->_validate_guid( $self->guid );
  return 1;
}

1;

__END__

=head1 NAME

Metabase::Resource::metabase::user - class for Metabase user profiles

=head1 SYNOPSIS

  my $resource = Metabase::Resource->new(
    "metabase:user:B66C7662-1D34-11DE-A668-0DF08D1878C0"
  );

  my $resource_meta = $resource->metadata;
  my $typemap       = $resource->metadata_types;

  my $user_id = $resource->guid;

=head1 DESCRIPTION

This resource is for a Metabase user. (I.e. corresponding to the GUID of a
Metabase::User::Profile.) For the example above, the resource metadata
structure would contain the following elements:

  scheme       => metabase
  type         => user
  guid         => b66c7662-1d34-11de-a668-0df08d1878c0

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

