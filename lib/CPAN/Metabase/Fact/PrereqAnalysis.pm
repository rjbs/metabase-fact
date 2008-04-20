use strict;
use warnings;
package CPAN::Metabase::Fact::PrereqAnalysis;
use base 'CPAN::Metabase::Fact';

use JSON::XS ();

my $json = JSON::XS->new();

sub content_as_string {
  my ($self) = @_;
  return $json->encode($self->content);
}

sub content_from_string {
  my ($self, $string) = @_;

  $json->decode($string);
}

sub validate_content {
  my ($self) = @_;

  # XXX: Make this betterer. -- rjbs, 2008-04-08
  die "must be a hashref" unless ref $self->content eq 'HASH';
}

1;
