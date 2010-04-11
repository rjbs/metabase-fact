use 5.006;
use strict;
use warnings;
package Metabase::Resource::perl::commit;
# ABSTRACT: class for Metabase resources about perl commits

use Carp ();

use base 'Metabase::Resource::perl';

my %metadata_types = (
  sha1          => '//str',
);

sub _init {
  my ($self) = @_;
  my ($scheme, $subtype) = ($self->scheme, $self->subtype);

  my ($string) = $self =~ m{\A$scheme:///$subtype/(.+)\z};
  Carp::confess("could not determine commit from '$self'\n")
    unless defined $string && length $string;

  my $sha1 = $1;
  Carp::confess("illegal commit hash")
    unless $sha1 =~ m/^[a-f0-9]+$/;

  $self->_add( 'sha1' => $metadata_types{sha1} => $sha1 );

  return $self;
}

sub full_url {
  my ($self, $host) = @_;
  $host ||= 'perl5.git.perl.org';
  return "http://${host}/perl.git/" . $self->sha1;
}

# 'commit' validates during _init, really
sub validate { 1 }

=pod

=head1 SYNOPSIS

  my $resource = Metabase::Resource->new(
    'perl:///commit/8c576062',
  );

  my $resource_meta = $resource->metadata;
  my $typemap       = $resource->metadata_types;
  my $url = $self->full_url;

=head1 DESCRIPTION

Generates resource metadata for resources of the scheme 'perl:///commit'.

  my $resource = Metabase::Resource->new(
    'perl:///commit/8c576062',
  );

For the example above, the resource metadata structure would contain the
following elements:

  scheme       => perl
  type         => commit
  sha1         => 8c576062

=head1 BUGS

Please report any bugs or feature using the CPAN Request Tracker.
Bugs can be submitted through the web interface at
L<http://rt.cpan.org/Dist/Display.html?Queue=Metabase-Fact>

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

=cut

__END__





