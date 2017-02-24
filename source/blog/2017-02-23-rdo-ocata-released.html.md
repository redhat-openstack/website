---
title: RDO Ocata Released
author: rbowen
date: 2017-02-23 14:14:52 UTC
tags: openstack,ocata,release,rdocommunity
comments: true
published: true
---

The RDO community is pleased to announce the general availability of the RDO build for OpenStack Ocata for RPM-based distributions, CentOS Linux 7 and Red Hat Enterprise Linux.
RDO is suitable for building private, public, and hybrid clouds. Ocata is the 15th release from the [OpenStack project](http://openstack.org), which is the work of more than 2500 contributors from around the world ([source](http://stackalytics.com/)).

The [RDO community project](https://www.rdoproject.org/) curates, packages, builds, tests and maintains a complete OpenStack component set for RHEL and CentOS Linux and is a member of the [CentOS Cloud Infrastructure SIG](https://wiki.centos.org/SpecialInterestGroup/Cloud). The Cloud Infrastructure SIG focuses on delivering a great user experience for CentOS Linux users looking to build and maintain their own on-premise, public or hybrid clouds.

All work on RDO, and on the downstream release, Red Hat OpenStack Platform, is 100% open source, with all code changes going upstream first.

Interesting things in the Ocata release include:

* [Significant Improvements](https://www.rdoproject.org/blog/2017/02/testing-rdo-with-tempest-new-features-in-ocata/) to Tempest and Tempest plugin packaging in RDO
* The [OpenStack-Ansible](https://docs.openstack.org/releasenotes/openstack-ansible/ocata.html#new-features) project now supports deployment on top of CentOS with the help of RDO-packaged dependencies

For cloud operators, RDO now provides packages for some new OpenStack Services:

* [Tacker](https://docs.openstack.org/developer/tacker/): an ETSI MANO NFV Orchestrator and VNF Manager
* [Congress](https://docs.openstack.org/developer/congress/architecture.html): an open policy framework for the cloud
* [Vitrage](https://docs.openstack.org/developer/vitrage/): the OpenStack RCA (Root Cause Analysis) Service
* [Kolla](https://github.com/openstack/kolla): The Kolla project provides tooling to build production-ready container images for deploying OpenStack clouds

Some other notable additions:

* [novajoin](https://github.com/openstack/novajoin): a dynamic vendordata plugin for the OpenStack nova metadata service to manage automatic host instantiation in an IPA server
* [ironic-ui](https://docs.openstack.org/developer/ironic-ui/): a new Horizon plugin to view and manage baremetal servers
* [python-virtualbmc](https://github.com/openstack/virtualbmc) VirtualBMC is a proxy that translates IPMI commands to libvirt calls. This allows projects such as OpenStack Ironic to test IPMI drivers using VMs.
* [python-muranoclient](https://github.com/openstack/python-muranoclient): a client for the Application Catalog service.
* [python-monascaclient](https://github.com/openstack/python-monascaclient): a client for the Monasca monitoring-as-a-service solution.
* [Shaker](http://pyshaker.readthedocs.io/en/latest/): the distributed data-plane testing tool built for OpenStack
* Multi-architecture support: aarch64 builds are now provided through an experimental repository - enable the RDO 'testing' repositories to get started

From a networking perspective, we have added some new Neutron plugins that can help Cloud users and operators to address new use cases and scenarios:

* [networking-bagpipe](https://docs.openstack.org/developer/networking-bagpipe/): a mechanism driver for Neutron ML2 plugin using BGP E-VPNs/IP VPNs as a backend
* [networking-bgpvpn](https://docs.openstack.org/developer/networking-bgpvpn/): an API and framework to interconnect BGP/MPLS VPNs to Openstack Neutron networks
* [networking-fujitsu](https://github.com/openstack/networking-fujitsu): FUJITSU ML2 plugins/drivers for OpenStack Neutron
* [networking-l2gw](https://github.com/openstack/networking-l2gw): APIs and implementations to support L2 Gateways in Neutron
* [networking-sfc](https://github.com/openstack/networking-sfc): APIs and implementations to support Service Function Chaining in Neutron

From the [Packstack](https://github.com/openstack/packstack) side, we have several improvements:

* We have added support to install Panko and Magnum
* Puppet 4 is now supported, and we have updated our manifests to cover the latest changes in the supported projects

**Getting Started**

There are three ways to get started with RDO.

To spin up a proof of concept cloud, quickly, and on limited hardware, try the [All-In-One Quickstart](https://www.rdoproject.org/install/quickstart/). You can run RDO on a single node to get a feel for how it works.

For a production deployment of RDO, use the [TripleO Quickstart](https://www.rdoproject.org/tripleo/) and you'll be running a production cloud in short order.

Finally, if you want to try out OpenStack, but don't have the time or hardware to run it yourself, visit [TryStack](http://trystack.org/), where you can use a free public OpenStack instance, running RDO packages, to experiment with the OpenStack management interface and API, launch instances, configure networks, and generally familiarize yourself with OpenStack. (TryStack is not, at this time, running Ocata, although it is running RDO.)

**Getting Help**
    
The RDO Project participates in a Q&A service at [ask.openstack.org](http://ask.openstack.org), for more developer-oriented content we recommend joining the [rdo-list mailing list](https://www.redhat.com/mailman/listinfo/rdo-list). Remember to post a brief introduction about yourself and your RDO story. You can also find extensive documentation on the [RDO docs site](https://www.rdoproject.org/documentation).

The #rdo channel on Freenode IRC is also an excellent place to find help and give help.

We also welcome comments and requests on the  [CentOS mailing lists](https://lists.centos.org/) and the CentOS and TripleO IRC channels (#centos, #centos-devel, and #tripleo on irc.freenode.net), however we have a more focused audience in the RDO venues.


**Getting Involved**

To get involved in the OpenStack RPM packaging effort, see the [RDO community pages](https://www.rdoproject.org/community/) and the [CentOS Cloud SIG page](https://wiki.centos.org/SpecialInterestGroup/Cloud). See also the [RDO packaging documentation](https://www.rdoproject.org/packaging/).

Join us in #rdo on the Freenode IRC network, and follow us at [@RDOCommunity](http://twitter.com/rdocommunity) on Twitter. If you prefer Facebook, [we're there too](http://facebook.com/rdocommunity), and also [Google+](http://tm3.org/rdogplus).
