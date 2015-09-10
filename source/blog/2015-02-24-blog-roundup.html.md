---
title: Blog roundup, February 24 2015
date: 2015-02-24 12:29:09
author: rbowen
---

Here's what RDO engineers have been writing about over the past week.

If you're writing about RDO, or about OpenStack on CentOS, Fedora or RHEL, and you're not on my list, please let me know!

**Stupid Pacemaker XML tricks**, by Lars Kellogg-Stedman

> I've recently spent some time working with Pacemaker, and ended up with an interesting collection of XPath snippets that I am publishing here for your use and/or amusement.

... read more at http://tm3.org/blog96

**Accelerating OpenStack adoption: Red Hat Enterprise Linux OpenStack Platform 6!** by Jeff Jameson

> On Tuesday February 17th, we announced the general availability of Red Hat Enterprise Linux OpenStack Platform 6, Red Hat’s fourth release of the commercial OpenStack offering to the market.

... read more at http://tm3.org/blog97

**Nova and its use of Olso Incubator Guru Meditation Reports**, by Daniel Berrange

> This blogs describes a error reporting / troubleshooting feature added to Nova a while back which people are probably not generally aware of.

... read more at http://tm3.org/blog98

**Nova metadata recorded in libvirt guest instance XML**, by Daniel Berrange

> One of the issues encountered when debugging libvirt guest problems with Nova, is that it isn’t always entirely obvious why the guest XML is configured the way it is. For a while now, libvirt has had the ability to record arbitrary application specific metadata in the guest XML. Each application simply declares the XML namespace it wishes to use and can then record whatever it wants. Libvirt will treat this metadata as a black box, never attempting to interpret or modify it. In the Juno release I worked on a blueprint to make use of this feature to record some interesting information about Nova.

... read more at http://tm3.org/blog99

**A distributed OpenStack installation with 100 Nova compute nodes**, by Ravello

> This blog will cover my experience with scaling Redhat’s Enterprise Linux OpenStack platform to 100 compute nodes behind a single controller and dedicated neutron networking node on the Ravello Cloud.

... read more at http://tm3.org/blog100
