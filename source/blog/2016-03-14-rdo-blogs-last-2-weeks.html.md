---
title: RDO blogs, last 2 weeks
author: rbowen
date: 2016-03-14 18:57:10 UTC
tags: blog, openstack, rdocommunity
comments: true
published: true
---

I was traveling much of last week, so we have two weeks of blog posts to catch you up on, and there's some really good ones in here.

**"RDO Manager" is now "TripleO"**, by K Rain Leander

> Because of its unique branding and name, one might assume that "RDO Manager" is not TripleO - perhaps it has additional downstream patches or maybe they're entirely different projects. You would not be alone because the community, the users and the developers alike have shared their confusion on this topic.

... read more at [http://tm3.org/58](http://tm3.org/58)


**Creating an additional host for a Tripleo overcloud**, by Adam Young

> I’ve been successful following the steps to get a Tripleo deployment. I now need to add another server to host the Identity Management and Federation services. Here’s the steps:

... read more at [http://tm3.org/59](http://tm3.org/59)

**OpenStack Montreal: A talk about CI in OpenStack and RDO**, by David Moreau Simard

> OpenStack Montreal is a meetup that happens around every 2 months in Montreal. We talk and discuss about different OpenStack topics with interests for developers, users and operators. If you’d like to keep up with the event, attend (or present a topic!), please subscribe to the mailing list to be notified when something’s going on.

... read more at [http://tm3.org/5a](http://tm3.org/5a)

**Packstack gates against itself** by David Moreau Simard

> Today I made an announcement on both openstack-dev and rdo-list that Packstack was going to gate against itself.

... read more at [http://tm3.org/5b](http://tm3.org/5b)

**RDO Kilo ML2&OVS&VLAN Mutti Node Deployment on Fedora 23** by Boris Derzhavets

> To complete packstack run for two nodes Controller/Network and Compute
setup I had to apply as pre-installation following patches, otherwise neutron
puppet crashed on Fedora 23 :-

... read more at [http://tm3.org/5c](http://tm3.org/5c)

**How i started contributing to the RDO Project** by Chandan Kumar

> During my internship period at Red Hat, Kushal used to play with OpenStack and got a problem that a created instance is not able to get a public IP address so that he can access it from outside.

... read more at [http://tm3.org/5d](http://tm3.org/5d)

**What Can Talk To What on the OpenStack Message Broker** by Adam Young

> If a hypervisor is compromised, the Nova Compute instance running on that node is also compromised. If the compute instance is compromised, then its access to the Message Queue has to be considered tainted as well. What degree of risk does this pose?

... read more at [http://tm3.org/5e](http://tm3.org/5e)

**Status of Python 3 in OpenStack Mitaka** by Victor Stinner

> Now that most OpenStack services have reached feature freeze for the Mitaka cycle (November 2015-April 2016), it’s time to look back on the progress made for Python 3 support.

... read more at [http://tm3.org/5f](http://tm3.org/5f)

**Setup DVR on RDO Liberty Controller && 2(x)Computes ML2/OVS/VLAN landscape** by Boris Derzhavets

> Just a reminder in Juno and Kilo DVR was available for deployments using VXLAN tunneling and required l2population activation on all nodes. One of new features of Liberty is DVR compatibility with ML2&OVS&VLAN deployed landscapes. On RDO Liberty packstack doesn't play so nicely doing VLAN deployment as in case of  VXLAN tunneling. Attempt to use old templates for answer file just does all configs properly only on Controller/Network Node.

... read more at [http://tm3.org/5g](http://tm3.org/5g)

**OpenStack Infra: Jenkins Jobs** by Arie Bregman

> A few days ago, while adding a new job to OpenStack Infra, I realized how difficult it must be for newcomers ( to OpenStack) to understand how OpenStack CI works and make new changes. The OpenStack Infra documentation coverage of each project is great and very detailed , but connecting the dots, which  assembles the complete work-flow can be a complex task for anyone.

... read more at [http://tm3.org/5h](http://tm3.org/5h)

**Glance Mitaka: Passing the torch** by Flavio Percoco 

> I'm not going to run for Glance's PTL position for the Newton timeframe. There are many motivations behind this choice. Some of them I'm willing to discuss in private if people are interested but I'll go as far as saying there are personal and professional reasons for me to not run again.

... read more at [http://tm3.org/5i](http://tm3.org/5i)

**HA support for DVR centralized default SNAT functionality on RDO Mitaka Milestone 3** by Boris Derzhavets

> Verification been done bellow is actually targeting conversion of HAProxy/Keepalived (Active/Active) 3 Node Controller which design was suggested for RDO Liberty  in https://github.com/beekhof/osp-ha-deploy/blob/master/HA-keepalived.md
to be able support Compute Nodes running in DVR mode. The core issue on Liberty was resolved for Mitaka , see upstream record  [RFE] Unable to create a router that's both HA and distributed 
General concepts (DVR/SNAT) are explained here Distributed Virtual Routing – SNAT 

... read more at [http://tm3.org/5j](http://tm3.org/5j)

