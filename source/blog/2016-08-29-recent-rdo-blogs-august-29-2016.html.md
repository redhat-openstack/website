---
title: Recent RDO blogs, August 29, 2016
author: rbowen
date: 2016-08-29 17:36:28 UTC
tags: blog, openstack
comments: true
published: true
---

It's been a few weeks since I posted a blog update, and we've had some great posts in the meantime. Here's what RDO enthusiasts have been blogging about for the last few weeks.

**Native DHCP support in OVN** by Numan Siddique 

> Recently native DHCP support has been added to OVN. In this post we will see how native DHCP is supported in OVN and how it is used by OpenStack Neutron OVN ML2 driver. The code which supports native DHCP can be found here.

... read more at [http://tm3.org/8d](http://tm3.org/8d)

**Manual validation of Cinder A/A patches** by Gorka Eguileor

> In the Cinder Midcycle I agreed to create some sort of document explaining the manual tests I’ve been doing to validate the work on Cinder’s Active-Active High Availability -as a starting point for other testers and for the automation of the tests- and writing a blog post was the most convenient way for me to do so, so here it is.

... read more at [http://tm3.org/8e](http://tm3.org/8e)

**Exploring YAQL Expressions** by Lars Kellogg-Stedman

> The Newton release of Heat adds support for a yaql intrinsic function, which allows you to evaluate yaql expressions in your Heat templates. Unfortunately, the existing yaql documentation is somewhat limited, and does not offer examples of many of yaql's more advanced features.

... read more at [http://tm3.org/8f](http://tm3.org/8f)

**Tripleo HA Federation Proof-of-Concept** by Adam Young

> Keystone has supported identity federation for several releases. I have been working on a proof-of-concept integration of identity federation in a TripleO deployment. I was able to successfully login to Horizon via WebSSO, and want to share my notes.

... read more at [http://tm3.org/8g](http://tm3.org/8g)

**TripleO Deploy Artifacts (and puppet development workflow)** by Steve Hardy

> For a while now, TripleO has supported a "DeployArtifacts" interface, aimed at making it easier to deploy modified/additional files on your overcloud, without the overhead of frequently rebuilding images.

... read more at [http://tm3.org/8h](http://tm3.org/8h)

**TripleO deep dive session #6 (Overcloud - Physical network)** by Carlos Camacho

> This is the sixth video from a series of “Deep Dive” sessions related to TripleO deployments.

... read more at [http://tm3.org/8i](http://tm3.org/8i)

**Improving QEMU security part 7: TLS support for migration** by  Daniel Berrange

> This blog is part 7 of a series I am writing about work I’ve completed over the past few releases to improve QEMU security related features.

... read more at [http://tm3.org/8j](http://tm3.org/8j)

**Running Unit Tests on Old Versions of Keystone** by Adam Young

> Just because Icehouse is EOL does not mean no one is running it. One part of my job is back-porting patches to older versions of Keystone that my Company supports.

... read more at [http://tm3.org/8k](http://tm3.org/8k)

**BAND-AID for OOM issues with TripleO manual deployments** by Carlos Camacho

> First in the Undercloud, when deploying stacks you might find that heat-engine (4 workers) takes lot of RAM, in this case for specific usage peaks can be useful to have a swap file. In order to have this swap file enabled and used by the OS execute the following instructions in the Undercloud:

... read more at [http://tm3.org/8l](http://tm3.org/8l)

**Debugging submissions errors in TripleO CI** by Carlos Camacho

> Landing upstream submissions might be hard if you are not passing all the CI jobs that try to check that your code actually works. Let’s assume that CI is working properly without any kind of infra issue or without any error introduced by mistake from other submissions. In which case, we might ending having something like:

... read more at [http://tm3.org/8m](http://tm3.org/8m)

**Ceph, TripleO and the Newton release** by Giulio Fidente

> Time to roll up some notes on the status of Ceph in TripleO. The majority of these functionalities were available in the Mitaka release too but the examples work with code from the Newton release so they might not apply identical to Mitaka.

... read more at [http://tm3.org/8n](http://tm3.org/8n)

