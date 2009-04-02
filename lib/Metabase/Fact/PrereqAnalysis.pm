package CPAN::Metabase::Fact::PrereqAnalysis;
use 5.006;
use strict;
use warnings;
use base 'CPAN::Metabase::Fact';

use Storable ();

sub content_as_bytes {
  my ($self) = @_;
  return Storable::nfreeze($self->content);
}

sub content_from_bytes {
  my ($self, $bytestring) = @_;
  $bytestring = $$bytestring if ref $bytestring;
  return Storable::thaw($bytestring);
}

sub validate_content {
  my ($self) = @_;

  # XXX: Make this betterer. -- rjbs, 2008-04-08
  die "must be a hashref" unless ref $self->content eq 'HASH';
}

sub content_metadata {
  my ($self) = @_;

  return { requires => [ keys %{ $self->content } ] };
}

1;
