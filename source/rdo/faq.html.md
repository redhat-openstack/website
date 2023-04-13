---
title: Frequently Asked Questions
category: documentation
authors: amuller, beni, dneary, garrett, jasonbrooks, jruzicka, jwinn, kashyap, rbowen,
  sgordon
---

# Frequently Asked Questions

## What is RDO?

RDO is two things. It's a freely-available, community-supported distribution of OpenStack that runs on Red Hat Enterprise Linux (RHEL) and its derivatives, such as [CentOS Stream](https://www.centos.org/centos-stream/).

In addition to providing a set of software packages, RDO is also a community of users of cloud computing platform on Red Hat-based operating systems to get help and compare notes on running OpenStack.

RDO aims to be the natural option for anyone that wants to run the most recently released version of OpenStack on supported systems. Whether you are interested in running OpenStack on RHEL in a production environment, or doing a proof of concept deployment on CentOS Stream, RDO is for you.

## What does RDO stand for?

RDO is the RPM Distribution of OpenStack. It's a group of Rediculously
Dedicated OpenStackers who are here to help you [Rapidly Deploy OpenStack](/install/packstack/),
in a way that is Really Darned Obvious. RDO is [Rebuilt
Daily](http://trunk.rdoproject.org), Regularly Delivered, OpenStack.

## What is OpenStack?

OpenStack is an open source project for building a private or public infrastructure-as-a-service (IaaS) cloud running on standard hardware. You can learn more about it by visiting [www.openstack org](http://www.openstack.org/).

## Why is RDO needed?

Just as a traditional operating system relies on the hardware beneath it, so too does the OpenStack cloud operating system rely on the foundation of a hypervisor and OS platform. RDO makes it easy to install and deploy the most up-to-date OpenStack components on the industry's most trusted Linux platform, Red Hat Enterprise Linux. and on RHEL derivatives like CentOS Stream, and Scientific Linux.

## Why should I use an OpenStack distribution from Red Hat?

The OpenStack project benefits from a broad group of providers and distributors, but none match Red Hat's combination of production experience, technical expertise, and commitment to the open source way of producing software. Some of the largest production clouds in the world run on and are supported by Red Hat, and Red Hat engineers contribute to every layer of the OpenStack platform. From the Linux kernel and the KVM hypervisor to the top level OpenStack project components, Red Hat is at or near the top of the list in terms of number of developers and of contributions.

## For which distributions does RDO provide packages?

RDO targets Red Hat Enterprise Linux, CentOS Stream and their derivatives. Specifically, RDO packages are available for RHEL 7.0 or later (and CentOS 7.0, Scientific Linux 7.0 and other similar derivatives). More information is available at [Release-cadence](/rdo/release-cadence/).

## How is RDO different from upstream?

The OpenStack project develops code, and does not handle packaging for specific platforms. As a distribution of OpenStack, RDO packages the upstream OpenStack components to run well together on CentOS Stream, Red Hat Enterprise Linux and their derivatives, and provides you with installation tools to make it easier for you to deploy OpenStack.

[Stable client branches](/rdo/release-cadence) are maintained per release as part of RDO because client backward compatibility isn't guaranteed upstream.

## How can I participate?

Sign up to [ask.openstack](https://ask.openstack.org/) and help others with their RDO questions. Add your [user stories](/user-stories/). Take well answered questions from ask.openstack and turn them into howto documents on the [RDO documentation](/documentation/) pages.

Feel free to contribute any packaging and integration patches via our developer mailing lists, or propose improvements to OpenStack on the upstream Launchpad page. For more information, see [getting involved](/contribute/).

## Is RDO a fork of OpenStack?

RDO is not a fork of OpenStack, but a community focused on packaging and integrating code from the upstream OpenStack project on CentOS Stream and Red Hat Enterprise Linux. Red Hat continues to participate in the development of the core OpenStack projects upstream, and all relevant patches and bug reports are routed directly to the OpenStack community code base.

## How do I deploy RDO?

You have multiple options, including:

1. For production environments, consider [TripleO](/tripleo) to provision bare-metal machines and deploy a production cloud environment of an OpenStack Zed or earlier release.

2. For proof of concept (PoC) environments, Packstack, an installation utility which uses Puppet modules to deploy OpenStack, is the primary tool. Instructions on installing RDO with Packstack are available on the [Packstack quickstart](/install/packstack) page.

3. For manual deployments using RDO packages, read the upstream [OpenStack Installation Tutorial](https://docs.openstack.org/install-guide/).

## Where can I find help with RDO?

You can find documentation and get help through [ask.openstack.org](https://ask.openstack.org/), [IRC](/contribute/#discuss), or [mailing lists](/contribute/mailing-lists/) and from others in the RDO community. And don't hesitate to answer someone else's question if you know the answer. You can find all of the ways you can get involved in the RDO community at [Get involved](/contribute/).

## Can I buy commercial support for RDO?

No commercial support for RDO will be available from Red Hat. If you need support for your OpenStack deployments, Red Hat offers [Red Hat OpenStack Platform](https://access.redhat.com/products/red-hat-openstack-platform) including a Partner Certification Program and Red Hat's award-winning support offering.

## What is the errata or updates policy for RDO?

RDO updates when the OpenStack project provides updates. RDO provides no lifecycle guarantees beyond what the upstream project provides. If you require additional guarantees, see [Red Hat OpenStack Platform](https://access.redhat.com/products/red-hat-openstack-platform).

## Can I upgrade between versions of RDO?

RDO users are advised to upgrade between consecutive OpenStack versions. The RDO project strives to release updated OpenStack versions as soon as possible following upstream releases, on the order of hours to a few days.

The upgrade process differs depending on whether your deployment is TripleO-based or manual. For more information on upgrading with TripleO, see the [TripleO documentation](https://docs.openstack.org/developer/tripleo-docs/). For more information on manual upgrades, see the [Upgrading documentation](/install/upgrading-rdo/).

## How often are bug fix updates of RDO made available?

We make RDO bug fix updates available asynchronously by following the stable bug fix releases of upstream OpenStack projects.

## Which OpenStack components does RDO include?

This is answered in detail on the [Projects in RDO](/rdo/projectsinrdo/) page.

## Where is RDO built?

RDO is built using CentOS infrastructure, similar to how CentOS packages are built. The build system is accessible at [CBS](http://cbs.centos.org/koji/).

## What is the relationship between RDO and Red Hat's commercial OpenStack product?

RDO is a community-supported OpenStack distribution that tracks the latest version of OpenStack upstream, beginning with OpenStack Grizzly. [Red Hat OpenStack Platform](http://www.redhat.com/en/technologies/linux-platforms/openstack-platform) is an enterprise-ready commercially-supported product from Red Hat.
