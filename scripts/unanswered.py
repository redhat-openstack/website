#!/usr/bin/python
import urllib2
import json
import sys

# Magic
import sys    # sys.setdefaultencoding is cancelled by site.py
reload(sys)    # to re-enable sys.setdefaultencoding()
sys.setdefaultencoding('utf-8')

keyword = sys.argv[1] if len(sys.argv) >= 2 else 'rdo'

url = 'https://ask.openstack.org/en/api/v1/questions/?scope=unanswered&query=' + keyword + '&sort=age-desc'

response = urllib2.urlopen(url)
m = response.read()
r = json.loads(m)
questions = r['questions']
count = r['count']

print str(count) + " unanswered questions:"

for q in questions:
    print
    print q['title']
    print q['url']
    print "Tags: " + ", ".join( q['tags'] )

