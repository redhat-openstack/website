---
title: ML2 plugin
category: networking
authors: jlibosva, larsks, rbowen, rkukura
wiki_category: Networking
wiki_title: ML2 plugin
wiki_revision_count: 10
wiki_last_updated: 2014-06-04
---

# ML2 plugin

The Modular Layer 2 plugin (ML2) is new in havana. Unlike previous monolithic plugins, ML2:

*   Supports an extensible set of network types, each implemented as a TypeDriver
*   Works with a variety of virtual networking mechanisms (simultaneously), each supported via a MechanismDriver
*   Supports multi-segment L2 networks
*   Supports heterogeneous network configurations

MechanismDrivers are included that work with the familiar openvswitch and linuxbridge layer 2 agents. The openvswitch and linuxbridge monolithic plugins that also support these L2 agents are being deprecated in icehouse, and will be removed in the following release. No new features are being added to the openvswitch and linuxbridge plugins in icehouse, and, as of the havana release, devstack defaults to the ML2 plugin with the openvswitch L2 agent.

## Configuring the ML2 Plugin

Until support for ML2 in packstack is complete, the easiest way to deploy neutron with ML2 and the openvswitch-agent is to use packstack to deploy with the openvswitch plugin, and then convert the deployment to use the ML2 plugin instead. The following steps can be used:

Start with a working packstack installation with neutron and openvswitch.

Delete any neutron resources that have been created by packstack or otherwise, including networks, subnets, routers, and floatingips. The ML2 plugin will use a new clean database.

The remaining steps are all executed as root on the neutron controller node(s) where neutron-server runs. No changes are needed on compute or network nodes.

Stop neutron-server:

      service neutron-server stop

Install the ML2 plugin:

      yum install openstack-neutron-ml2

Switch to ML2's config file:

      [ -h /etc/neutron/plugin.ini ] && unlink /etc/neutron/plugin.ini
      ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

Configure neutron-server to load the ML2 core plugin and the L3Router service plugin:

      crudini --set /etc/neutron/neutron.conf DEFAULT core_plugin neutron.plugins.ml2.plugin.Ml2Plugin
      crudini --set /etc/neutron/neutron.conf DEFAULT service_plugins neutron.services.l3_router.l3_router_plugin.L3RouterPlugin

Note - if you are using LBaaS, FWaaS, or VPNaaS, you will also need to include them in service_plugins.

Configure ML2:

      crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 mechanism_drivers openvswitch
`crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 tenant_network_types `<one or more of local,vlan,gre,vxlan>
      crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini database sql_connection mysql://neutron:`<password>`@`<host>`/neutron_ml2
      crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup firewall_driver dummy_value_to_enable_security_groups_in_server

If using VLAN provider and/or tenant networks, configure the VlanTypeDriver:

` crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_vlan network_vlan_ranges `<same range syntax as openvswitch>

If using flat provider networks, configure the FlatTypeDriver:

` crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_flat flat_networks `<list of physical_networks or *>

If using GRE tenant networks, configure the GreTypeDriver:

` crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_gre tunnel_id_ranges `<list of ranges>

If using VXLAN tenant networks, configure the VxlanTypeDriver:

` crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_vxlan vni_ranges `<list of ranges>

Once everything is properly configured, but before starting neutron-server, create the ML2 database:

      mysql -e "drop database if exists neutron_ml2;"
      mysql -e "create database neutron_ml2 character set utf8;"
      mysql -e "grant all on neutron_ml2.* to 'neutron'@'%';"
      neutron-db-manage --config-file /usr/share/neutron/neutron-dist.conf --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini upgrade head

Finally, start neutron-server:

      service neutron-server start

Check /var/log/neutron/server.log and make sure it started OK. Then run the following with admin credentials to make sure neutron-server is communicating with its agents:

      neutron agent-list

You should see "Open vSwitch agent" alive on all compute and network nodes, as well as all other agents (DHCP, L3, LBaaS) you've deployed.

Now you can create any needed networks, subnets, routers, floatingips, ...

<Category:Networking>
