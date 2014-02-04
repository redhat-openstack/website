---
title: Using VXLAN Tenant Networks
category: networking
authors: amuller, panda
wiki_category: Networking
wiki_title: Using VXLAN Tenant Networks
wiki_revision_count: 4
wiki_last_updated: 2014-02-06
---

# Using VXLAN Tenant Networks

VXLAN will be supported in Packstack when the following bug is resolved: [1](https://bugzilla.redhat.com/show_bug.cgi?id=1021778)

In the mean time, use the [GRE guide](Using_GRE_Tenant_Networks) to get things going. Afterwards, make the following modifications in /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini on every node:

    [OVS]
    tenant_network_type=vxlan
    tunnel_type=vxlan

    [AGENT]
    tunnel_types=vxlan

Afterwards, run this on every node:

    ovs-vsctl emer-reset && service  neutron-openvswitch-agent restart

Verify that the GRE tunnels are now VXLAN tunnels via:

    ovs-vsctl show

*   Note: If you created any tenant networks after the GRE installation but before the transition to VXLAN, delete those networks and recreate them.

<Category:Networking>
