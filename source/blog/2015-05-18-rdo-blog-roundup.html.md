---
title: RDO blog roundup, week of May 18, 2016
date: 2015-05-18 17:00:37
author: rbowen
---

Here's what RDO engineers have been writing about over the past week.

If you're writing about RDO, or about OpenStack on CentOS, Fedora or RHEL, and you're not on my list, please let me know!


**The Age of Cloud File Services**, by Sean Cohen

> The new OpenStack Kilo upstream release that became available on April 30, 2015 marks a significant milestone for the Manila project for shared file system service for OpenStack with an increase in development capacity and extensive vendors adoption. This project was kicked off 3 years ago and became incubated during 2014 and now moves to the front of the stage at the upcoming OpenStack Vancouver Conference taking place this month with customer stories of Manila deployments in Enterprise and Telco environments.

... read more at http://tm3.org/blog150

**Adding Managed Compute Nodes to a Highly Available Openstack Control Plane**, by Andrew Beekhof

> As previously announced on RDO list and GitHub, we now have a way to allow Pacemaker to manage compute nodes within a single cluster while still allowing us to scale beyond corosync’s limits.

... read more at http://tm3.org/blog151

**TripleO Heat templates Part 2 - Node initial deployment & config** by Steve Hardy

> In my previous post "TripleO Heat templates Part 1 - roles and groups", I provided an overview of the various TripleO roles, the way the role implementation is abstracted via provider resources, and how they are grouped and scaled via OS::Heat::ResourceGroup.

... read more at http://tm3.org/blog152

**Public vs Private, Amazon compared to OpenStack** by Jonathan Gershater 

> How to choose a cloud platform and when to use both

... more at http://tm3.org/blog153

**An EZ Bake OVN for OpenStack** by Russell Bryant

> When Ben Pfaff pushed the last of the changes needed to make OVN functional to the ovn branch, he dubbed it the “EZ Bake milestone”.  The analogy is both humorous and somewhat accurate.  We’ve reached the first functional milestone, which is quite exciting.

... read more at http://tm3.org/blog154

**Testing Lightning Talk** by Assaf Muller

> I’m giving a lightning talk in the OpenStack Vancouver Neutron design summit. It’s a 5 minute talk about testing, common pitfalls and new developments with respect to testing frameworks.

... read more at http://tm3.org/blog155

**TripleO Heat templates Part 3 - Cluster configuration, introduction/primer** by Steve Hardy

> In my previous two posts I covered an overview of TripleO template roles and groups, and specifics of how initial deployment of a node happens.  Today I'm planning to introduce the next step of the deployment process - taking the deployed groups of nodes, and configuring them to work together as clusters running the various OpenStack services encapsulated by each role.

... read more at http://tm3.org/e

**Debugging TripleO Heat templates** by Steve Hardy

> Lately, I've been spending increasing amounts of time working with TripleO heat templates, and have noticed some recurring aspects of my workflow whilst debugging them which I thought may be worth sharing.

.. read more at http://tm3.org/blog156

**Deprecating libvirt / KVM hypervisor versions in OpenStack Nova** by Daniel Berange

> If you read nothing else, just take note that in the Liberty release cycle Nova has deprecated usage of libvirt versions < 0.10.2, and in the Mxxxxx release cycle support for running with libvirt < 0.10.2 will be explicitly dropped.

... read more at http://tm3.org/blog157

