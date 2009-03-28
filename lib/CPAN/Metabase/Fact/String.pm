package CPAN::Metabase::Fact::String;
use base 'CPAN::Metabase::Fact';
use Encode ();

# document that content must be characters, not bytes -- dagolden, 2009-03-28 

sub content_as_bytes {
  my ($self) = @_;
  return Encode::encode_utf8($self->content);
}

sub content_from_bytes { 
  my ($class, $bytes) = @_;
  return Encode::decode_utf8($bytes);
}

1;

