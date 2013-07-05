---
title: Floating IP range
category: networking
authors: acalinciuc, anandts, carltm, dneary, garrett, jasonbrooks, jeremykoerber,
  kallies, rbowen, vijai
wiki_category: Networking
wiki_title: Floating IP range
wiki_revision_count: 22
wiki_last_updated: 2015-07-22
---

# Floating IP range

This documentation applies to the use of nova-network. If you are using Neutron (formerly known as Quantum) the process involved in setting up a network is different. [This page in the OpenStack documentation](http://docs.openstack.org/trunk/openstack-network/admin/content/l3_workflow.html) will help with the basic concepts involved in Neutron. To use nova-network instead of Neutron/Quantum for networking services, disable the installation of Quantum services when running Packstack for the first time.

OpenStack instances receive a private IP address through which they can reach each other and through which hosts can reach them. In order to access these instances from other machines in your network, such as your workstation, the instances will need to be allocated a "floating IP." Packstack automatically configures this with a default that may well be wrong for your network. You'll want to configure your OpenStack install with a range of free IP addresses that's correct for your network.

If you don't know of an appropriate range of IP addresses on your network (best), and can't ask someone who does know (next best), you can make an intelligent guess by steering well clear of the range you typically get DHCP addresses in, by picking a fairly small range (/29 gives an 8 address range, 6 of which will be usable), and by using nmap to check if hosts are up in the range you're guessing at.

For instance, 192.168.1.56/29 represents a small range of addresses (192.168.1.56-63, with 57-62 usable), and you could run the command "nmap 192.168.1.56/29" to check and see if that whole range was in fact unused (at the moment, at least).

Steps to remove hard-coded floating IP range and add a new one:

1.  source /root/keystonerc_admin
2.  nova floating-ip-bulk-delete 10.3.4.0/22 (this is the hard-coded range in packstack)
3.  nova floating-ip-bulk-create CORRECT-RANGE (in the above example, this would be 192.168.1.56/29)
4.  nova-manage floating list (to see your new list of floating IPs)
