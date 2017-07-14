---
title: RDO blog roundup, week of October 5
author: rbowen
date: 2015-10-06 09:10:33 UTC
tags: blog, roundup, weekly, planet
comments: true
published: true
---

Here's what RDO enthusiasts have been writing about over the past week.

If you're writing about RDO, or about OpenStack on CentOS, Fedora or RHEL, and you're not on my list, please let me know!

**Migrating Cinder volumes between OpenStack environments using shared NFS storage** by Lars Kellogg-Stedman

> Many of the upgrade guides for OpenStack focus on in-place upgrades to your OpenStack environment. Some organizations may opt for a less risky (but more hardware intensive) option of setting up a parallel environment, and then migrating data into the new environment. In this article, we look at how to use Cinder backups with a shared NFS volume to facilitate the migration of Cinder volumes between two different OpenStack environments.

... read more at [http://tm3.org/2r](http://tm3.org/2r)

**RDO Liberty (beta) DVR Deployment (Controller/Network)+Compute+Compute (ML2&OVS&VXLAN) on CentOS 7.1** by Boris Derzhavets

> Would you experience VXLAN tunnels disappiaring issue like it happens
on RDO Kilo add following lines to ml2_conf.ini on each Compute Node

... read more at [http://tm3.org/2s](http://tm3.org/2s)

**So, you're an ATC. Let me tell you something** by Flavio Percoco

> It's that time of the cycle - ha! you saw this comming, didn't you? -, in OpenStack, when we need to elect new members for the Technical Committee. In a previous post, I talked about what being a PTL means. I talked directly to candidates and I encouraged them to understand each and every point that I've made in that post. This time, though, I'd like to talk directly to ATCs for a couple of reasons. First one is that Thierry Carrez has a great post already where he explains what being a TC member means. Second one is that I think you, my dear ATC, are one of the most valuable member of this community and of the ones with most power throughout OpenStack.

... read more at [http://tm3.org/2t](http://tm3.org/2t)

**RDO Kilo DVR Deployment (Controller/Network)+Compute+Compute (ML2&OVS&VXLAN) on CentOS 7.1** by Boris Derzhavets

> RDO Kilo DVR Deployment (Controller/Network)+Compute+Compute (ML2&OVS&VXLAN) on CentOS 7.1

... read more at [http://tm3.org/2u](http://tm3.org/2u)

**How would work changing "enable_isolated_metadata" from false to true && `openstack-service restart neutron` on the fly on RDO Liberty ?** by Boris Derzhavets

> Can meta-data co-exist in qrouter and qdhcp namespace at the same time
so that LANs without Routers involved can access meta-data ?

... read more at [http://tm3.org/2v](http://tm3.org/2v)

**Haikel Guemar talks about RPM packaging** by Rich Bowen

> This continues my series talking with OpenStack project PTLs (Project Technical Leads) about their projects, what's new in Liberty, and what's coming in future releases.

... read (and listen) at [http://tm3.org/2w](http://tm3.org/2w)
