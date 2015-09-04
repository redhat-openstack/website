---
title: Networking Solutions
authors: rkukura
wiki_title: Networking Solutions
wiki_revision_count: 3
wiki_last_updated: 2013-07-24
---

# Networking Solutions

Work in progress!

OpenStack provides a variety of networking solutions to choose from.

First, an OpenStack deployment can use either Nova networking or Neutron (formerly Quantum) networking.

*   Nova networking - Original network implementation in OpenStack Compute (Nova) supporting flat and VLAN networks
*   Neutron networking - Powerful virtual networking service abstraction over wide variety of virtual networking mechanisms

With Nova networking, there are several NetworkManager implementations to choose from:

*   FlatManager
*   FlatDHCPManager
*   VlanManager

The Nova project is in the process of deprecating Nova networking and moving towards Neutron networking as the only networking solution, so Neutron networking is recommended for new deployments.

With Neutron networking, a wide variety of "core plugins" are available that implement the core abstractions of network, subnet, and port.

*   openvswitch - Uses openvswitch L2 agent on compute and network nodes to manage Open vSwitch bridges.
*   linuxbridge - Uses linuxbridge L2 agent on compute and network nodes to manage traditional Linux bridges.
*   ml2 - Can use openvswitch, linuxbridge, and/or hyperv L2 agents, and/or integrate with external network controllers
*   nvp - Integrates with VmWare's NVP virtual network controller.
*   bigswitch - Integrates with BigSwitch's controller or the open source Floodlight controller.
*   ...

If using an external controller or other vendor-specific virtual networking solution, the corresponding plugin is generally required. For a deployment using only native Linux networking mechanisms, the openvswitch, linuxbridge or ml2 plugins can be used. With grizzly, the openvswitch plugin is recommended, but havana will start the process of deprecating the openvswitch and linuxbridge plugins, replacing them with the ml2 plugin, so ml2 might be worth considering for deployments based on havana milestone 2 or later.
