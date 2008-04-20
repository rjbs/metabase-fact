# Copyright (c) 2008 by Ricardo Signes. All rights reserved.
# Licensed under terms of Perl itself (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License was distributed with this file or you may obtain a 
# copy of the License from http://dev.perl.org/licenses/

package CPAN::Metabase::Fact;
use 5.006;
use strict;
use warnings;
use Params::Validate ();
use Storable ();
use Carp ();

our $VERSION = '0.001';
$VERSION = eval $VERSION; # convert '1.23_45' to 1.2345

#--------------------------------------------------------------------------#
# accessors
#--------------------------------------------------------------------------#

# XXX should any accessors be read-only? -- DG, 04/08/2008

{ 
  my @accessors = qw(
    id refers_to version guid content index_meta content_meta
  );
  no strict 'refs';
  for my $s (@accessors) {
      *$s = sub { $_[0]->{$s} = $_[1] if $_[1]; $_[0]->{$s} };
  }
}

# object attribute or else convert class name
sub type {
  my $self = shift;
  if (ref $self) {
    $self->{type} = shift if @_;
    return $self->{type};
  }
  else {
    $self =~ s{::}{-}g;
    return $self;
  }
}

#--------------------------------------------------------------------------#
# main API methods -- shouldn't be overridden
#--------------------------------------------------------------------------#

sub new {
    my ($class, @args) = @_;

    my %args = Params::Validate::validate( @args, { 
        id => 1, content => 1, refers_to => 0 } 
    );
    
    # default/generated attributes
    $args{type}       = $class->type;
    $args{version}    = $class->schema_version;
    $args{refers_to}  ||= 'distribution';  # XXX for future 'author', 'module'

    my $self = bless \%args, $class;

    eval { $self->validate_content( $self->content ) };
    if ($@) {
        Carp::confess( "$class object content invalid: $@" );
    }

    return $self;
}

# defined 'submitted' as having both guid and index_meta fields
# XXX -- do we really still need this?  -- DG, 04/20/08
sub is_submitted {
    my ($self) = @_;
    return defined $self->guid && defined $self->index_meta;
}

# freeze content then freeze self
sub freeze {
  my ($self) = @_;
  local $self->{content} = $self->content_as_string;
  return Storable::nfreeze($self);
}

# thaw object then thaw content
# Call as CPAN::Metabase::Fact->thaw($data)
# XXX what should this do if the original class isn't available? Return
# undef? Warn? Die? -- DG, 04/20/08
sub thaw {
  my ($class, $data) = @_;
  my $self = Storable::thaw($data);
  $self->{content} = $self->content_from_string( $self->{content} );
  return $self
}

#--------------------------------------------------------------------------#
# class methods
#--------------------------------------------------------------------------#

# schema_version recorded in 'version' attribution during new()
# if format of content changes, class module should increment schema version
# to check: if ( $obj->version != $class->schema_version ) ...
sub schema_version() { 1 }

#--------------------------------------------------------------------------#
# abstract methods -- mostly fatal
#--------------------------------------------------------------------------#

sub content_as_string { 
    my $self = shift;
    Carp::confess "content_as_string() not implemented by " . ref $self;
}

sub content_from_string { 
    my $self = shift;
    Carp::confess "content_from_string() not implemented by " . ref $self;
}

sub meta_from_content { return }

sub validate_content {
    my ($self, $content) = @_;
    Carp::confess "validate_content() not implemented by " . ref $self;
}

1;

__END__

=head1 NAME

CPAN::Metabase::Fact - a fact in or for a CPAN metabase

=head1 SYNOPSIS

  my $fact = TestReport->new({
    id => 'RJBS/CPAN-Metabase-Fact-0.001.tar.gz',
    content     => {
      status => 'FAIL',
      time   => 3029,
    },
  });

  $client->send_fact($fact);

=head1 DESCRIPTION

L<CPAN::Metabase|CPAN::Metabase> is a system for associating metadata with CPAN
distributions.  The metabase can be used to store test reports, reviews,
coverage analysis reports, reports on static analysis of coding style, or
anything else for which datatypes are constructed.

CPAN::Metabase::Fact is a base class for facts (really opinions or analyses)
that can be sent to or retrieved from a CPAN::Metabase system.

=head1 ATTRIBUTES

=head2 Set during construction 

=head3 id (required)

The canonical CPAN ID the Fact relates to.  For distributions, this is the 
'AUTHOR/Distname-Version.Suffix' form used to install specific distributions
with CPAN.pm -- for example, 'TIMB/DBI-1.604.tar.gz' for the DBI distribution.

=head3 content (required)

A reference to the actual information associated with the fact.
The exact form of the content is up to each Fact class to determine.

=head3 refers_to (optional)

Defaults to 'distribution'.  At some point, should CPAN::Metabase be expanded
to support other CPAN objects, could be 'author', 'module', 'bundle' and 
so on.

=head2 Generated during construction

These attributes are generated automatically during the call to C<new()>.  

=head3 content_meta

If a Fact subclass provides a C<meta_from_content()> method, it will be used to
populate this attribute with a hash of content-specific key/value pairs to be
used during indexing.  For example, a CPAN Testers report Fact might provide a
'grade' key with a value indicating a test result of 'FAIL'. 

=head3 type

The object's class name, with double-colons converted to dashes to be more
URI-friendly.  E.g.  'CPAN::Metabase::Fact' would be 'CPAN-Metabase-Fact'.

=head3 version

The schema_version() of the Fact subclass that created the object. This may or
may not be the same as the current schema_version() of the class if newer
versions of the class have been released since the object was created.

=head2 Generated during indexing

These attributes should only be set or modified by a CPAN::Metabase::Index
object.  Thus, they are 'undef' when a fact is created, are populated when
indexed, and are available when a Fact is queried from a Metabase.

=head3 guid

A global, unique identifier for a particular Fact in a particular Metabase.

=head3 index_meta

A hash of simple key/value pairs used to index the Fact in a Metabase.  These
are content-independent, and will generally relate to the CPAN object the
Fact refers to (e.g. distribution name, author, or version) or to the 
submission of the fact (e.g. submitter name or timestamp).

=head1 METHODS

=head2 new()

  $fact = CPAN::Metabase::Fact::TestFact->new(
    id => 'AUTHORID/Foo-Bar-1.23.tar.gz',
    content => $content_structure,
  );

Constructs a new Fact. The 'id' and 'content' attributes are required.  The
'refers_to' attribute is optional and defaults to 'distribution'.  No other
attributes may be provided to new().

=head2 freeze()

 $frozen = $fact->freeze;

Serializes the Fact to a scalar value.  Relies on C<content_as_string> to
serialize the Fact's content.

=head2 thaw()

  $fact = CPAN::Metabase::Fact->thaw( $frozen );

Regenerates a Fact from its serialized form.  Relies on C<content_from_string>
to regenerated the Fact's content. 

While this should be called as a class function on CPAN::Metabase::Fact, the
object returned will be blessed into its original class.

=head1 CLASS METHODS

=head2 schema_version()

  $version = Fact::Subclass->schema_version;

Defaults to 1.  Subclasses should override this method if they make a
backwards-incompatible change to the internals of the content attribute.
Schema version numbers should be monotonically-increasing integers.

=head2 type()

  $type = Fact::Subclass->type;

If C<type()> is called as a class method, it returns the class name converted
to a type, just as with the 'type' attribute.

=head1 ABSTRACT METHODS

Methods marked as 'required' must be implemented by a Fact subclass.  (The
version in CPAN::Metabase::Fact will die with an error if called.)  

In the documentation below, the terms 'must, 'must not', 'should', etc. have
their usual RFC meanings.

These methods MUST throw an exception if an error occurs.

=head2 content_as_string() (required)

  $string = $fact->content_as_string;

This method MUST serialize a Fact's content to a string (e.g. using 
L<Storable>, L<JSON::XS>, L<Data::Dumper> etc.)

=head2 content_from_string() (required)

  $content = $fact->content_from_string( $string );

Given a string from C<content_as_string>, this method MUST regenerate and
return the original content data structure.  It MUST NOT overwrite the Fact's
content attribute directly.

=head2 meta_from_content()

  $content_meta = $fact->meta_from_content;

If defined in a subclass, this method MUST return a hash_reference with
content-specific indexing metadata for the Fact.  Hash values MUST either be
simple scalars (strings or numbers) or array references.  An array reference
indicates multiple values apply to the associated key.  For example:

  {
    md5sum => '6f93ee1d5f326dffb245711d38751e85',
    tags => [ qw/text database csv/ ],
  }

It MUST return C<undef> if no content-specific metadata is available.

=head2 validate_content() (required)

 eval{ $fact->validate_content };

This method SHOULD check for the validity of content within the Fact.  It
MUST throw an exception if the fact content is invalid.  (The return value is
ignored.)

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

