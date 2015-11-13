---
title: CentOS
authors: rbowen
wiki_title: CentOS
wiki_revision_count: 4
wiki_last_updated: 2014-01-13
---

# CentOS

RDO is the best OpenStack distribution for [CentOS](http://centos.org/),
because it is built and tested on CentOS, with the help of the CentOS
community. This work is facilitated via the [CentOS Cloud
SIG](https://wiki.centos.org/SpecialInterestGroup/Cloud).

The Cloud SIG has weekly meetings, every Thursday at [15:00
UTC](https://www.google.com/search?q=15%3A00+UTC).

The transcript from the most recent meeting may be found
[here](https://www.centos.org/minutes/2015/november/centos-devel.2015-11-12-15.10.log.html).

## RDO on CentOS

To install RDO on CentOS:

Ensure you have a fully updated CentOS Linux 7/x86_64 machine, and run:

      sudo yum install centos-release-openstack-liberty
      sudo yum install openstack-packstack
      packstack --allinone

## Cloud Images

If you want to run CentOS as a guest on your OpenStack cloud, you can
find CentOS cloud images at the following locations:

* [CentOS 7 qcow images](http://cloud.centos.org/centos/7/images/)
* [CentOS 6 qcow images](http://wiki.centos.org/Cloud/OpenNebula)
