---
title: Network Interfaces
authors: rkukura
wiki_title: Network Interfaces
wiki_revision_count: 1
wiki_last_updated: 2013-07-25
---

# Network Interfaces

Work in progress!

Compute and networking nodes utilize network interfaces for a number of purposes. When multiple interfaces are available, different interfaces can be used for different purposes. But often the same interface will need to serve several roles. This guidance is intended to help plan what roles will be served by the network interfaces available on the OpenStack nodes being deployed.

The following network interface roles typically apply on various nodes within an OpenStack deployment:

*   Management - All nodes need connectivity for management purposes, such as SSH access by administrators, access to yum repositories, etc..
*   Service - The various OpenStack services on different nodes communicate with each other via RESTful HTTP protocols, AMQP messaging, etc..
*   Storage - Compute nodes need to access volumes, images, etc. on storage nodes
*   Tenant data - Instances on compute nodes communicate with each other and with services on network nodes over [tenant networks](Tenant_Networks)
*   External data - Depending on the [external connectivity](External_Connectivity) approach taken, instances on compute nodes and/or virtual routers on network nodes communicate with the outside world.

When separate network interfaces (or bonded sets of interfaces) are not available to serve each distinct role, multiple roles must be served by the same interface.

Certain roles require the node itself to have IP addresses and routing to/from the interface service the role, while others don't. Roles also very in their bandwidth, latency, and reliability requirements.

## Management Network

## Service Network

...
