---
title: ML2 from OVS
authors: jlibosva, otherwiseguy
wiki_title: ML2 from OVS
wiki_revision_count: 2
wiki_last_updated: 2014-07-21
---

# ML2 from OVS

This tutorial assumes that a working install of Openstack Icehouse using the Openvswitch plugin is the starting point.

Make sure that the ML2 plugin is installed.

    # yum -y install openstack-neutron-ml2

The plugin.ini file needs to be pointed to the ML2 plugin config file

    # ln -sf /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

Next, set up plugin.ini with equivalent settings for the existing /etc/neutron/plugins/ovs_neutron_plugin.ini. If, for example, the old config contained something like:

    [ovs]
    tenant_network_type = vxlan
    tunnel_type=vxlan
    tunnel_id_ranges=1:1000
    enable_tunneling=True
    integration_bridge=br-int
    tunnel_bridge=br-tun
    vxlan_udp_port=4789
    local_ip=10.0.2.15

then you would add the following settings to plugin.ini:

    [ml2]
    type_drivers = vxlan
    tenant_network_types = vxlan
    mechanism_drivers = openvswitch

    [ml2_type_vxlan]
    vni_ranges=1:1000

Stop the neutron services

    # openstack-service stop neutron

Migrate the existing OVS database. For the database connection information to pass, check the connection setting in /etc/neutron/neutron.conf.

    # python -m neutron.db.migration.migrate_to_ml2 --tunnel-type=vxlan --vxlan-udp-port 4789 openvswitch ${db_connection_string}

Note: At this point, for the DHCP agent to work, I had to kill the dnsmasq processes before restarting the neutron services.

    # killall dnsmasq

Start the neutron services

    # openstack-service start neutron

At this point, start some VMs and verify that they can communicate with each other.
