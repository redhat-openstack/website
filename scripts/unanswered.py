#!/usr/bin/python
import urllib2
import json
import sys
import argparse

# Command-line switches and arguments
parser = argparse.ArgumentParser()
parser.add_argument("-t", "--tags", help="Output questions by tags", action="store_true")
parser.add_argument("keyword", nargs='?', type=str, default='rdo');
args = parser.parse_args()

url = 'https://ask.openstack.org/en/api/v1/questions/?scope=unanswered&query=' + args.keyword + '&sort=age-desc'

response = urllib2.urlopen(url)
m = response.read()
r = json.loads(m)
questions = r['questions']
count = r['count']
tags = {}

print str(count) + " unanswered questions:"

for q in questions:
    if not args.tags:
        print "\n" + q['title'] + q['url'] + "\nTags: " + ", ".join( q['tags'] )

    for t in q['tags']:
        if t not in tags:
            tags[t] = "* " + q['title'] + ": " + q['url']
        else:
            tags[t]+= "\n" + "* " + q['title'] + ": " + q['url']

print "\n"

if args.tags:
    for t in sorted(tags):
        print "\n\n" + t + "\n" + tags[t]


