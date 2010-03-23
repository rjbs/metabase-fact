use 5.006;
use strict;
use warnings;
package Metabase::User::FullName;
# ABSTRACT: Metabase fact for user full name

use base 'Metabase::Fact::String';
  
1;

__END__

=head1 SYNOPSIS

  my $email = Metabase::User::FullName->new(
    resource => 'metabase:user:B66C7662-1D34-11DE-A668-0DF08D1878C0',
    content => 'John Doe',
  );

=head1 DESCRIPTION

This is just a simple string fact that stores the real name of a user in his
profile.

=head1 BUGS

Please report any bugs or feature using the CPAN Request Tracker.  
Bugs can be submitted through the web interface at 
L<http://rt.cpan.org/Dist/Display.html?Queue=Metabase-Fact>

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

=cut

