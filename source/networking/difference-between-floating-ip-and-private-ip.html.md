---
title: Difference between Floating IP and private IP
category: networking
authors: jlibosva, kbreit, rbowen
wiki_category: Networking
wiki_title: Difference between Floating IP and private IP
wiki_revision_count: 9
wiki_last_updated: 2013-12-18
---

# Difference between Floating IP and private IP

Were you wondering what's the difference between a private IP address and a floating IP address in OpenStack? Here is a short explanation that could make it clear.

## Private IP Address

A private IP address is assigned to an instance's network-interface by the DHCP server. The address is visible from within the instance by using command like “ip a”. The address is typically part of a private network and is used for communication between instances in the same broadcast domain via virtual switch (L2 agent on each compute node).

## Floating IP Address

A floating IP address is a service provided by Neutron. It's not using any DHCP service nor being set statically within the guest. As a matter of fact the guest's operating system has completely no idea that it was assigned a floating IP address. The delivery of packets to the interface with the assigned floating address is the responsibility of Neutron's L3 agent. Instances with assigned floating IP address can be accessed from the public network by the floating IP.

------------------------------------------------------------------------

Floating IP address and a private IP address can be used at the same time on a single network-interface. The private IP address is likely to be used for accessing the instance by other instances in the private network while the floating IP address would be used for accessing the instance from a public network. How to configure floating IP range describes [Floating IP range](Floating IP range) document.

## Example

A setup with 2 compute nodes, one Neutron controller (where Neutron service, dhcp agent and l3 agent run), a physical router and a user. Let the physical subnet be 10.0.0.0/24. On the compute nodes instances are running using the private IP range 192.168.1.0/24. One of the instances is a webserver that should be reachable from a public network. Network outline: ![](neutron_private_floaring_ip.png "fig:neutron_private_floaring_ip.png")

As shows in the picture above, the webserver is running on an instance with private IP 192.168.1.2. User from network 10.0.0.0/24 wants to access the webserver but he's not part of private network 192.168.1.0/24. Using floating IP address 10.0.0.100 enables the user fetching webpages from the webserver. The destination address is translated by NAT table (iptables) within the virtual router deployed on the controller (?) .

<Category:Networking>
