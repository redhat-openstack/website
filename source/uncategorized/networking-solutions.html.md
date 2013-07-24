---
title: Networking Solutions
authors: rkukura
wiki_title: Networking Solutions
wiki_revision_count: 3
wiki_last_updated: 2013-07-24
---

# Networking Solutions

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

*   openvswitch
*   linuxbridge
*   ml2
*   nvp
*   bigswitch
*   ...
