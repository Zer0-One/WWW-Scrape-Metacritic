use 5.020002;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'WWW::Scrape::Metacritic',
    VERSION_FROM      => 'lib/WWW/Scrape/Metacritic.pm',
    PREREQ_PM         => {'WWW::Mechanize' => 1.75,
                          'WWW::Mechanize::TreeBuilder' => 1.2},
    ABSTRACT_FROM     => 'lib/WWW/Scrape/Metacritic.pm',
    AUTHOR            => 'David Zero <zero@cpp.edu>',
);
