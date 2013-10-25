---
title: " starting from scratch with Havana"
category: needsupdate
authors: beagles, rbowen
wiki_category: NeedsUpdate
wiki_title: 'A case study: starting from scratch with Havana'
wiki_revision_count: 3
wiki_last_updated: 2015-07-16
---

#  starting from scratch with Havana

__NOTOC__

## Introduction

It can sometimes be difficult to debug an "all-in-one" deployment. Guides like [Network Troubleshooting](http://docs.openstack.org/trunk/openstack-ops/content/network_troubleshooting.html) can help identify those small missteps that prevent VMs from getting IP addresses and put things right. Going from an all-in-one configuration to a multi-node configuration with externally routable floating IPs is trickier. There are likely guides out there to walk through it or if not, there likely will be some soon. So what do you do if you have tried to make the transition from "all in one" to a more "real-world" deployment and you cannot get things to work? What if you feel that things are such a mess that you just want to wipe it all and start over? Well, that is not as drastic as it seems. In fact, one of the RDO community members did just that.

## The Beginning

Where to begin? Since this story is about starting over, that is really the beginning. The prequel would be familiar to some: DHCP isn't working, no external access, VMs failing to boot. It is a sad story and apparently without hope, but like a little-known sci-fi epic, with a new beginning comes new hope (sorry G.L.). Let's start with a description of the galaxy system we have to work with.

### The System
