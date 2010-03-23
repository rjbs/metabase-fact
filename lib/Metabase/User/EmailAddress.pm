use 5.006;
use strict;
use warnings;
package Metabase::User::EmailAddress;
# ABSTRACT: Metabase fact for user email address

use base 'Metabase::Fact::String';
  
1;

__END__

=head1 SYNOPSIS

  my $email = Metabase::User::EmailAddress->new(
    resource => 'metabase:user:B66C7662-1D34-11DE-A668-0DF08D1878C0',
    content => 'jdoe@example.com',
  );

=head1 DESCRIPTION

This is a simple string fact meant to be used to represent the email address of
a user.

At present, no email address validation is performed, but this may change in
the future.

=head1 BUGS

Please report any bugs or feature using the CPAN Request Tracker.  
Bugs can be submitted through the web interface at 
L<http://rt.cpan.org/Dist/Display.html?Queue=Metabase-Fact>

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

=cut
