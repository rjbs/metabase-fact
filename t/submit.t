use strict;
use warnings;

use Test::More;
use Test::Exception;

my %missing = map {; $_ => 1 } qw(YAML::Tiny Data::GUID);
for (keys %missing) {
  delete $missing{ $_ } if eval "require $_; 1";
}

plan skip_all => "missing required modules: " . join(' ', keys %missing)
  if keys %missing;

plan 'no_plan';

my $PA = 'CPAN::Metabase::Fact::PrereqAnalysis';

require_ok $PA;


my $arg = {
  dist_file   => 'Test-Meta-1.00.tar.gz',
  dist_author => 'OPRIME',
  content     => {
    'Meta::Meta'    => '0.001',
    'Mecha::Meta'   => '1.234',
    'Physics::Meta' => '9.1.12',
    'Physics::Pata' => '0.1_02',
  },
};

my $req = $PA->new($arg);

isa_ok($req, $PA);

ok(
  ! $req->is_submitted,
  'starts off not submitted',
);

throws_ok { $req->mark_submitted; } qr/guid/, "you need a guid to submit";

throws_ok { $req->mark_submitted; } qr/guid/, "you need a guid to submit";
