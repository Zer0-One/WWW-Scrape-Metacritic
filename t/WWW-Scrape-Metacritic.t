use diagnostics;
use strict;
use warnings;

use Test::More tests => 27;
BEGIN { use_ok('WWW::Scrape::Metacritic', qw(:all)) };

#Fetching top games
is(top_games('playstation-3', 0), 10, 'Fetching top games: PlayStation 3');
is(top_games('playstation-4', 0), 10, 'Fetching top games: PlayStation 4');
is(top_games('playstation-vita', 0), 10, 'Fetching top games: PlayStation Vita');
is(top_games('xbox-one', 0), 10, 'Fetching top games: Xbox One');
is(top_games('pc', 0), 10, 'Fetching top games: PC');
is(top_games('wii-u', 0), 8, 'Fetching top games: Wii U');
is(top_games('3ds', 0), 10, 'Fetching top games: 3DS');
is(top_games('ios', 0), 10, 'Fetching top games: iOS');

#Parsing title info
my $t_info = title_info('playstation-3', 'BioShock', 0);
is($t_info->{developer}, 'Digital Extremes, 2K Marin', 'Parsing title info (PS3): BioShock:developer');
is($t_info->{esrb_desc}, 'Blood and Gore, Drug Reference, Intense Violence, Sexual Themes, Strong Language', 'Parsing title info (PS3): BioShock:esrb_desc');
is($t_info->{genre}, 'Action', 'Parsing title info (PS3): BioShock:genre');
is($t_info->{rating}, 'M', 'Parsing title info (PS3): BioShock:rating');
is($t_info->{release_date}, 'Oct 21, 2008', 'Parsing title info (PS3): BioShock:release_date');
is($t_info->{title}, 'BioShock', 'Parsing title info (PS3): BioShock:title');
is($t_info->{website}, 'http://www.2kgames.com/bioshock/enter.html', 'Parsing title info (PS3): BioShock:website');

$t_info = title_info('pc', 'Counter-Strike: Global Offensive', 0);
is($t_info->{developer}, 'Valve Software', 'Parsing title info (PC): Counter-Strike: Global Offensive:developer');
is($t_info->{esrb_desc}, 'Blood, Intense Violence', 'Parsing title info (PC): Counter-Strike: Global Offensive:esrb_desc');
is($t_info->{genre}, 'Action', 'Parsing title info (PC): Counter-Strike: Global Offensive:genre');
is($t_info->{rating}, 'M', 'Parsing title info (PC): Counter-Strike: Global Offensive:rating');
is($t_info->{release_date}, 'Aug 21, 2012', 'Parsing title info (PC): Counter-Strike: Global Offensive:release_date');
is($t_info->{title}, 'Counter-Strike: Global Offensive', 'Parsing title info (PC): Counter-Strike: Global Offensive:title');
is($t_info->{website}, 'http://www.counter-strike.net/', 'Parsing title info (PC): Counter-Strike: Global Offensive:website');

#do you think this title has enough special characters in it?
$t_info = title_info('pc', '//N.P.P.D. RUSH//- The milk of Ultraviolet', 0);
is($t_info->{developer}, 'Rail Slave Games', 'Parsing title info (PC): //N.P.P.D. RUSH//- The milk of Ultraviolet:developer');
is($t_info->{genre}, 'Scrolling', 'Parsing title info (PC): //N.P.P.D. RUSH//- The milk of Ultraviolet:genre');
is($t_info->{release_date}, 'Feb 13, 2014', 'Parsing title info (PC): //N.P.P.D. RUSH//- The milk of Ultraviolet:release_date');
is($t_info->{title}, '//N.P.P.D. RUSH//- The milk of Ultraviolet', 'Parsing title info (PC): //N.P.P.D. RUSH//- The milk of Ultraviolet:title');
