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

The ability to use GRE tunnels with Open vSwitch has finally arrived in RHEL! GRE tunnels encapsulate isolated layer 2 network traffic in IP packets that are routed between compute and networking nodes using the hosts' network connectivity and routing tables. Using GRE tunnels as tenant networks in Neutron avoids the need for a network interface connected to a switch configured to trunk a range of VLANs. Here are simple instructions for taking advantage of GRE for tenant networks.

See Also: [Configuring Neutron with OVS and GRE Tunnels using quickstack](/networking/configuring-neutron-with-ovs-and-gre-tunnels-using-quickstack/)

## Packstack GRE Tenant Network Configuration

Recent packstack versions support GRE tenant networks by specifying the following during deployment:

      CONFIG_NEUTRON_OVS_TENANT_NETWORK_TYPE=gre
      CONFIG_NEUTRON_OVS_TUNNEL_RANGES=1:1000

Note that if you are using provider flat or VLAN networks (i.e. as the external network) in conjunction with GRE tenant networks, due to [bug 1006534](https://bugzilla.redhat.com/show_bug.cgi?id=1006534), the configuration of the physical_networks and their mappings to bridges and/or interfaces will be ignored. In this case, it might be easier to do the initial packstack deployment with VLAN tenant networks, and convert to GRE manually as shown below.

## Manual Conversion to GRE Tenant Networks

Older versions of packstack did not have support for configuring GRE tunnels, so if GRE support is not available, start out with a normal multi-node openvswitch-based deployment, such as is described in [Neutron_with_OVS_and_VLANs](Neutron_with_OVS_and_VLANs).

New packstack deployments should install the GRE-enabled kernel and openvswitch packages by default. Existing deployments may need "yum update" run on each node. Make sure the following packages (or newer) are present:

*   kernel-2.6.32-358.114.1.openstack.el6.gre.2.x86_64.rpm
*   openvswitch-1.11.0_8ce28d-1.el6ost.x86_64.rpm

If creating a new deployment, select GRE tenant networks and don't bother specifying a range of VLAN tags in the packstack answer file:

      CONFIG_QUANTUM_OVS_TENANT_NETWORK_TYPE=gre
`CONFIG_QUANTUM_OVS_VLAN_RANGES=`<physical network for external network>

The above assumes a provider external network is being used. If an external bridge (br-ex) is being used instead, CONFIG_QUANTUM_OVS_VLAN_RANGES does not need to be set.

If modifying an existing deployment to use GRE tenant networks, run the following on the controller node:

      # openstack-config --set /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini OVS tenant_network_type gre

Then, for either a new or existing deployment, run these commands on the controller node:

      # openstack-config --set /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini OVS enable_tunneling True
      # openstack-config --set /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini OVS tunnel_id_ranges 1:1000
      # service quantum-server restart

Finally, on each node where quantum-openvswitch-agent runs (all compute and network nodes), run:

      # openstack-config --set /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini OVS enable_tunneling True
`# openstack-config --set /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini OVS local_ip `<IP address>
      # service quantum-openvswitch-agent restart

## MTU

When using GRE, set the MTU in the Guest to 1400, this will allow for the GRE header and no packet fragmentation.

## Offloading

You should turn offloading such as TSO/LRO and GRO/GSO off on the instance physical machine for traffic to work.

This can be done with this command (replace ethX with your physical network interface name):

      ethtool -K ethX tso off lro off gro off gso off

You can modify the network script for this change to apply on startup:

      /etc/sysconfig/network-scripts/ifcfg-eth0
      ETHTOOL_OPTS="-K ${DEVICE}  tso off lro off gro off gso off"

## Additional Configuration

On each node, be sure to specify the local IP address of the network interface over which the GRE tunnel traffic should be routed. Also make sure that each node's routing table is configured so that outgoing traffic to the other nodes' specified local IP addresses uses the desired interface. Production deployments would likely use a high bandwidth network interface and switch, with a dedicated subnet, for GRE traffic. For non-production deployments, each host's main (and probably only) IP address will suffice.

New packstack deployments can specify the interface whose IP address will be used as the local tunnel endpoint IP with:

      CONFIG_NEUTRON_OVS_TUNNEL_IF=eth1

Once the above steps are complete, newly created tenant networks should be GRE tunnels, which can be verified by running the following with admin credentials and looking at the provider:network_type attribute:

`# quantum net-show `<network name or UUID>

<Category:Networking>
