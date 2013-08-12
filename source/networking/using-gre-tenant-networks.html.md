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

The ability to use GRE tunnels with Open vSwitch has finally arrived in RHEL! GRE tunnels encapsulate isolated layer 2 network traffic in IP packets that are routed between compute and networking nodes using the hosts' network connectivity and routing tables. Using GRE tunnels as tenant networks in OpenStack avoids the need for a network interface connected to a switch configured to trunk a range of VLANs. Here are simple instructions for taking advantage of GRE for tenant networks.

Packstack does not yet have support for configuring GRE tunnels, so start out with a normal multi-node deployment, such as is described in [Neutron_with_OVS_and_VLANs](Neutron_with_OVS_and_VLANs). If creating a new deployment, don't bother specifying ...
