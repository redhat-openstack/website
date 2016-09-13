#!/usr/bin/perl
use strict;
use warnings;

use XML::Feed;
use URI;
use Data::Dumper;

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
    print "Read more at " . $_->link . "\n\n\n";
}

