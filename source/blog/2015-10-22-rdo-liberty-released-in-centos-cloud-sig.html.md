---
title: RDO Liberty released in CentOS Cloud SIG
author: rbowen
date: 2015-10-22 13:34:54 UTC
tags: rdo, release, liberty, centos
comments: true
published: true
---

We are pleased to announce the general availability of the RDO build for
OpenStack Liberty for CentOS Linux 7 x86\_64, suitable for building
private, public and hybrid clouds. OpenStack Liberty is the 12th release of the open source software collaboratively built by a large number of
contributors around the OpenStack.org project space.

The [RDO community project](https://www.rdoproject.org/) curates,
packages, builds, tests and maintains a complete OpenStack component set
for RHEL and CentOS Linux and is a founding member of the [CentOS Cloud Infrastructure SIG](https://wiki.centos.org/SpecialInterestGroup/Cloud). The Cloud Infrastructure SIG focus on delivering a great user
experience for CentOS Linux users looking to build and maintain their
own onpremise, public or hybrid clouds.

In addition to the comprehensive OpenStack services, libraries and
clients, this release also provides Packstack, a simple installer for
proof-of-concept installations, as small as a single all-in-one box and
[RDO Manager](https://www.rdoproject.org/RDO-Manager), an OpenStack
deployment and management tool for production environments based on the
OpenStack TripleO project.

## QuickStart:

Ensure you have a fully updated CentOS Linux 7/x86\_64 machine, and run :

	sudo yum install centos-release-openstack-liberty
	sudo yum install openstack-packstack
	packstack --allinone

For a more detailed quickstart please refer to the [RDO Project hosted
guide](https://www.rdoproject.org/QuickStart).

For RDO Manager consult the [RDO Manager page](https://www.rdoproject.org/RDO-Manager).

RDO project is closely tracking upstream OpenStack projects using the [Delorean tool](http://trunk.rdoproject.org/) which is producing RPM packages from upstream development
branches.

Since the previous OpenStack Kilo release, RDO is participating
in the Cloud SIG and using CentOS provided infrastructure.
Towards the end of developement cycle packages are imported into [CentOS Cloud SIG buildsystem](http://wiki.centos.org/HowTos/CommunityBuildSystem) and get eventually published in [Cloud SIG repositories](http://mirror.centos.org/centos/7/cloud/x86_64/).

## Getting Help:

The RDO Project provides a Q&A service at ask.openstack.org, for more
developer oriented content we recommend joining the [rdo-list mailing list](https://www.redhat.com/mailman/listinfo/rdo-list). Remember to post
a brief introduction about yourself and your RDO story.
You can also find extensive documentation [on the RDO website](https://www.rdoproject.org/documentation).	

We also welcome comments and requests on the [CentOS Mailing lists](https://lists.centos.org/) and the CentOS IRC Channels ( \#centos on
irc.freenode.net ), however we have a more focused audience in the RDO venues.

To get involved in the OpenStack RPM packaging effort, see [the "Get Involved" docs](https://www.rdoproject.org/Get_involved) and [the Cloud SIG docs](https://wiki.centos.org/SpecialInterestGroup/Cloud)  Join us in #rdo on the
Freenode IRC network, and follow us at [@RDOCommunity on Twitter](http://twitter.com/rdocommunity). And, if you're going to 
be in Tokyo for the OpenStack Summit next week, join us on Wednesday at
lunch for the [RDO community meetup](http://sched.co/4MYy).

I'd like to thank all RDO developers and CentOS Project for
their effort and support resulting in this release,
especially

* dmsimard - for continuously improving RDO CI
* jpena - for keeping Delorean service up and running
* jruzicka - for the rdopkg auto-magic
* number80 - for countless reviews and packaging wisdom
* social - for puppet module mastery
* trown - for leading RDO Manager side of the show!

Special thanks to all the folks who helped with last minute testing in
IRC \#rdo channel !

Thanks, 

Alan Pevec

Cloud SIG and RDO project member
