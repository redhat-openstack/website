---
title: Using GRE tenant networks
category: networking
authors: acalinciuc, jbainbri, jtaleric, rbowen, red trela, rkukura
wiki_category: Networking
wiki_title: Using GRE tenant networks
wiki_revision_count: 18
wiki_last_updated: 2014-04-11
---

# Using GRE tenant networks

Work in progress!

The ability to use GRE tunnels with Open vSwitch has finally arrived in RHEL! GRE tunnels encapsulate isolated layer 2 network traffic in IP packets that are routed between compute and networking nodes using the hosts' network connectivity and routing tables. Using GRE tunnels as tenant networks in Neutron avoids the need for a network interface connected to a switch configured to trunk a range of VLANs. Here are simple instructions for taking advantage of GRE for tenant networks.

Packstack does not yet have support for configuring GRE tunnels, so start out with a normal multi-node openvswitch-based deployment, such as is described in [Neutron_with_OVS_and_VLANs](Neutron_with_OVS_and_VLANs). If creating a new deployment, set the tenant_network_type to 'gre' and don't bother specifying a range of VLAN tags:

      CONFIG_QUANTUM_OVS_TENANT_NETWORK_TYPE=gre
`CONFIG_QUANTUM_OVS_VLAN_RANGES=`<physical network for external network>

The above assumes a provider external network is being used. If not, CONFIG_QUANTUM_OVS_VLAN_RANGES does not need to be set.

If modifying an existing deployment to use GRE tenant networks, run the following on the controller node:

      # openstack-config --set /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini OVS tenant_network_type gre

Then, for either a new or existing deployment, run the following commands on the controller node:

      # openstack-config --set /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini OVS enable_tunneling True
      # openstack-config --set /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini OVS tunnel_id_ranges 1:1000
      # service quantum-server restart
