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
use JSON ();
use base 'CPAN::Metabase::Fact';

our $VERSION = '0.001';
$VERSION = eval $VERSION; # convert '1.23_45' to 1.2345

#--------------------------------------------------------------------------#
# abstract methods -- fatal
#--------------------------------------------------------------------------#

sub report_spec {
  my $self = shift;
  Carp::confess "report_spec() not implemented by " . ref $self;
}

#--------------------------------------------------------------------------#
# alternate constructor methods
#--------------------------------------------------------------------------#

# adapted from Fact::new() -- must keep in sync
# content field is optional -- should other fields be optional at this
# stage?  Maybe we shouldn't let any fields be optional

sub open {
  my ($class, @args) = @_;
  
  my %args = Params::Validate::validate( @args, { 
      ( map { $_ => 1 } qw/resource/ ), 
      ( map { $_ => 0 } qw/content/ ),
    }
  );
  if ( $args{content} && ref $args{content} ne 'ARRAY' ) {
    Carp::confess( "'content' argument to $class\->new() must be an array reference" );
  }
  $args{content} ||= [];

  # create and check
  my $self = bless \%args, $class;

  # generated attributes
  $self->type( $class->type );
  $self->version( $class->schema_version );

  return $self;
}

sub add {
  my ($self, $fact_class, $content ) = @_;
  my $fact = $fact_class->new( 
    resource => $self->resource, 
    content  => $content,
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

#--------------------------------------------------------------------------#
# implement required abstract Fact methods
#--------------------------------------------------------------------------#

sub content_as_bytes { 
  my $self = shift;
  my $content = [ map { $_->as_struct } @{ $self->content } ];
  JSON->new->encode( $content );
}

sub content_from_bytes { 
  my ($self, $string) = @_;
  $string = $$string if ref $string;

  my $fact_structs = JSON->new->decode( $string );

  my @facts;
  for my $struct (@$fact_structs) {
    (my $class = $struct->{core_metadata}{type}[1]) =~ s/-/::/g;
    push @facts, $class->from_struct($struct);
  }

  return \@facts;
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

CPAN::Metabase::Report is itself a subclass of CPAN::Metabase::Fact and 
offers the same API, except as described below.

=head1 USAGE

[Talk about how to subclass...]

=head1 ATTRIBUTES

=head3 content

The 'content' attribute of a Report must be a reference to an array of 
CPAN::Metabase::Fact subclass objects.

=head1 METHODS

In addition to the standard C<new()> constructor, the following C<open()>,
C<add()> and C<close()> methods may be used to construct a report piecemeal,
instead.

=head2 open()

  $report = Report::Subclass->open(
    id => 'AUTHORID/Foo-Bar-1.23.tar.gz',
  );

Constructs a new, empty report. The 'id' attribute is required.  The
'refers_to' attribute is optional.  The 'content' attribute may be provided,
but see C<add()> below. No other attributes may be provided to new().

=head2 add()

  $report->add( 'Fact::Subclass' => $content );

Using the 'id' attribute of the report, this method constructs a new Fact from
a class and a content argument.  The resulting Fact is appended to the Report's
content array.

=head3 close()

  $report->close;

This method validates the report based on all Facts added so far.

=head1 ABSTRACT METHODS

Methods marked as 'required' must be implemented by a report subclass.  (The
version in CPAN::Metabase::Report will die with an error if called.)  

In the documentation below, the terms 'must, 'must not', 'should', etc. have
their usual RFC meanings.

Methods MUST throw an exception if an error occurs.

=head2 report_spec() (required)

  $spec = Report::Subclass->report_spec;

The C<report_spec> method MUST return a hash reference that defines how
many Facts of which types must be in the report for it to be considered valid.
Keys MUST be class names.  Values MUST be non-negative integers that indicate
the number of Facts of that type that must be present for a report to be
valid, optionally followed by a '+' character to indicate that the report
may contain more than the given number.

For example:

  {
    Fact::One => 1,     # one of Fact::One
    Fact::Two => "0+",  # zero or more of Fact::Two
  }

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

