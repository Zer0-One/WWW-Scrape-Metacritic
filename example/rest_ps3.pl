#!/usr/bin/env perl

use warnings;
use strict;

use Dancer qw(!pass);
use WWW::Scrape::Metacritic qw(:all);

get '/games' => sub{
    content_type 'application/json';
    return top_games_json('playstation-3', 0);
};

get '/games/:title' => sub{
    content_type 'application/json';
    return title_info_json('playstation-3', params->{title}, 0);
};

dance;
