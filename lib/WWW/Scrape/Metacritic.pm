package WWW::Scrape::Metacritic;

use 5.020002;
use strict;
use warnings;

require Exporter;
use JSON;
use WWW::Mechanize;
use WWW::Mechanize::TreeBuilder;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	top_games
	top_games_json
	title_info
    title_info_json
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

my $url_games = 'http://www.metacritic.com/game/';

my $json = JSON->new->utf8->pretty->canonical->allow_nonref();

my $mech = WWW::Mechanize->new(autocheck => 1);
WWW::Mechanize::TreeBuilder->meta->apply($mech);

sub title_info{
    my ($platform, $title, $summary) = @_;
    
    my $title_normalized = lc($title);
    $title_normalized =~ s/[][.,\/*;:&']//g;
    $title_normalized =~ s/[\s]+/-/g;
   
    $mech->get($url_games.$platform.'/'.$title_normalized.'/details');
    
    my ($title_summary, $title_rating, $title_esrb_desc, $title_website, $title_genre, $title_developer) = '';
    if($summary){
        $title_summary = $mech->look_down(class => 'summary_detail product_summary')->look_down(class => 'data');
        $title_summary = $title_summary->as_trimmed_text();
    }
    my $title_release = $mech->look_down(class => 'summary_detail release_data')->look_down(class => 'data');

    #When a metascore hasn't yet been determined, this element doesn't exist
    my $title_metascore = $mech->look_down(itemprop => 'ratingValue');
    if(defined($title_metascore)){
        $title_metascore = $title_metascore->as_trimmed_text() + 0;
    }
    #When a userscore hasn't been determined, it's value is "tbd"
    my $title_userscore = $mech->look_down('class', qr/metascore_w user.*game.*/)->as_trimmed_text();
    ($title_userscore eq 'tbd') ? (undef($title_userscore)) : ($title_userscore += 0);

    my $details = $mech->look_down(class => 'product_details');
    foreach my $row($details->look_down(_tag => 'tr')){
        my $th = $row->look_down(_tag => 'th')->as_trimmed_text();
        if($th eq 'Rating:'){
            $title_rating = $row->look_down(_tag => 'td')->as_trimmed_text();
        }
        elsif($th eq 'Official Site:'){
            $title_website = $row->look_down(_tag => 'td')->as_trimmed_text();
        }
        elsif($th eq 'Developer:'){
            $title_developer = $row->look_down(_tag => 'td')->as_trimmed_text();
        }
        elsif($th eq 'Genre(s):'){
            $title_genre = $row->look_down(_tag => 'td')->as_trimmed_text();
        }
        elsif($th eq 'ESRB Descriptors:'){
            $title_esrb_desc = $row->look_down(_tag => 'td')->as_trimmed_text();
        }
    }

    return { title => $title,
             summary => $title_summary,
             release_date => $title_release->as_trimmed_text(),
             developer => $title_developer,
             genre => $title_genre,
             rating => $title_rating,
             esrb_desc => $title_esrb_desc,
             website => $title_website,
             metascore => $title_metascore,
             userscore => $title_userscore };
}

sub title_info_json{
    my ($platform, $title, $summary) = @_;
    return($json->encode(title_info($platform, $title, $summary)));
}

sub top_games{
    my ($platform, $summary) = @_;
    my (@titles, @t_info);

    $mech->get($url_games.$platform);
    #if we don't build @t_info incrementally like this, title_info() will clobber $mech
    foreach my $element_product($mech->look_down(class => 'wrap product_wrap')){
        push(@titles, $element_product->look_down(_tag => 'h3', class => 'product_title')->as_trimmed_text());
    }
    foreach my $title(@titles){
        push(@t_info, title_info($platform, $title, $summary));
    }
    
    return @t_info;
}

sub top_games_json{
    my ($platform, $summary) = @_;
    my @titles = top_games($platform, $summary);
    return $json->encode(\@titles);
}

1;
__END__

=head1 NAME

WWW::Scrape::Metacritic - Perl extension for scraping data from Metacritic

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

By default, this module exports nothing. To include all functions, use:

    use WWW::Scrape::Metacritic qw(:all);

To include a more specific set of functions, provide the symbols explicitly.
For example:
    
    use WWW::Scrape::Metacritic qw(top_games top_games_as_json);

=head1 DEPENDENCIES

=over

=item JSON

=item WWW::Mechanize

=item WWW::Mechanize::TreeBuilder

=back

=head1 DESCRIPTION

This module implements functionality for scraping data from Metacritic's
website. It is highly dependent on Metacritic's markup (style names, element
heirarchy, etc.), and as such should be expected to break when the Metacritic
website changes significantly enough.

Currently, features include:

=over

=item - Lists of top rated games for each platform

=item - Info for any given title

=item - JSON output

=back

New features will be added as I become more bored with the rest of my life.

=head1 USAGE

=head2 title_info($platform, $title, $summary)

Fetches information about C<$title> for C<$platform> from the title's details
page (http://www.metacritic.com/game/C<$title>/details).  Returns a hash
containing the following keys:

=over

=item * C<developer>

=item * C<esrb_desc>

=item * C<genre>

=item * C<metascore>

=item * C<rating>

=item * C<release_date>

=item * C<summary>

=item * C<title>

=item * C<userscore>

=item * C<website>

=back

Metacritic does not always provide values for all of the above keys. When this
happens, the missing value will be set to the empty string in the returned
hash.

A game summary can be very large, and may be omitted (set to the empty string)
from the returned hash by setting the C<$summary> parameter to a false value.

Note that before the lookup can happen, the title must be normalized. If the
C<$title> passed to this subroutine is not already in the correct format, it
will be modified automatically. For reference, Metacritic normalizes titles for
their URLs using the following steps:

=over

=item * The title is lowercased.

=item * Periods, colons, ampersands, forward slashes, apostrophes, asterisks,
commas, and square brackets are stripped.

=item * Whitespace (both single characters and runs of characters) is replaced
with a single dash.

=back

As of the writing of this documentation, the following strings are valid values
of C<$platform>:

=over

=item * C<3ds>

=item * C<ios>

=item * C<pc>

=item * C<playstation-3>

=item * C<playstation-4>

=item * C<playstation-vita>

=item * C<wii-u>

=item * C<xbox-360>

=item * C<xbox-one>

=back

=head3 Sample Usage

The following snippet will fetch and print the full summary for the game
"BioShock" for the Playstation 3.

    my $info = title_info('playstation-3', 'BioShock', 1)
    printf("%s\n", $info->{summary});

=head2 title_info_json($platform, $title, $summary)

Calls C<title_info()>, and encodes the resulting hash into a JSON document
using the C<JSON> module. The resultant document is returned as a UTF-8 string.

=head3 Sample Usage

The following snippet will fetch and print a JSON object describing the game
"Final Fantasy XIII" for the Playstation 3.

    print(title_info_json('playstation-3', '', 0));

=head2 top_games($platform, $summary)

Fetches a list of the top games for the given platform, and calls
C<title_info()> for each one. Returns an array of hashes (one hash for each
game). If C<$summary> is true, the resultant hashes will include summaries for
their respective titles. For valid values of C<$platform>, see C<title_info()>.

=head3 Sample Usage

The following snippet will print the title and metascore of the first
Playstation 3 game in the array returned by C<top_games()>:

    my @titles = top_games('playstation-3', 0);
    printf("Title: %s\nScore: %s\n", $titles[0]{title}, $titles[0]{metascore});

=head2 top_games_json($platform, $summary)

Calls C<top_games()>, and encodes the resulting array into a JSON document
using the C<JSON> module. The resultant document is returned as a UTF-8 string.

=head3 Sample Usage

The following snippet will print a JSON array containing objects for every game
in the list of top Playstation 3 games returned by C<top_games()>:

    print(top_games_as_json('playstation-3', 0));

=head1 SEE ALSO

=over

=item perldoc HTML::Element

=item perldoc HTML::TreeBuilder

=item perldoc WWW::Mechanize

=item perldoc WWW::Mechanize::TreeBuilder

=back

=head1 AUTHOR

David Zero, E<lt>zero@cpp.eduE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2016, David Zero
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of WWW::Scrape::Metacritic nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut
