#!/usr/bin/python
import yaml
import os

os.system("rm -f rdo.yml")
os.system("wget -q https://raw.githubusercontent.com/redhat-openstack/rdoinfo/master/rdo.yml")

f = open('./rdo.yml')
# use safe_load instead load
dataMap = yaml.safe_load(f)
f.close()

# print dataMap['packages']
for p in dataMap['packages']:
    print
    print p['project']
    if 'maintainers' in p:
        for m in p['maintainers']:
            print "  " + m


