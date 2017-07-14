---
title: RDO blog roundup, 25 Jan 2016
author: rbowen
date: 2016-01-25 19:50:46 UTC
tags: blog,openstack
comments: true
published: true
---

Here's what RDO enthusiasts have been writing about in the last week:

**Deploying an OpenStack undercloud/overcloud on a single server from my laptop with Ansible.** by Harry Rybacki

> During the summer of 2014 I worked on the OpenStack Keystone component while interning at Red Hat. Fast forward to the end of October 2015 and I once again find myself working on OpenStack for Red Hat — this time on the RDO Continuous Integration (CI) team. Since re-joining Red Hat I’ve developed a whole new level of respect not only for the wide breadth of knowledge required to work on this team but for deploying OpenStack in general.

... read more at [http://tm3.org/4q](http://tm3.org/4q)

**Ceilometer Polling Performance Improvement**, by Julien Danjou

> During the OpenStack summit of May 2015 in Vancouver, the OpenStack Telemetry community team ran a session for operators to provide feedback. One of the main issues operators relayed was the polling that Ceilometer was running on Nova to gather instance information. It had a highly negative impact on the Nova API CPU usage, as it retrieves all the information about instances on regular intervals.

... read more at [http://tm3.org/4m](http://tm3.org/4m)

**AIO RDO Liberty && several external networks VLAN provider setup** by Boris Derzhavets

> Post bellow is addressing the question when AIO RDO Liberty Node has to have external networks of VLAN type with predefined vlan tags. Straight forward packstack --allinone install doesn't  allow to achieve desired network configuration. External network provider of vlan type appears to be required. In particular case, office networks 10.10.10.0/24 vlan tagged (157) ,10.10.57.0/24 vlan tagged (172), 10.10.32.0/24 vlan tagged (200) already exists when RDO install is running. If demo_provision was "y" , then delete router1 and created external network of VXLAN type 

... read more at [http://tm3.org/4l](http://tm3.org/4l)

**Caching in Horizon with Redis** by Matthias Runge

> Redis is a in-memory data structure store, which can be used as cache and session backend. I thought to give it a try for Horizon. Installation is quite simple, either pip install django-redis or dnf --enablerepo=rawhide install python-django-redis.

... read more at [http://tm3.org/4n](http://tm3.org/4n)

**Red Hat Cloud Infrastructure Cited as a Leader Among Private Cloud Software Suites by Independent Research Firm** by Gordon Tillmore

> The Forrester report states that Red Hat “leads the evaluation with its powerful portal, top governance capabilities, and a strategy built around integration, open source, and interoperability. Rather than trying to build a custom approach for completing functions around operations, governance, or automation, Red Hat provides a very composable package by leveraging a mix of market standards and open source in addition to its own development.”

... read more at [http://tm3.org/4o](http://tm3.org/4o)

**Disable "Resource Usage"-dashboard in Horizon** by Matthias Runge

> When using Horizon as Admin user, you probably saw the metering dashboard, also known as "Resource Usage". It internally uses Ceilometer; Ceilometer continuously collects data from configured data sources. In a cloud environment, this can quickly grow enormously. When someone visits the metering dashboard in Horizon, Ceilometer then will accumulate requested data on the fly.

... read more at [http://tm3.org/4p](http://tm3.org/4p)

