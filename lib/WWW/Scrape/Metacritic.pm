package WWW::Scrape::Metacritic;

use 5.020002;
use strict;
use warnings;

require Exporter;
use WWW::Mechanize;
use WWW::Mechanize::TreeBuilder;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	top_games
	score
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';

my $mech = WWW::Mechanize->new(autocheck => 1);

sub top_games{
	my $msg = "Hi, I'm a stub!";
	printf("%s\n", $msg);
	return $msg;
}

sub score{
	my $msg = "Hi, I'm a stub!";
	printf("%s\n", $msg);
	return $msg;
}

1;
__END__

=head1 NAME

WWW::Scrape::Metacritic - Perl module for scraping data from Metacritic

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

use WWW::Scrape::Metacritic qw(:all);

=head1 DEPENDENCIES

=over

=item WWW::Mechanize

=item WWW::Mechanize::TreeBuilder

=back

=head1 DESCRIPTION

This module implements functionality for scraping data from Metacritic's website.

Currently, features include:

=over

=item - Lists of top rated games for each platform

=item - Scores for any given title

=back

New features will be added as I become more bored with the rest of my life.

=head1 SEE ALSO

=over

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
