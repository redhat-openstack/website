---
title: Tenant Networks
authors: rkukura
wiki_title: Tenant Networks
wiki_revision_count: 6
wiki_last_updated: 2013-07-30
---

# Tenant Networks

Work in progress!

Tenant networks are isolated Layer 2 networks typically created by or for, and used by, individual tenants. Creating a tenant network requires no special administrative privilege. The details on how the virtual network is implemented (VLAN, tunnel, ...) are not controlled by or visible to the tenant.

The openvswitch, linuxbridge, and ml2 plugins support several tenant network types:

*   local - Provide connectivity between instances and services on the same node, but no remote connectivity. Requires no network interface or switch configuration. Applicable only in all-in-one deployments.
*   vlan - Provide connectivity between nodes using IEEE 802.1Q VLAN tags to segment multiple virtual networks within the same physical network link. Requires VLAN compatible network interfaces and switches configured to trunk ranges of VLANs dedicated to tenant networks.
*   gre - Provide connectivity between nodes using GRE tunnels. Requires L3 connectivity between nodes, but no special interface or switch configuration. Supported by openvswitch and ml2 plugins, but not available on RHEL 6.4 without installing unsupported OVS kernel modules.
*   vxlan - ...

Given that local networks do not provide connectivity between nodes, and that gre and vxlan networks are not available on RHEL 6.4, the only workable option for tenant networks at the moment is vlan.

Utilizing vlan tenant networks requires [[plugin configuration|Plugin_Configuration] to select vlan as the tenant network type and to specify the range(s) of VLAN tags available for tenant networks, and [L2_Agent_Configuration](L2 agent configuration) to map the physical networks carrying the tenant networks.
