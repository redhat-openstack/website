---
title: Packstack
authors: rbowen
wiki_title: Packstack cookbook
wiki_revision_count: 5
wiki_last_updated: 2013-11-21
---

# Packstack

For full Packstack documentation, see the [upstream wiki
page](https://wiki.openstack.org/wiki/Packstack).

### Basics

#### Help

         packstack --help

#### All in one

         packstack --allinone

Shorthand for

         --install-hosts=<local ipaddr> --novanetwork-pubif=<dev> --novacompute-privif=lo --novanetwork-privif=lo --os-swift-install=y --nagios--install=y

This option can be used to install an all in one OpenStack on this host.

#### Generate answer file

         packstack --gen-answer-file

Any other command line options may be provided with this one, to produce a reusable answer file.

#### Reuse an answer file

         packstack --answer-file=/path/to/packstack_answers.txt

