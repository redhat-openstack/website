#!/usr/bin/perl
use strict;
use warnings;

use XML::Feed;
use URI;
use JSON::Parse;
use Data::Dumper;
use WWW::Shorten::Yourls;
    use XML::Simple;
    use LWP::Simple;

my $url = URI->new("http://planet.rdoproject.org/atom.xml");

my $feed = XML::Feed->parse($url);

foreach ( $feed->entries ) {
    print "**" . $_->title . "** by " . $_->author . "\n\n";
    my $body = $_->content->body;
    
    # Or possibly the summary?
    if ( !$body ) {
        $body = $_->summary->body;
        $body =~ s/\n.*//is
    }

    $body =~ s/^.*?<p[^>]*?>//i;
    $body =~ s!</p>.*$!!is;
    print "> $body\n\n";

    my $link = $_->link;

    # tm3.org URL shortener
    my $shorten = "http://tm3.org/yourls-api.php?signature=APIKEYHERE&action=shorturl&url=" . $link;
    my $parser = new XML::Simple;
    my $content = get $shorten or die "Unable to get $url\n";
    my $data = $parser->XMLin($content);
    my $short = $data->{shorturl};

    print "Read more at [$short]($short)\n\n\n";
}

