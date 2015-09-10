---
title: OpenStack Havana Release
date: 2013-10-17 10:47:45
author: rbowen
---

RDO congratulates the OpenStack Foundation on the [release of OpenStack 2013.2, code named Havana](http://www.openstack.org/software/havana/press-release), the latest version of the OpenStack cloud platform.

And, right on the heels of that, we're pleased to announce RDO Havana, our packaging of OpenStack Havana for easy deployment on Red Hat derivative operating systems - RHEL, Fedora, CentOS, Scientific Linux, and other RPM-based linux distributions. You can obtain and deploy RDO Havana immedately using the instructions at http://openstack.redhat.com/Quickstart

OpenStack Havana introduces new functionality, and numerous improvements to existing functionality, and was created by contributors from over 100 different companies, as well as numerous independent developers, making thousands of different changes since the Grizzly release in April. (See http://www.stackalytics.com/ if you're into statistics.) We're very proud to have been part of that, and we have a lot to be proud of.

Some of the most important changes in OpenStack Havana are:

* Heat - https://wiki.openstack.org/wiki/Heat - is an orchestration service which provides a way to automate the deployment of infrastructure and applications on top of OpenStack services, using declarative templates. Heat completed the incubation process and graduated to be an integrated OpenStack project for Havana.

* Ceilometer - https://wiki.openstack.org/wiki/Ceilometer - provides monitoring and metering services for OpenStack, to collect and measure usage data which can then be consumed by a variety of other services. Ceilometer, like Heat, has been in incubation, and is now an integrated OpenStack project.

* Keystone - http://docs.openstack.org/developer/keystone/ - the identity manager for OpenStack, is much more configurable in the new version. Of greatest interest is the addition of the ability to store authentication (credentials) and authorization information in separate back ends. For example, you can now tie login information to your corporate LDAP (or Active Directory) server, while having role and group management handled on the OpenStack SQL server. This makes OpenStack much easier to deploy into an existing organization, and less hassle to administer.

* Neutron - https://wiki.openstack.org/wiki/Neutron - formerly named Quantum, has a gorgeous new clickable interface in Horizon (the OpenStack dashboard) where you can visualize what your network configuration looks like, and modify portions of it in a quick and intuitive way.

And numerous other changes - thousands of them - make up this release. You can read the full release notes at https://wiki.openstack.org/wiki/ReleaseNotes/Havana

Looking forward, we're excited about what's coming in future releases. And the best place to see what's coming is to look at the projects that are in incubation. These include:

* Savanna: enables deployment of Hadoop clusters on top of OpenStack.
* Marconi: queuing and notification services.
* TripleO: operating OpenStack clouds running on top of OpenStack

and so many more. We're closely watching these projects, and participating in many of them, so that we can help create that future. Because, while the RDO project is about packaging and distributing upstream OpenStack, most of the folks involved in RDO are also actively working on the next release of OpenStack, even as we are celebrating this release.

The fastest way to get up and running on the new release is via the Quickstart instructions, at http://openstack.redhat.com/Quickstart Then, check out our docs to find out more about how to launch a VM (http://openstack.redhat.com/Running_an_instance), configure your network (http://openstack.redhat.com/Neutron_with_OVS_and_VLANs) or deploy applications (http://openstack.redhat.com/Deploy_an_application_with_Heat). Ask your questions, and tell us how you're using RDO, in the RDO forum (http://openstack.redhat.com/forum). Come talk with us at conferences, meetups and other events (http://openstack.redhat.com/Events). Come be part of our community.
