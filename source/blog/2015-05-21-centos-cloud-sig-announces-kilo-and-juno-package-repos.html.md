---
title: CentOS Cloud SIG announces Kilo and Juno package repos
date: 2015-05-21 11:40:00
author: rbowen
---

The CentOS Cloud SIG is pleased to announce the availability of OpenStack Kilo package repositories for CentOS 7, and Juno repositories for CentOS 6. These are the result of the last few months of work by the Cloud SIG membership, and, of course, we owe a great deal of gratitude to the upstream OpenStack community as well.

The CentOS 7 Kilo repository may be found at http://mirror.centos.org/centos/7/cloud/x86_64/

The Juno CentOS 6 repository may be found at http://mirror.centos.org/centos/6/cloud/x86_64/

The actual -release files will reside in Extras, so that you can yum install centos-release-openstack-kilo for Kilo and yum install centos-release-openstack-juno for Juno, without needing to mess with repo configurations.

See also the Juno EL6 QuickStart at http://wiki.centos.org/Cloud/OpenStack/JunoEL6QuickStart

CentOS cares about OpenStack. We test all of our cloud images against OpenStack, in the CentOS 5, 6, and 7 branches. The CentOS Cloud SIG is very keen on facilitating community efforts at CentOS, and we have resources available for CI, repos, and other needs, which the community can use. We welcome your participation in this effort. We're dedicated to ensuring that CentOS is a solid, dependable platform for deploying OpenStack, and that all versions of OpenStack are thoroughly tested against CentOS, and vice versa.

You can find out more about the CentOS Cloud SIG, and how to get involved, at http://wiki.centos.org/SpecialInterestGroup/Cloud