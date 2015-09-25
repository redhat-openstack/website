---
title: External Connectivity
authors: rkukura
wiki_title: External Connectivity
wiki_revision_count: 2
wiki_last_updated: 2013-07-30
---

# External Connectivity

Work in progress!

Neutron's [tenant networks](Tenant_Networks) provide connectivity between a tenant's instances within the cloud. But most deployments also require outgoing connectivity from cloud instances to resources outside the cloud and/or incoming connectivity from outside the cloud to resources hosted within the cloud. Two top-level approaches are available to provide external connectivity:

*   Direct - Instances connect directly to an external network, with routable IP addresses on an external subnet.
*   Routed - A virtual router provides SNAT for outgoing connectivity and/or DNAT for incoming connectivity between a private network and an external network.

Direct connectivity can be provided by creating a provider network and a subnet ...

Routed connectivity requires [L3 agent configuration](L3_Agent_Configuration) and the creation of virtual routers, each of which connects one or more tenant networks to an external network.

There are several options for creating a router's external network:

*   fake - Simulate an external network with the node using bridging and NAT. Applicable only to ...
*   external network bridge -
*   provider external network -
