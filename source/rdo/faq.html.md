---
title: Frequently Asked Questions
category: documentation
authors: amuller, beni, dneary, garrett, jasonbrooks, jruzicka, jwinn, kashyap, rbowen,
  sgordon
wiki_category: Documentation
wiki_title: Frequently Asked Questions
wiki_revision_count: 42
wiki_last_updated: 2014-10-07
---

# Frequently Asked Questions

## What is RDO?

RDO is two things. It's a freely-available, community-supported distribution of OpenStack that runs on Red Hat Enterprise Linux, CentOS, Fedora, and their derivatives. In addition to providing a set of software packages, it's also a community of users of cloud computing platform on Red Hat Linux operating systems to get help and compare notes on running OpenStack.

## What does RDO stand for?

RDO is the RPM Distribution of OpenStack. It's a group of Rediculously
Dedicated OpenStackers who are here to help you [Rapidly Deploy OpenStack](/quickstart),
in a way that is Really Darned Obvious. RDO is [Rebuilt
Daily](http://trunk.rdoproject.org), Regularly Delivered, OpenStack.

## What is OpenStack?

OpenStack is an open source project for building a private or public infrastructure-as-a-service (IaaS) cloud running on standard hardware. You can learn more about it by visiting [www.openstack org](http://www.openstack.org/).

## Why is RDO needed?

Just as a traditional operating system relies on the hardware beneath it, so too does the OpenStack cloud operating system rely on the foundation of a hypervisor and OS platform. RDO makes it easy to install and deploy the most up-to-date OpenStack components on the industry's most trusted Linux platform, Red Hat Enterprise Linux. and on RHEL derivatives like Fedora, CentOS, and Scientific Linux.

## Why should I use an OpenStack distribution from Red Hat?

The OpenStack project benefits from a broad group of providers and distributors, but none match Red Hat's combination of production experience, technical expertise, and commitment to the open source way of producing software. Some of the largest production clouds in the world run on and are supported by Red Hat, and Red Hat engineers contribute to every layer of the OpenStack platform. From the Linux kernel and the KVM hypervisor to the top level OpenStack project components, Red Hat is at or near the top of the list in terms of number of developers and of contributions.

## For which distributions does RDO provide packages?

RDO targets CentOS, Fedora, and Red Hat Enterprise Linux, and their derivatives. Specifically, RDO packages are available for RHEL 6.3 or later (and CentOS 6.3+, ScientificLinux 6.3+ and other similar derivatives), as well as Fedora 18 and later.

## How is RDO different from upstream?

The OpenStack project develops code, and does not handle packaging for specific platforms. As a distribution of OpenStack, RDO packages the upstream OpenStack components to run well together on CentOS, Red Hat Enterprise Linux, Fedora, and their derivatives, and provides you with installation tools to make it easier for you to deploy OpenStack.

[Stable client branches](Clients) are maintained per release as part of RDO because client backward compatibility isn't guaranteed upstream.

## How can I participate?

Sign up to [ask.openstack](Get involved#ask.openstack) and help others with their RDO questions. Add your [User_stories](User_stories) to the wiki. Take well answered questions from ask.openstack and turn them into howto documents on the [Docs](Docs) pages.

Feel free to contribute any packaging and integration patches via our developer mailing lists, or propose improvements to OpenStack on the upstream Launchpad page. For more information, see [ getting involved](get involved).

## Is RDO a fork of OpenStack?

RDO is not a fork of OpenStack, but a community focused on packaging and integrating code from the upstream OpenStack project on CentOS, Red Hat Enterprise Linux and Fedora based platforms. Red Hat continues to participate in the development of the core OpenStack projects upstream, and all relevant patches and bug reports are routed directly to the OpenStack community codebase.

## What does RDO mean for OpenStack on Fedora?

Development of OpenStack for Fedora will continue unchanged. Fedora will continue to ship whatever the latest OpenStack release is, at the time when each Fedora release cycle hits its development freeze date. For Fedora users who want to run a more recent version of OpenStack than that which is available in the Fedora repository, we provide RPMs through RDO. For example, if you are running Fedora 20, and you would like to try Icehouse, then the RDO packages are for you. If you would like to run Havana on Fedora 19, then you should install OpenStack packages from the Fedora repository.

Users of OpenStack on Fedora are welcome to participate in the discusson on [ask.openstack.org](http://ask.openstack.org/), and in the Fedora Cloud SIG. There is more information on OpenStack in Fedora [in the Fedora project wiki](http://fedoraproject.org/wiki/OpenStack).

## How do I deploy RDO?

You have two options:

1. For Proof Of Concept (PoC) or Development environments, Packstack, an installation utility which uses Puppet modules to deploy OpenStack, is the primary tool. Instructions on installing RDO with Packstack are available on the [ quick start](Quickstart) page.
2. For Production, you should consider[TripleO](https://www.rdoproject.org/rdo-manager) to provision baremetal machines and deploy a production cloud environment.

## Where can I find help with RDO?

You can find documentation and get help through [ask.openstack](Get involved#ask.openstack), [IRC](http://webchat.freenode.net/?channels=rdo), or [mailing lists](Mailing_lists) and from others in the RDO community. And don't hesitate to answer someone else's question if you know the answer. You can find all of the ways you can get involved in the RDO community at [ getting involved](get involved).

## Can I buy commercial support for RDO?

No commercial support for RDO will be available from Red Hat. If you need support for your OpenStack deployments, Red Hat offers [Red Hat Enterprise Linux OpenStack Platform](https://access.redhat.com/products/red-hat-enterprise-linux-openstack-platform/) including a Partner Certification Program and Red Hat's award-winning support offering.

## What is the errata or updates policy for RDO?

RDO updates when the OpenStack project provides updates. RDO provides no lifecycle guarantees beyond what the upstream project provides. If you require additional guarantees see [Red Hat Enterprise Linux OpenStack Platform](https://access.redhat.com/products/red-hat-enterprise-linux-openstack-platform/).

## Can I upgrade between versions of RDO?

We plan to enable RDO users to upgrade between consecutive OpenStack versions (from Icehouse to Juno, for instance). The RDO project will strive to release updated OpenStack versions as soon as possible following upstream releases, on the order of hours to a few days.

## How often are bugfix updates of RDO made available?

RDO bugfix updates will be available every 8 weeks or so, in line with the release schedule of the upstream OpenStack project.

## Who is RDO for?

RDO aims to be the natural option for anyone that wants to run the most recently released version of OpenStack on RHEL, Fedora or their derivatives. Whether you are interested in running OpenStack on RHEL in a production environment, or doing a proof-of-concept deployment on CentOS, RDO is for you.

## Which OpenStack components does RDO include?

This is answered in detail on the [Projects In RDO](/rdo/projectsinrdo/)
page.

## Where is RDO built?

RDO is built using Koji infrastructure, similar to how Fedora packages are built. The build system is accessible at [Fedora Buildsystem](http://koji.fedoraproject.org/koji/).

## What is the relationship between RDO and Red Hat's commercial OpenStack product?

RDO is a community-supported OpenStack distribution that tracks the latest version of OpenStack upstream, beginning with OpenStack Grizzly. [Red Hat Enterprise Linux OpenStack Platform](http://www.redhat.com/en/technologies/linux-platforms/openstack-platform) is an enterprise-ready commercially-supported product from Red Hat.

<Category:Documentation>
