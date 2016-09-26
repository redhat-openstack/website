#!/usr/bin/perl
use strict;
use warnings;

use XML::Feed;
use URI;
use XML::Simple;
use LWP::Simple;
use Term::ProgressBar;

$|++;

my $url = URI->new("http://planet.rdoproject.org/atom.xml");

my $feed = XML::Feed->parse($url);

open (my $md, '>', 'blogs.md');
open (my $tweets, '>', 'blogs.tweets.csv');

my $p = Term::ProgressBar->new({count => 60});

foreach ( $feed->entries ) {

    $p->update();

    print $md "**" . $_->title . "** by " . $_->author . "\n\n";
    my $body = $_->content->body;
    
    # Or possibly the summary?
    if ( !$body ) {
        $body = $_->summary->body;
        $body =~ s/\n.*//is
    }

    $body =~ s/^.*?<p[^>]*?>//i;
    $body =~ s!</p>.*$!!is;
    $body =~ s/<[^>]+>//igs; # Strip HTML
    $body =~ s/[\r\n]/  /gs; # Strip newlines from whatever's left
    print $md "> $body\n\n";

    my $link = $_->link;

    # tm3.org URL shortener
    my $shorten = "http://tm3.org/yourls-api.php?signature=9d8634af7a&action=shorturl&url=" . $link;
    my $parser = new XML::Simple;
    my $content = get $shorten or die "Unable to get $url\n";
    my $data = $parser->XMLin($content);
    my $short = $data->{shorturl};

    print $md "Read more at [$short]($short)\n\n\n";

    print $tweets '"01/01/2016 00:00:00","' . $_->title 
            . ' #OpenStack #RDOCommunity","'
            . $short . '"' . "\n";
}

close $md;
close $tweets;

print "\nDone\n";
