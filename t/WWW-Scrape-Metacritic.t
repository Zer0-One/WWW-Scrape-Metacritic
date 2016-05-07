use strict;
use warnings;

use Test::More tests => 3;
BEGIN { use_ok('WWW::Scrape::Metacritic', qw(:all)) };

ok(top_games() eq "Hi, I'm a stub!", 'Fetching top games');
ok(score() eq "Hi, I'm a stub!", 'Fetching scores');
