---
title: OpenStack Summit Hong Kong
authors: rbowen
wiki_title: OpenStack Summit Hong Kong
wiki_revision_count: 30
wiki_last_updated: 2013-08-22
---

# OpenStack Summit Hong Kong

The following talks have been submitted by Red Hat employees for the [OpenStack Summit, November 5-8, in Hong Kong](http://www.openstack.org/summit/openstack-summit-hong-kong-2013/). We would be delighted if you would consider [voting for these talks](http://www.openstack.org/rate/). The vote closes on Sunday, November 25th.

===Ceilometer+Heat=Alarming=== Eoghan Glynn, Red Hat

Ceilometer is a tool that collects usage and performance data, while Heat orchestrates complex deployments on top of OpenStack. Heat aims to autoscale its deployments, scaling up when they're running hot and scaling back when idle.

Ceilometer can access decisive data and trigger the appropriate actions in Heat. The result of these two OpenStack projects meeting is value creation in the form of an alarming API in Ceilometer and its consumption in Heat.

In this session, speakers from eNovance and Red Hat will detail how the two projects work together to deliver autoscaling, providing both background information and a technical deep dive.

[Vote here](http://www.openstack.org/rate/Presentation/ceilometer-heat-alarming)

## Getting started with OpenStack

Dan Radez

In this session, Red Hat’s Dan Radez will demonstrate how to set up a multi-node OpenStack cloud using the Packstack utility. He will perform the installation on an RPM-based system. Participants will be introduced to a range of cloud functionality, including:

Adding new users Adding an image to glance Defining networks in Neutron Starting a new virtual server Creating and attaching persistent storage volumes to virtual servers Storing objects in Swift Using the Horizon user interface

Dan will also provide a summary of each of these components and explain how they interact with each other.

[Vote here](http://www.openstack.org/rate/Presentation/radez-getting-started-with-openstack)

## TryStack :: Public OpenStack Cluster

Dan Radez

TryStack is a publicly available OpenStack cluster and is available for anyone who wants to try OpenStack. The deployment is managed by Foreman and includes a pair of highly available control nodes. Both Cinder and Swift are deployed. TryStack has been installed with Folsom and upgraded to Grizzly this year.

In this session, Dan Radez from Red Hat will: Walk attendees through the cluster architecture and the Grizzly upgrade process Provide lessons learned over the past year Discuss Grizzly features Provide the roadmap to upgrade to Havanna

[Vote here](http://www.openstack.org/rate/Presentation/trystack-public-openstack-cluster)

## Highly Available Control Services

Dan Radez

OpenStack has many moving parts that need to be taken into consideration when high availability control services are deployed. In this session, Dan Radez will walk attendees through the necessary considerations to deploy highly available control services, presenting multiple options where available. Attendees will leave the session better prepared to architect their OpenStack control nodes.

[Vote here](http://www.openstack.org/rate/Presentation/highly-available-control-services)

## Customizing Horizon and extending Horizon through plugins

Matthias Runge

Currently, there is no plugin architecture for Horizon. In order to customize the OpenStack dashboard, a user has to change his/her source code and/or configuration files, which is nearly impossible when using software packages managed by RPM.

This session will be broken into two parts. In the first, Red Hat’s Matthias Runge will describe how to customize the OpenStack dashboard both with and without RPM packages. In the second, Matthias will lead a brainstorming session in order to collect ideas for improving Horizon to enable plugins automatically.

## OpenShift by Red Hat: The De facto PaaS for OpenStack

Krishnan Subramanian

As OpenStack matures and grows in the infrastructure market, the next logical step will be to focus on the Platform-as-a-Service (PaaS) layer. PaaS is emerging as a logical choice as enterprises understand the value of container-based application delivery platforms over virtual machines.

In this session, Krishnan Subramanian will: Detail why the alignment of the OpenStack project and a PaaS platform is critical Provide use cases that demonstrate how tight integration with a PaaS platform benefits OpenStack in the enterprise market Briefly discuss the current PaaS market Discuss the various factors that need to be considered before an OpenStack and PaaS marriage can work effectively

This session will include roadmap and strategy information, beyond the infrastructure services. It is targeted at the developer community, vendors, and enterprise buyers. We expect the discussion to be a starting point for developing a framework where OpenShift and OpenStack can emerge as standards in the coming years.

[Vote here](http://www.openstack.org/rate/Presentation/why-openshift-should-be-defacto-paas-layer-for-openstack)

## OpenStack User Personas: An Update

Dave Neary

Earlier this year, Dave Neary presented the theory of personas to OpenStack Summit Portland attendees. Attendees were excited about creating a set of personas for the OpenStack project, as they allow you to have a much clearer idea of your target audience, what their needs are, and how you can reach them. They also allow much easier communication around feature discussions, user interface design, and marketing strategy.

Based on data from the user committee survey (still waiting for access!), a personas working group is being created to answer the question: "Who uses OpenStack?" In this session, Dave will return to present an initial set of OpenStack personas, discuss how they were created, and detail what conclusions we can draw from them.

[Vote here](http://www.openstack.org/rate/Presentation/openstack-user-personas-6-months-on)

## OpenStack Neutron and OVS concepts for non-networking people

Dave Neary

Not everyone is a networking expert. If you're not sure what the difference between L2 and L3 networking concepts are, or if you're confused about the roles filled by OVS, OpenFlow and Neutron, this talk might be for you.

When Neutron was integrated with PackStack and the RDO OpenStack distribution by default, after the Grizzly release, the speaker ran headlong into networking, namespaces, Open vSwitch, iproute2, Linux Bridge, and a number of other concepts he had never had to care about before. With perseverance, a ton of Q&A, and a good deal of trial and error, he has gained a sufficient understanding of the underlying concepts and technology to share.

If you are curious about SDN and what problems it solves, but you are not familiar with the Linux networking and virtualization toolchain, this session will answer many of your questions. Dave Neary will introduce you to some sample network topologies and describe how to implement them in Neutron. He will also discuss the toolchain and techniques you will need to troubleshoot any issues you might have along the way.

[Vote here](http://www.openstack.org/rate/Presentation/openstack-neutron-and-ovs-concepts-for-non-networking-people)

## Unifying the Management of OpenStack, Public Cloud, and Datacenter Virtualization

James Labocki and Oleg Barenboim

Adding an OpenStack environment into an already complex IT architecture threatens to overwhelm IT staff who are already spending countless hours managing existing IT architectures. Is it possible to unify the operational management of existing datacenter virtualization with an OpenStack deployment? What about adding a public cloud provider into the mix? What about adding a Platform-as-a-Service (PaaS)?

In this session, Oleg and James will demonstrate how Red Hat CloudForms can provide a unified operational management framework for all of these scenarios and help IT staff keep their sanity in the process. Specifically, they will explain how to:

Discover and monitor new and existing OpenStack environments Provide showback and chargeback of guest workloads Provision workloads via self-service catalogs to OpenStack Create migration analysis reports from datacenter virtualization platforms (including Red Hat Enterprise Virtualization, Microsoft Hyper-V, VMware vSphere) to OpenStack

James and Oleg will also provide an overview of Red Hat's open hybrid cloud-based architecture and CloudForms' upstream open source community. Attendees will leave this session with a better understanding of how to unify operations management of OpenStack with their existing datacenter virtualization and public clouds solutions.

[Vote here](http://www.openstack.org/rate/Presentation/operational-management-of-openstack-with-cloudforms)

## A Deep Dive into the OpenStack Neutron Modular Layer 2 Plugin

Robert Kukura + Kyle Mestery

This presentation introduces the Havana release's new Modular Layer 2 (ML2) plugin for OpenStack Neutron. The ML2 plugin is a community-driven framework allowing OpenStack Neutron to simultaneously utilize the variety of layer 2 networking technologies found in complex, real-world datacenters. ML2 currently works with the Open vSwitch, Linux Bridge, and Hyper-V L2 agents, and is intended to replace and deprecate those agents' monolithic plugins. The ML2 plugin also works with SDN controllers and network hardware devices, and is designed to greatly simplify adding support for new L2 networking technologies into OpenStack Neutron.

In this session, Cisco and Red Hat representatives will:

Introduce the Modular Layer 2 (ML2) plugin for OpenStack Neutron Provide an overview of ML2, discussing its design principles and detailing use case examples Describe ML2's architecture and its driver APIs Demonstrate an OpenStack deployment with ML2 utilizing multiple segmentation methods and multiple L2 networking mechanisms to show the power of the ML2 plugin

Attendees will leave this session with an understanding of ML2, the use cases it was designed to solve, how to deploy ML2 in an OpenStack Havana environment, and how existing Neutron deployments can migrate to ML2.

[Vote](http://www.openstack.org/rate/Presentation/openstack-neutron-modular-layer-2-plugin-deep-dive)

## Scaling OpenStack Storage Services with Distributed Storage Solutions

Tushar Katarki and Vijay Bellur

Scalablity is one of the key design goals for OpenStack, especially for its block storage service (Cinder) and object storage service (Swift) technologies.

In scaling OpenStack, a storage solution must scale the services themselves and scale services in conjunction with one another, particularly the compute service (Nova) as well as the deployed storage backends. There are several approaches available to scale storage for OpenStack developers and datacenter architects.

In this session, Tushar Katarki and Vijay Bellur from Red Hat will: Detail scaling storage, providing real-world examples Discuss relative advantages, primarily using GlusterFs as the storage backend Highlight current gaps to start a discussion around future design and development within the OpenStack community

[Vote](http://www.openstack.org/rate/Presentation/scaling-openstack-storage-services-with-distributed-storage-solutions)

## OpenStack Swift Beyond Pure Object Store

Ayal Baron

Because OpenStack Swift API is easily accessible over the network, it can cross firewalls integrated with CDNs and is accessible via mobile devices by simply downloading a Swift app. Thus, you can immediately gain access to your data. Traditional storage protocols such as iSCSI, NFS, SMB assume a file system (POSIX) interface that is generally constrained to the datacenter.

In this session, Ayal Baron will discuss extending the concept of unified storage to leverage the power of OpenStack Swift, bridging the datacenter and the mobile remote. Attendees will leave this session...

[Vote](http://www.openstack.org/rate/Presentation/openstack-swift-beyond-pure-object-store)

## OpenStack Performance

Mark Wagner

In this session, Mark Wagner will detail the range of performance considerations important when sizing and deploying OpenStack configurations. Specifically, he will discuss:

Kernel-based Virtual Machine (KVM) hypervisor performance across a range of workloads Performance considerations for storing Nova instances including both direct-attached disks and locally attached SSD Performance of OpenStack networking based on Linux bridge and Open vSwitch Capacity planning for OpenStack provisioning services, including Nova, Cinder, Keystone, and Glance

[Vote](http://www.openstack.org/rate/Presentation/openstack-performance)

## The Future Costs of Today’s OpenStack Decisions

Greg Kleiman

While you have many choices as you architect and implement your OpenStack infrastructure, it’s not always clear what impact these decisions have on the overall cost of the solution. Using a comprehensive model that captures the true cost of operating OpenStack at cloud scale, you can make better decisions.

In this session, representatives from Red Hat and an independent consultant will present a comprehensive cost model for OpenStack deployments. They will then compare different design approaches to highlight the impact on the overall cost of the solution.

[Vote here](http://www.openstack.org/rate/Presentation/the-future-costs-of-today-s-openstack-decisions)

## Shared Storage: Data Availability Across Different Clouds and Traditional Datacenters

Tushar Katarki

Enterprise IT infrastructure is diverging. because of the growing business needs associated with cloud deployments using OpenStack, traditional virtualized datacenters, and various public clouds. Because of this, data availability across these platforms is becoming a growing challenge for IT architects and administrators. Essential to addressing this challenge is to build upon an open and highly scalable storage platform.

In this session, attendees will learn how a distributed, scale-out storage platform (such as GlusterFS) can be used for data availability across clouds built with OpenStack, public clouds (such as AWS), and traditional datacenters. They will also better understand the business and technical data availability challenges and will be presented with solution architectures and use cases.

## From Zero to Production: Provision and Manage OpenStack at Scale with Tuskar.

Keith Basil & Martyn Taylor

Tuskar gives administrators the ability to control how and where OpenStack services are deployed across the datacenter. Using Tuskar, administrators divide hardware into "resource classes" that allow predictable elastic scaling as cloud demands grow. This resource orchestration allows Tuskar users to ensure SLAs, improve performance, and maximize utilization across the datacenter.

Tuskar builds on the capabilities of Heat, TripleO, Nova bare metal/Ironic, and Ceilometer. It adds a layer that allows users to define requirements while providing the business logic used to realize those requirements into a robust, efficient, and performant OpenStack topology.

Tuskar services are available via a RESTful API and management console through which adminsistrators are able to classify their hardware and define their datacenters. In addition, Tuskar components provide adminstrators with performance monitoring, health statistics, and usage metrics, aiding in capacity planning and hardware procurement decisions.

In this session, Keith Basil and Martyn Taylor will: Introduce Tuskar and describe its core concepts and functionality Provide a brief architectural overview of Tuskar's approach to managing OpenStack services Show (with a working demo) the deployment of an OpenStack environment onto bare metal through the orchestration of Heat, TripleO, and Nova bare metal

## Marconi (QNS): Queuing and Notification Service for OpenStack

Flavio Percoco

Marconi (QNS): Queuing and Notification Service for OpenStack

Marconi is a multi-tenant cloud queuing and notification project, written in Python as part of the OpenStack technology. Its purpose is not to be yet another message broker, but rather to be a reliable, highly performant API. Marconi implements a new protocol, which is consistent throughout its transport layer, that allows it to provide both notification and queue support.

Session attendees will learn about Marconi’s architecture, design, patterns, and performance. They will also learn about the challenges the relatively new project has faced and how they were overcome. Join Flavio Percoco as he provides a review of Marconi.

## Oslo Messaging: Abstract RPC Library for OpenStack

Flavio Percoco

Oslo messaging is the new RPC library that was created as an evolution of OpenStack's old RPC module and strictly follows AMPQ standards. Oslo messaging provides a generic RPC library capable of talking to multiple transports regardless of their protocols, origins, or architectures. It aims to abstract transports from users’ perspectives and ease the implementation of RPC-like communications.

Although Oslo messaging is still under development, it has reached its API maturity. In this session, Flavio Percoco will introduce Oslo messaging, detailing the current library and providing a planned roadmap.

## Bridging the Virtualization and Cloud Gap with OpenStack and oVirt

Ayal Baron

With the continued adoption of OpenStack, it’s clear that enterprises are moving from proprietary, costly virtualization solutions to cost-effective, flexible, open ones. However, when evaluating which workloads to migrate to private clouds built with OpenStack, many solutions are lacking or simply don't fit the architecture.

oVirt, the community project for the development of open virtualization platforms, provides an enterprise virtualization framework. The integration of oVirt with underlying OpenStack projects aims to provide a cost-effective, unified solution that solves both enterprise and cloud use cases while reducing costs.

In this session, Ayal Baron will detail oVirt's integration with Neutron and Glance and discuss future plans for oVirt and OpenStack project integration.

## Real-world GlusterFS + OpenStack Deployments

Eric Harney & John Mark Walker

The Gluster community has been working hard to ensure GlusterFS is integrated with each OpenStack storage interface. With that integration, as well as the latest VM image management features, GlusterFS 3.4 is now a first-class citizen of the OpenStack ecosystem.

In this workshop, Eric Harney and John Mark Walker will demonstrate how to deploy OpenStack with GlusterFS as a scale-out storage platform \*today.\* They will also detail the four major areas of focus for integration:

Swift: A GlusterFS-backed storage platform has been implemented for the Swift API using the upstream Swift proxy server/API layer. This provides a unified storage backend for object as well as POSIX data. Glance: While it has been possible to use a mounted GlusterFS volume as the backend data store for Glance for some time, recent development work has enabled an integrated deployment with Cinder, significantly increasing the performance for deploying VM images on GlusterFS volumes. Cinder: A Cinder integration for the Grizzly release added an option for deploying live VM images on GlusterFS volumes. With recent contributions to the Havana release, you can now utilize the QEMU - libgfapi integration that was released in GlusterFS 3.4, greatly improving the performance of VM image management on GlusterFS. Libgfapi: With the release of GlusterFS 3.4, the libgfapi client library is now the standard way to integrate applications with GlusterFS.

Following simple examples, Eric and John Mark will demonstrate: How to deploy a GlusterFS-backed object storage solution, referencing when and why you should use this solution in conjunction with or in lieu of the Swift object storage implementation How to access the same data via NFS, libgfapi, the GlusterFS client, and the Swift API The power and flexibility of Libgfapi

In addition, they will provide a brief GlusterFS roadmap tour, discussing upcoming enhancements that will benefit OpenStack operators and developers.

## OpenStack Storage Roadmap: A Community Conversation

Ayal Baron, Doug Williams, Sean Cohen, Greg Kleiman

Because storage is a foundational element for all OpenStack infrastructures, it is critical to engage the OpenStack community to discuss needed capabilities for storage solutions.

During this session, Red Hat will facilitate a community conversation around OpenStack storage. Planned topics include:

Storage flavors: What performance characteristics (e.g., rotating media and SSD) do you need for different types of workloads? QoS: How can we dynamically provision VMs by end user mandates so that infrastructures reach a higher level of resource control to prevent running out of resources? Unified storage: How can we leverage the power of OpenStack Swift to bridge the datacenter and the mobile remote? Virtual file shares: What direction should the existing community file share proposal take? Storage HA and disaster recovery: What are your future requirements?

While Red Hat will help steer the discussion, attendees are encouraged to suggest discussion topic ideas. Help us shape the conversation and improve the roadmap.
