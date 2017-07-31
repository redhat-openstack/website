---
title: Recent blog posts from the community
author: rbowen
date: 2017-07-31 13:54:08 UTC
tags: blog,community,openstack,recent
comments: true
published: true
---

Here's some of the great blogs from the RDO community which you may have missed in recent weeks:


**Using NFS for OpenStack (glance,nova) with selinux** by Fabian Arrotin

> As announced already, I was (between other things) playing with Openstack/RDO and had deployed some small openstack setup in the CentOS Infra. Then I had to look at our existing DevCloud setup. This setup was based on Opennebula running on CentOS 6, and also using Gluster as backend for the VM store. That's when I found out that Gluster isn't a valid option anymore : Gluster is was deprecated and was now even removed from Cinder. Sad as one advantage of gluster is that you could (you had to ! ) user libgfapi so that qemu-kvm process could talk directly to gluster through ligbfapi and not accessing VM images over locally mounted gluster volumes (please, don't even try to do that, through fuse).

Read more at [https://arrfab.net/posts/2017/Jul/28/using-nfs-for-openstack-glancenova-with-selinux/](https://arrfab.net/posts/2017/Jul/28/using-nfs-for-openstack-glancenova-with-selinux/)


**Nested quota models** by Tim Bell

> At the Boston Forum, there were many interesting discussions on models which could be used for nested quota management (https://etherpad.openstack.org/p/BOS-forum-quotas).Some of the background for the use has been explained previously in the blog (http://openstack-in-production.blogspot.fr/2016/04/resource-management-at-cern.html), but the subsequent discussions have also led to further review.

Read more at [http://openstack-in-production.blogspot.com/2017/07/nested-quota-models.html](http://openstack-in-production.blogspot.com/2017/07/nested-quota-models.html)


**Understanding ceph-ansible in TripleO** by Giulio Fidente

> One of the goals for the TripleO Pike release was to introduce ceph-ansible as an alternative to puppet-ceph for the deployment of Ceph.

Read more at [http://giuliofidente.com/2017/07/understanding-ceph-ansible-in-tripleo.html](http://giuliofidente.com/2017/07/understanding-ceph-ansible-in-tripleo.html)


**Tuning for Zero Packet Loss in Red Hat OpenStack Platform – Part 3** by m4r1k

>  In Part 1 of this series Federico Iezzi, EMEA Cloud Architect with Red Hat covered the architecture and planning requirements to begin the journey into achieving zero packet loss in Red Hat OpenStack Platform 10 for NFV deployments. In Part 2 he went into the details around the specific tuning and parameters required. Now, in Part 3, Federico concludes the series with an example of how all this planning and tuning comes together!  

Read more at [http://redhatstackblog.redhat.com/2017/07/18/tuning-for-zero-packet-loss-in-red-hat-openstack-platform-part-3/](http://redhatstackblog.redhat.com/2017/07/18/tuning-for-zero-packet-loss-in-red-hat-openstack-platform-part-3/)