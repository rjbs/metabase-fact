package CPAN::Metabase::Fact::Hash;
use base 'CPAN::Metabase::Fact';

use Carp ();

sub content_as_struct {
  my ($self) = @_;
  return $self->content;
}

sub content_from_struct { 
  my ($class, $struct) = @_;
  return $stuct;
}

1;
