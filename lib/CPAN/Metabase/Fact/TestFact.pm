package CPAN::Metabase::Fact::TestFact;
use base 'CPAN::Metabase::Fact';

use Storable ();
use Carp ();

sub validate_content {
  my ($self) = @_;
  Carp::croak "plain scalars only please" if ref $self->content;
  Carp::croak "non-empty scalars please"  if ! length $self->content;
}

sub content_as_string {
  my ($self) = @_;

  return Storable::nfreeze( \($self->content) );
}

sub content_from_string { 
  my ($class, $string) = @_;

  $string = $$string if ref $string;

  return ${Storable::thaw( $string )};
}

1;
