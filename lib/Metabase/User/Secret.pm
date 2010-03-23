use 5.006;
use strict;
use warnings;
package Metabase::User::Secret;
# ABSTRACT: Metabase fact for user shared authentication secret

use base 'Metabase::Fact::String';

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  $self->set_creator($self->resource) unless $self->creator;
  return $self;
}

1;

__END__


=head1 SYNOPSIS

  my $secret = Metabase::User::Secret->new(
    resource => 'metabase:user:B66C7662-1D34-11DE-A668-0DF08D1878C0',
    content  => 'aixuZuo8',
  );

=head1 DESCRIPTION

This fact is a simple string, storing the shared secret that will be used to
authenticate user during fact submission.

=head1 BUGS

Please report any bugs or feature using the CPAN Request Tracker.
Bugs can be submitted through the web interface at
L<http://rt.cpan.org/Dist/Display.html?Queue=Metabase-Fact>

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

=cut

