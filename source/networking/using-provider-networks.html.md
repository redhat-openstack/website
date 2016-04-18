---
title: Using provider networks
authors: jkdexter, v l
wiki_title: Using provider networks
wiki_revision_count: 2
wiki_last_updated: 2015-05-21
---

# Using provider networks

Neutron with provider networks using openvswitch

Provider networks are created with administrative credentials, specifying the details of how the network is physically realized, usually to match some existing network in the data center. The details describing a network currently include the provider:network_type, provider:physical_network, and provider:segmentation_id attributes.

Provider networks can be either flat of vlan.

A "flat network" is one whose provider:network_type attribute has the value 'flat'. “vlan networks” are similar to the flat network but differ by having a segmentation_id that equates to the vlan tag. Depending on the provider:network_type value, the provider:physical_network and/or provider:segmentation_id attributes may also be required to describe the network. Note that an administrator sees these attribute values for both tenant and provider networks. Once created, there is no operational differences between a tenant and a provider network. Tenant networks are typically allocated from a pool of some kind (VLAN tags or tunnel IDs).

If the ml2 plugin is being used, then ensure that the drivers are enabled for the desired type(s).

    /etc/neutron/plugins/ml2/ml2.conf
    ...
    type_drivers = vxlan,flat,vlan
    # Example: type_drivers = flat,vlan,gre,vxlan

If vlans are to be created by the users as tenant networks, the `tenant_network_types` can be used to allow vlans

    # (ListOpt) Ordered list of network_types to allocate as tenant
    # networks. The default value 'local' is useful for single-box testing
    # but provides no connectivity between hosts.
    #
    # tenant_network_types = local
    tenant_network_types = vxlan
    # Example: tenant_network_types = vlan,gre,vxlan

It is possible to list all the "flat" networks that will be used or \`\*\` can be used. For vlans the range should be specified along with the physical network that is described.

    [ml2_type_flat]
    # (ListOpt) List of physical_network names with which flat networks
    # can be created. Use * to allow flat networks with arbitrary
    # physical_network names.
    #
    # flat_networks =
    # Example:flat_networks = physnet1,physnet2
    flat_networks = *

    [ml2_type_vlan]
    # (ListOpt) List of <physical_network>[:<vlan_min>:<vlan_max>] tuples
    # specifying physical_network names usable for VLAN provider and
    # tenant networks, as well as ranges of VLAN tags on each
    # physical_network available for allocation as tenant networks.
    #
    # network_vlan_ranges =
    network_vlan_ranges = physnet1:1689:1689

Next editing the openvswitch configuration file '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini' within the ovs_neutron_plugin vlans and flat networks are treated much the same way. If vlan tagging is not being used then leave off the vlan tag id from the 'network_vlan_range'. Both the vlan_range as well as bridge_mappings can have multiple comma separated values in it.

    [ovs]
    network_vlan_ranges = default:2000:3999
    integration_bridge = br-int
    bridge_mappings = default:br-eth1

Once the changes have been made, restart neutron.

    $ openstack-service restart neutron

Using adminstrator credentials, create a network: vlan:

    neutron net-create ext_net --provider:network_type vlan --provider:physical_network physnet1 --provider:segmentation_id 100 [--router:external=True]

flat:

    neutron net-create ext_net --provider:network_type flat --provider:physical_network physnet1  [--router:external=True]

The '--router:external=True' option can be used if the network is to be an external network that can be used for floating IPs.

The subnet can now be created much like any other subnet.

    neutron subnet-create  ext_net --gateway 10.35.1.254 10.35.1.0/24 -- --enable_dhcp=False
