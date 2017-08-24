---
title: RDO Pike released
author: rbowen
date: 2017-09-01 07:00:00 UTC
tags: release,pike,rdo,openstack,upstream
published: false
comments: true
---

The RDO community is pleased to announce the general availability of the RDO build for OpenStack Pike for RPM-based distributions, CentOS Linux 7 and Red Hat Enterprise Linux.
RDO is suitable for building private, public, and hybrid clouds. Pike is the 16th release from the [OpenStack project](http://openstack.org), which is the work of more than 2300 contributors from around the world ([source](http://stackalytics.com/)).

The [RDO community project](https://www.rdoproject.org/) curates, packages, builds, tests and maintains a complete OpenStack component set for RHEL and CentOS Linux and is a member of the [CentOS Cloud Infrastructure SIG](https://wiki.centos.org/SpecialInterestGroup/Cloud).
The Cloud Infrastructure SIG focuses on delivering a great user experience for CentOS Linux users looking to build and maintain their own on-premise, public or hybrid clouds.

All work on RDO, and on the downstream release, Red Hat OpenStack Platform, is 100% open source, with all code changes going upstream first.

Interesting things in the Pike release include:

- [Ironic](https://github.com/openstack/ironic) now supports [booting from Cinder volumes](https://docs.openstack.org/ironic/pike/admin/boot-from-volume.html), [rolling upgrades](https://docs.openstack.org/ironic/pike/admin/upgrade-guide.html#rolling-upgrades) and [Redfish protocol](https://docs.openstack.org/ironic/pike/admin/drivers/redfish.html).

For cloud operators, RDO now provides packages for some new OpenStack Services:

- [Kuryr](https://github.com/openstack/kuryr) and [Kuryr-kubernetes](https://github.com/openstack/kuryr-kubernetes): an integration between OpenStack and Kubernetes networking.
- [Senlin](https://github.com/openstack/senlin): a clustering service for OpenStack clouds.

Some other notable additions:

- [Shade](https://github.com/openstack-infra/shade): a simple client library for interacting with OpenStack clouds, used by Ansible among others.
- [python-pankoclient](https://github.com/openstack/python-pankoclient):  a client library for the event storage and REST API for Ceilometer.
- [python-scciclient](https://github.com/openstack/python-scciclient): a ServerView Common Command Interface Client Library, for the FUJITSU iRMC S4 - integrated Remote Management Controller.
- We added OVN support to Packstack.
- We added support to install the Horizon plugins for several services in Packstack.

**Contributors**

During the Pike cycle, we saw contributions from the following individuals:

... Can someone generate a list of all contributors from git? ...

**Getting Started**

There are three ways to get started with RDO.

- To spin up a proof of concept cloud, quickly, and on limited hardware, try the [All-In-One Quickstart](https://www.rdoproject.org/install/packstack/). You can run RDO on a single node to get a feel for how it works.
- For a production deployment of RDO, use the [TripleO Quickstart](https://www.rdoproject.org/tripleo/) and you'll be running a production cloud in short order.
- Finally, if you want to try out OpenStack, but don't have the time or hardware to run it yourself, visit [TryStack](http://trystack.org/), where you can use a free public OpenStack instance, running RDO packages, to experiment with the OpenStack management interface and API, launch instances, configure networks, and generally familiarize yourself with OpenStack. (TryStack is not, at this time, running Pike, although it is running RDO.)


**Getting Help**
    
The RDO Project participates in a Q&A service at [ask.openstack.org](http://ask.openstack.org), for more developer-oriented content we recommend joining the [rdo-list mailing list](https://www.redhat.com/mailman/listinfo/rdo-list). Remember to post a brief introduction about yourself and your RDO story. You can also find extensive documentation on the [RDO docs site](https://www.rdoproject.org/use).

The #rdo channel on Freenode IRC is also an excellent place to find help and give help.

We also welcome comments and requests on the [CentOS mailing lists](https://lists.centos.org/) and the CentOS and TripleO IRC channels (#centos, #centos-devel, and #tripleo on irc.freenode.net), however we have a more focused audience in the RDO venues.


**Getting Involved**

To get involved in the OpenStack RPM packaging effort, see the [RDO community pages](https://www.rdoproject.org/contribute/) and the [CentOS Cloud SIG page](https://wiki.centos.org/SpecialInterestGroup/Cloud). See also the [RDO packaging documentation](https://www.rdoproject.org/packaging/).

Join us in #rdo on the Freenode IRC network, and follow us at [@RDOCommunity](http://twitter.com/rdocommunity) on Twitter. If you prefer Facebook, [we're there too](http://facebook.com/rdocommunity), and also [Google+](http://tm3.org/rdogplus).
