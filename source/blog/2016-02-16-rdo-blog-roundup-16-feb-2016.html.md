---
title: RDO blog roundup, 16 Feb 2016
author: rbowen
date: 2016-02-16 15:54:08 UTC
tags: blog,rdocommunity,openstack
comments: true
published: true
---

Here's what's hit the RDO blogs in the last few weeks.

**RDO Liberty DVR Neutron workflow on CentOS 7.2** by Boris Derzhavets

> Per http://specs.openstack.org/openstack/neutron-specs/specs/juno/neutron-ovs-dvr.html  
DVR is supposed to address following problems which has traditional 3 Node
deployment schema

... read more at [http://tm3.org/4r](http://tm3.org/4r)

**RDO Community Day at FOSDEM** by Rich Bowen

> On Friday, in Brussels, 45 RDO enthusiasts gathered at the IBM Client Center in Brussels (Thanks, IBM!) for a full day of RDO content and discussion.

... read more at [http://tm3.org/4s](http://tm3.org/4s)

**Python API for "boot from image creates new volume" RDO Liberty** by Boris Derzhavets

> Post below addresses several questions been posted at ask.openstack.org
In particular, code bellow doesn't require volume UUID to be  hard coded
to start server attached to boot able cinder's LVM, created via glance image,
which is supposed to be passed to script via command line. In the same way
name of cinder volume and instance name may be passed to script via CLI.  

... read more at [http://tm3.org/4t](http://tm3.org/4t)

**Why does Red Hat contribute to RDO?** by Nick Barcet

> Red Hat's philosophy is 'Upstream First'. When we participate in an open source project, our contributions go into the upstream project first, as a prerequisite to deliver it in the downstream offering. Our continued focus, over the past years and in the future, is to reduce to a bare minimum the differences between Upstream, RDO and RHEL OpenStack Platform at General Availabilty time, as we believe this is the only way we can maximise our velocity in delivering new features. In doing so, we, as any successful enterprise would do, need to focus our efforts on what matters in respect to our "downstream" strategy, and it means that we do prioritize our efforts accordingly as we are contributing particular features and fixes.

... read more at [http://tm3.org/4u](http://tm3.org/4u)

**Keystone Implied roles with CURL** by Adam Young

> Keystone now has Implied Roles.  What does this mean?  Lets say we define the role Admin to  imply the Member role.  Now, if you assigned someone Admin on a project they are automatically assigned the Member role on that project implicitly.

... read more at [http://tm3.org/4v](http://tm3.org/4v)

**Systemd-nspawn for fun and...well, mostly for fun** by Lars Kellogg-Stedman 

> systemd-nspawn has been called "chroot on steroids", but if you think of it as Docker with a slightly different target you wouldn't be far wrong, either. It can be used to spawn containers on your host, and has a variety of options for configuring the containerized environment through the use of private networking, bind mounts, capability controls, and a variety of other facilities that give you flexible container management.

... read more at [http://tm3.org/4w](http://tm3.org/4w)

**A systemd-nspawn connection driver for Ansible** by Lars Kellogg-Stedman

> I wrote earlier about systemd-nspawn, and how it can take much of the fiddly work out of setting up functional chroot environments. I'm a regular Ansible user, and I wanted to be able to apply some of those techniques to my playbooks.

... read more at [http://tm3.org/4x](http://tm3.org/4x)

**A Holla out to the Kolla devs** by Adam Young

> Devstack uses Pip to install packages, which conflict with the RPM versions on my Fedora system. Since I still need to get work done, and want to run tests on Keystone running against a live database, I’ve long wondered if I should go with container based approach. Last week, I took the plunge and started messing around with Docker. I got the MySQL Fedora container to run, then found Lars Keystone container using Sqlite, and was stumped. I poked around for a way to get the two containers talking to each other, and realized that we had a project dedicated to exactly that in OpenStack: Kolla. While it did not work for me right out of a git-clone, several of the Kolla devs worked with me to get it up and running. here are my notes, distilled.

... read more at [http://tm3.org/4y](http://tm3.org/4y)

**Boosting the NFV datapath with RHEL OpenStack Platform** by Nir Yechiel

> With software-defined networking (SDN) and network functions virtualization (NFV) gaining traction, more cloud service providers are looking for open solutions, based on standardized hardware platforms and open source software. In particular, communication service providers (CSPs) are undergoing a major shift from specialized hardware-based network elements to a software based provisioning paradigm where virtualized network functions (VNFs) are deployed in private or hybrid clouds of network operators. Increasingly, OpenStack is seen as the virtual infrastructure platform of choice for NFV, with many of the world’s largest communications companies implementing solutions with OpenStack today.

... read more at [http://tm3.org/4z](http://tm3.org/4z)

**OpenStack Keystone Q and A with the Boston University Distributed Systems Class Part 1** by Adam Young

> Dr. Jonathan Appavoo was kind enough to invite me to be a guest lecturer in his distributed systems class at Boston University. The students proved a list of questions, and I only got a chance to address a handful of them during the class. So, I’ll try to address the rest here.

... read more at [http://tm3.org/4-](http://tm3.org/4-)


**Setup Swift as Glance backend on RDO Liberty (CentOS 7.2)** by Boris Derzhavets

> Post below presumes that your testing Swift storage is located  somewhere on workstation (say /dev/sdb1) is about 25 GB (XFS) and before running packstack (AIO mode for testing)  following steps have been done :-

... read more at [http://tm3.org/50](http://tm3.org/50)

**Boosting the NFV datapath with RHEL OpenStack Platform** by Nir Yechiel

> A post I wrote for the Red Hat Stack blog, trying to clarify what we are doing with RHEL OpenStack Platform to accelerate the datapath for NFV applications.

... read more at [http://tm3.org/51](http://tm3.org/51)
