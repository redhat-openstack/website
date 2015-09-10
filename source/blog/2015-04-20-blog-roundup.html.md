---
title: RDO Blog roundup, April 20 2015
date: 2015-04-20 15:38:32
author: rbowen
---

Here's what RDO engineers have been writing about over the past week.

If you're writing about RDO, or about OpenStack on CentOS, Fedora or RHEL, and you're not on my list, please let me know!

**Implementation of Pacemaker Managed OpenStack VM Recovery**, by Russell Bryant

> I’ve discussed the use of Pacemaker as a method to detect compute node failures and recover the VMs that were running there.  The implementation of this is ready for testing.  Details can be found in this post to rdo-list.

... read more at http://tm3.org/blog122

**OVN and OpenStack Integration Development Update**, by Russell Bryant

> The Open vSwitch project announced the OVN effort back in January.  After OVN was announced, I got very interested in its potential.  OVN is by no means tied to OpenStack, but the primary reason I’m interested is I see it as a promising open source backend for OpenStack Neutron.  To put it into context with existing Neutron code, it would replace the OVS agent in Neutron in the short term.  It would eventually also replace the L3 and DHCP agents once OVN gains the equivalent functionality.

... read more at http://tm3.org/blog123

**Preserving contaner properties via volume mounts**, by Steven Dake

> In the Kolla project, we were heavily using host bind mounts to share filesystem data with different containers.  A host bind mount is an operation where a host directory, such as /var/lib/mysql is mounted directly into the container at some specific location.

... read more at http://tm3.org/blog124

**Distributed Virtual Routing – Overview and East/West Routing**, by Assaf Muller

> DVR aims to isolate the failure domain of the traditional network node and to optimize network traffic by eliminating the centralized L3 agent shown above. It does that by moving most of the routing previously performed on the network node to the compute nodes.

... read more at http://tm3.org/blog125

**Distributed Virtual Routing – SNAT**, by Assaf Muller

> A quick reminder about two NAT types used in Neutron.

... read more at http://tm3.org/blog126

**Distributed Virtual Routing – Floating IPs**, by Assaf Muller

> Legacy routers provide floating IPs connectivity by performing 1:1 NAT between the VM’s fixed IP and its floating IP inside the router namespace. Additionally, the L3 agent throws out a gratuitous ARP when it configures the floating IP on the router’s external device. This is done to advertise to the external network that the floating IP is reachable via the router’s external device’s MAC address. Floating IPs are configured as /32 prefixes on the router’s external device and so the router answers any ARP requests for these addresses. Legacy routers are of course scheduled only on a select subgroup of nodes known as network nodes.

... read more at http://tm3.org/blog127

**Creating a new Network for a dual NIC VM**, by Adam Young

> I need a second network for testing a packstack deployment. Here is what I did to create it, and then to boot a new VM connected to both networks.

... read more at http://tm3.org/blog128

**Debugging TripleO Heat templates**, by Steve Hardy

> Lately, I've been spending increasing amounts of time working with TripleO heat templates, and have noticed some recurring aspects of my workflow whilst debugging them which I thought may be worth sharing.

... read more at http://tm3.org/blog129


