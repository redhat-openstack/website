---
title: Networking
category: troubleshooting
authors: dneary, forrest, palmtown, rbowen
wiki_category: Troubleshooting
wiki_title: Networking
wiki_revision_count: 27
wiki_last_updated: 2013-12-19
---

# Networking

__NOTOC__

## Toolchain

A number of tools come in handy when troubleshooting Neutron/Quantum networking issues.

*   [Open vSwitch](//openvswitch.org/) ([documentation](http://openvswitch.org/support/))
    -   [ovs-vsctl](//openvswitch.org/cgi-bin/ovsman.cgi?page=utilities%2Fovs-vsctl.8) - tool for querying and configuring ovs-vswitchd
    -   [ovs-ofctl](//openvswitch.org/cgi-bin/ovsman.cgi?page=utilities%2Fovs-ofctl.8) - OpenFlow configuration tool
    -   [ovs-dpctl](//openvswitch.org/cgi-bin/ovsman.cgi?page=utilities%2Fovs-vsctl.8) - query and configure Open vSwitch datapaths
*   [iproute tools](//www.linuxfoundation.org/collaborate/workgroups/networking/iproute2)
    -   [iproute2 HOWTO](//www.policyrouting.org/iproute2.doc.html)
    -   [iproute2 examples](//www.linuxfoundation.org/collaborate/workgroups/networking/iproute2_examples)

### Useful commands

## **tcpdump**

      will be your best friend so it's best to learn and understand how to use it.  When debugging routing issues with quantum, tcpdump can be used to investigate the ingress and egress of traffic.  For example:
           tcpdump -n -i br-int  

The above command will capature all traffic on the internal bridge interface.

           tcpdump -n -i br-int  -w tcpdump.pcap

The above command will capture all traffic on the internal bridge interface and dump it to a file named tcpdump.pcap.

           tcpdump -r tcpdump.pcap

The above command will read in a previously created tcpdump file

           tcpdump -n -i any

The above command will capture all traffic on any interface. ...

## Common issues

*   I can create an instance, but cannot SSH or ping it
*   I cannot associate a floating IP with an instance
*   I can create an instance, however, it does not get a DHCP address

...

## Useful resources

*   [Quantum L3 workflow](//docs.openstack.org/trunk/openstack-network/admin/content/l3_workflow.html)
*   [Network troubleshooting](//docs.openstack.org/trunk/openstack-ops/content/network_troubleshooting.html)

...

<Category:Troubleshooting> <Category:Documentation> [Category:In progress](Category:In progress)
