
use strict;
use Test::More qw(no_plan);

BEGIN { use_ok( 'HTTP::Daemon' ); }
BEGIN { use_ok( 'Continuity::Adapt::HttpDaemon' ); }

my $d = HTTP::Daemon->new;

isa_ok($d, 'HTTP::Daemon', 'Got an HTTP::Daemon');

like($d->url, qr{^http://(.*):(\d+)/$});

$d->url =~ m{^http://(.*):(\d+)/$};
my $host = $1;
my $port = $2;

ok($port < 65536 && $port > 1000, 'Port in good rage (1000..65535)');

# OK, those tests were stupid. lets do something that should fail...


