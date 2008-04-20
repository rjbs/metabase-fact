# Copyright (c) 2008 by Ricardo Signes and David A. Golden. All rights reserved.
# Licensed under terms of Perl itself (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://dev.perl.org/licenses/

package CPAN::Metabase::Report;
use 5.006;
use strict;
use warnings;
use Params::Validate ();
use Carp ();
use JSON::XS ();
use base 'CPAN::Metabase::Fact';

our $VERSION = '0.001';
$VERSION = eval $VERSION; # convert '1.23_45' to 1.2345

#--------------------------------------------------------------------------#
# class methods
#--------------------------------------------------------------------------#

sub schema_version() { 1 }

sub report_spec {
  my $self = shift;
  Carp::confess "report_spec() not implemented by " . ref $self;
}

#--------------------------------------------------------------------------#
# fatal stubs
#--------------------------------------------------------------------------#

sub content_as_string { 
  my $self = shift;
  Carp::confess "content_as_string() not implemented by " . ref $self;
#  my $json = JSON::XS->new;
#  my $clone = { %$self };
#    for my $fact ( @[ $clone->content ] ){
#        $fact = $json->allow_blessed->
#    }
}

sub content_from_string { 
  my $self = shift;
  Carp::confess "content_from_string() not implemented by " . ref $self;
}

#--------------------------------------------------------------------------#
# methods
#--------------------------------------------------------------------------#

# adapted from Fact::new() -- must keep in sync
# content field is optional -- should other fields be optional at this
# stage?  Maybe we shouldn't let any fields be optional

sub open {
  my ($class, @args) = @_;
  
  my %args = Params::Validate::validate( @args, { 
      ( map { $_ => 1 } qw/id/ ), 
      ( map { $_ => 0 } qw/content/ ),
    }
  );

  # create and check
  my $self = bless \%args, $class;

  return $self;
}

sub add {
  my ($self, $fact_class, @args ) = @_;
  my $fact = $fact_class->new( 
    id => $self->id,
    @args
  );
  push @{$self->{content}}, $fact;
  return $self;
}

# close just validates -- otherwise unnecessary
sub close {
  my ($self) = @_;
  my $class = ref $self;
  eval { $self->validate_content( $self->content ) };
  if ($@) {
    Carp::confess( "$class object content invalid: $@" );
  }
  return $self;
}

sub validate_content {
  my ($self, $content) = @_;
  my $spec = $self->report_spec;
  die ref $self . " content must be an array reference of Fact object"
  unless ref $content eq 'ARRAY';

  my @fact_matched;
  # check that each spec matches
  for my $k ( keys %$spec ) {
    $spec->{$k} =~ m{^(\d+)(\+)?$};
    my $minimum = defined $1 ? $1 : 0;
    my $exact   = defined $2 ?  0 : 1; # exact unless "+"
    # mark facts that match a spec
    my $found = 0;
    for my $i ( 0 .. @$content - 1 ) {
      if ( $content->[$i]->isa( $k ) ) {
        $found++;
        $fact_matched[$i] = 1;
      }
    }
    if ( $exact ) {
      die "expected $minimum of $k, but found $found\n"
      if $found != $minimum;
    }
    else {
      die "expected at least $minimum of $k, but found $found\n"
      if $found < $minimum;
    }
  }

  # any facts that didn't match anything?
  my $unmatched = grep { ! $_ } @fact_matched;
  die "$unmatched fact(s) not in the spec\n" 
  if $unmatched;

  return;
}

1;

__END__

=head1 NAME

CPAN::Metabase::Report - a collection of CPAN::Metabase facts

=head1 SYNOPSIS


=head1 DESCRIPTION

L<CPAN::Metabase|CPAN::Metabase> is a system for associating metadata with CPAN
distributions.  The metabase can be used to store test reports, reviews,
coverage analysis reports, reports on static analysis of coding style, or
anything else for which datatypes are constructed.

CPAN::Metabase::Report is a base class for collections of CPAN::Metabase::Fact
objects that can be sent to or retrieved from a CPAN::Metabase system.

=head1 USAGE

Usage...

=head1 BUGS

Please report any bugs or feature using the CPAN Request Tracker.  
Bugs can be submitted through the web interface at 
L<http://rt.cpan.org/Dist/Display.html?Queue=CPAN-Metabase-Fact>

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

=head1 AUTHOR

=over 

=item * David A. Golden (DAGOLDEN)

=item * Ricardo J. B. Signes (RJBS)

=back

=head1 COPYRIGHT AND LICENSE

 Portions copyright (c) 2008 by David A. Golden
 Portions copyright (c) 2008 by Ricardo J. B. Signes

Licensed under the same terms as Perl itself (the "License").
You may not use this file except in compliance with the License.
A copy of the License was distributed with this file or you may obtain a 
copy of the License from http://dev.perl.org/licenses/

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

