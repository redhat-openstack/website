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

## Setting your floating IP range

OpenStack instances receive a private IP address through which they can reach each other and through which hosts can reach them. In order to access these instances from other machines in your network, such as your workstation, the instances will need to be allocated a "floating IP." Packstack automatically configures this with a default that may well be wrong for your network.

If you don't know (best), and can't ask someone who does know (next best), you can make an intelligent guess by steering well clear of the range you typically get DHCP addresses in, by picking a fairly small range (/29 gives an 8 address range, 6 of which will be usable, so, like 192.168.1.56/29 is a range of 192.168.1.56-63, with 57-62 usable) and by using nmap to check if hosts are up in the range you're guessing at (nmap 192.168.1.56/29).

Either supply packstack with this initially, or do it afterward. Before will be simpler.

Steps to remove hard-coded floating IP range and add a new one:

1.  source /root/keystonerc_admin
2.  nova floating-ip-bulk-delete 10.3.4.0/22
3.  nova-manage floating list
4.  nova floating-ip-bulk-create CORRECT-RANGE
5.  nova-manage floating delete --ip_range=10.3.6.0/8
6.  nova-manage floating create --ip_range=192.168.215.192/26
