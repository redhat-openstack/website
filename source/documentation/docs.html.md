---
title: Docs
category: documentation
authors: admin, apevec, awheeler, ccrouch, dansmith, dneary, fale, garrett, jlibosva,
  jruzicka, larsks, marafa, otherwiseguy, pixelbeat, pmyers, radez, rbowen, rkukura,
  rossturk, sdake, sgordon, shardy, strider, thoraxe
wiki_category: Documentation
wiki_title: Docs
wiki_revision_count: 105
wiki_last_updated: 2015-07-16
---

# Docs

(Paragraph here about documentation)

Links here, including [Get Involved](Get Involved)

## FAQ

<div class="note">
This is a copy/paste from <https://rhoswiki-dneary.rhcloud.com/index.php/RDO_FAQ> (it is current as of 25 Feb 2013)

</div>
### What is RDO?

RDO (Red Hat Distribution of OpenStack) is a freely-available, community-supported distribution of OpenStack that runs on Red Hat Enterprise Linux, Fedora, and their derivatives. In addition to providing a set of software packages, RDO is a place for users of cloud computing platform on Red Hat Linux operating systems to get help and compare notes on running OpenStack.

### What is OpenStack?

OpenStack is an open source project for building a private or public infrastructure-as-a-service (IaaS) cloud running on standard hardware. OpenStack gives you Amazon EC2 like capabilities in your datacenter. You can learn more about it by visiting www.openstack org. [from <http://www.redhat.com/openstack/FAQ/>]

### Why is RDO needed?

Just as a traditional operating system relies on the hardware beneath it, so too does the OpenStack cloud operating system rely on the foundation of a hypervisor and OS platform. RDO makes it easy to install and deploy the most up-to-date OpenStack components on the industry's most trusted Linux platform.

### Why Red Hat?

The OpenStack project benefits from a broad group of providers and distributors, but none match Red Hat's combination of production experience, technical expertise, and commitment to the open source way of producing software. Some of the largest production clouds in the world run on and are supported by Red Hat, and Red Hat engineers contribute to every layer of the OpenStack platform. From the Linux kernel and the KVM hypervisor to the top level OpenStack project components, Red Hat is at or near the top of the list in terms of number of developers and of contributions.

### Which distributions does RDO support?

RDO targets Red Hat Enterprise Linux, Fedora, and their derivatives. Specifically, RDO supports RHEL 6.3 or later (and CentOS 6.3+, ScientificLinux 6.3+ and other similar derivatives), as well as Fedora 18 and later.

NB: el6.3 does not have openvswitch in kernel Requires: kernel >= 2.6.32-343

### How is RDO different from upstream?

The OpenStack project develops code, and does not handle packaging for specific platforms. As a distribution of OpenStack, RDO packages up the upstream OpenStack components to run well together on Red Hat Enterprise Linux, Fedora, and their derivatives.

### How do I participate?

Feel free to contribute any packaging and integration patches via our mailling lists, and get involved on the forum helping other users of RDO. For more information, see PARTICIPATION_PAGE.

### Is RDO a stand alone project?

RDO is not a fork of OpenStack, but a community focused on packaging and integrating code from the upstream OpenStack project on particular Linux platforms. Red Hat continues to participate in the development of the core OpenStack projects upstream, and all relevant patches and bug reports are routed directly to the OpenStack community codebase.

### What does RDO mean for OpenStack EPEL?

RDO replaces OpenStack for EPEL. The current OpenStack release in EPEL, based on OpenStack Folsom, will continue to work in EPEL. Users who wish to upgrade to Grizzly should move to RDO.

### What does RDO mean for OpenStack on Fedora?

Development of OpenStack for Fedora will continue unchanged. Users of OpenStack on Fedora are welcome to participate in the Red Hat OpenStack community forums on openstack.redhat.com and in the Fedora Cloud SIG.

### How do I deploy RDO?

Packstack, an installation utility which uses Puppet modules to deploy OpenStack, will be the primary tool for deploying RDO. Instructions on using Packstack, and the YUM repositories that provide RDO packages, are available at <http://ftp.redhat.com/pub/redhat/rdo>, and on the RDO wiki at DOWNLOAD_PAGE.

### Where can I find help with RDO?

You can find documentation and get help through the forums, IRC, or mailing lists and from others in the RDO community.

### Can I buy formal support for RDO?

No formal Web or phone support for RDO will be available from Red Hat. Red Hat's supported product line for OpenStack can be found at redhat.com/openstack.

### What is the errata or updates policy for RDO?

RDO updates when the upstream project provides updates. RDO provides no lifecycle guarentees beyond what the upstream project provides. If you require additional guarantees see RHOS at redhat.com/openstack.

### Can I upgrade between versions of RDO?

[NEED CK] RDO users will be able to upgrade between consecutive OpenStack versions (from Folsom to Grizzly, for instance). The RDO project will strive to release updated OpenStack versions as soon as possible following upstream releases, on the order of hours to a few days.

### How often are bugfix updates of RDO made available?

RDO bugfix updates will be available every 8 weeks or so, in line with the release schedule of the upstream OpenStack project.

### Who is RDO for?

RDO aims to be the 'best' (easiest, etc.) option for anyone that wants to run OpenStack.

### Which OpenStack components does RDO include?

RDO includes all "integrated" OpenStack components (Nova, Glance, Keystone, Cinder, Quantum and Horizon), OpenStack client libraries and CLIs, as well as the packstack installer and assoicated puppet modules. In addition, RDO includes those projects which are Incubating in Grizzly, i.e. Heat and Ceilometer. OpenStack incubation projects Heat, Ceilometer [maybe], and Oz. For more details, see the RDO release notes.

### Where is RDO built?

RDO is built using Koji infrastructure, similar to how Fedora packages are built. The build system is accessible at WHERE. [CK is it separate koji, or same koji as Fedora? Currently looking at using Copr <http://copr-fe.cloud.fedoraproject.org/> ]

### What is the relationship between RDO and Red Hat's commercial OpenStack product?

RDO is a community-supported OpenStack distribution that tracks the latest version of OpenStack upstream. RHOS is a commercially-supported product from Red Hat. Initially, RHOS will be based on the Folsom release of OpenStack.
