---
title: Packstack cookbook
authors: rbowen
wiki_title: Packstack cookbook
wiki_revision_count: 5
wiki_last_updated: 2013-11-21
---

# Packstack Cookbook

Recipes for setting up various kinds of OpenStack installations using the packstack command line.

### Basics

#### Help

         packstack --help

#### All in one

         packstack --allinone

Shorthand for `--install-hosts=&lt;local ipaddr&gt; --novanetwork-pubif=&lt;dev&gt; --novacompute-privif=lo --novanetwork-privif=lo --os-swift-install=y --nagios--install=y`, this option can be used to install an all in one OpenStack on this host.

#### Generate answer file

         packstack --gen-answer-file

#### Reuse an answer file

         packstack --answer-file=/path/to/packstack_answers.txt
