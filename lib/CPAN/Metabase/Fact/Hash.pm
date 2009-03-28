package CPAN::Metabase::Fact::Hash;
use base 'CPAN::Metabase::Fact';
use JSON ();

sub content_as_bytes {
  my ($self) = @_;
  return JSON::to_json($self->content);
}

sub content_from_bytes { 
  my ($class, $bytes) = @_;
  return JSON::from_json($bytes);
}

1;
