use strict;
use warnings;
package CPAN::Metabase::Fact::PrereqAnalysis;
use base 'CPAN::Metabase::Fact';

use Storable ();

sub content_as_string {
  my ($self) = @_;
  return Storable::nfreeze($self->content);
}

sub content_from_string {
  my ($self, $string) = @_;
  $string = $$string if ref $string;
  return Storable::thaw($string);
}

sub validate_content {
  my ($self) = @_;

  # XXX: Make this betterer. -- rjbs, 2008-04-08
  die "must be a hashref" unless ref $self->content eq 'HASH';
}

sub meta_from_content {
  my ($self) = @_;

  return { requires => [ keys %{ $self->content } ] };
}

1;
