---
title: Networking
category: troubleshooting
authors: dneary, forrest, palmtown, rbowen
wiki_category: Troubleshooting
wiki_title: Networking
wiki_revision_count: 27
wiki_last_updated: 2013-12-19
---

# Network troubleshooting

{:.no_toc}

* See also: [Networking](/networking/).

Check out this webcast - an overview of networking principles and how they apply to Neutron and OpenvSwitch - by Dave Neary.

<iframe width="630" src="//youtube.com/embed/afImoFeuDnY" frameborder="0" align="center" allowfullscreen="true"> </iframe>

## Toolchain

A number of tools come in handy when troubleshooting Neutron/Quantum networking issues.

*   [Open vSwitch](http://openvswitch.org/) ([documentation](http://openvswitch.org/support/))
    -   [ovs-vsctl](http://openvswitch.org/support/dist-docs/ovs-vsctl.8.txt) - tool for querying and configuring ovs-vswitchd
    -   [ovs-ofctl](http://openvswitch.org/support/dist-docs/ovs-ofctl.8.txt) - OpenFlow configuration tool
    -   [ovs-dpctl](http://openvswitch.org/support/dist-docs/ovs-dpctl.8.txt) - query and configure Open vSwitch datapaths
*   [iproute tools](//www.linuxfoundation.org/collaborate/workgroups/networking/iproute2)
    -   [iproute2 HOWTO](http://www.policyrouting.org/iproute2.doc.html)
    -   [iproute2 examples](http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2_examples)
*   [tcpdump](http://www.tcpdump.org/) (see next section)
    -   [tcpdump documentation](http://www.tcpdump.org/#documentation)

### tcpdump

tcpdump will be your best friend so it's best to learn and understand how to use it. When debugging routing issues with quantum, tcpdump can be used to investigate the ingress and egress of traffic. For example:

           tcpdump -n -i br-int  

The above command will capature all traffic on the internal bridge interface.

           tcpdump -n -i br-int  -w tcpdump.pcap

The above command will capture all traffic on the internal bridge interface and dump it to a file named tcpdump.pcap.

           tcpdump -r tcpdump.pcap

The above command will read in a previously created tcpdump file

           tcpdump -n -i any

The above command will capture all traffic on any interface. ...

## iproute2

iproute2 provides a tool called ip which allows you to debug what is going on.

Here are some diagnostics commands for networking (assuming you are using Neutron). Of-course, you'll replace the router namespace, dhcp namespace IDs , IP addresses accordingly:

    # List namespaces
    $ ip netns
    qdhcp-4a04382f-03bf-49a9-9d4a-35ab9ffc22ad
    qrouter-1fabd5f0-f80b-468d-b733-1b80d0c3e80f

    # Show all interfaces inside the namespace
    $ ip netns exec qrouter-1fabd5f0-f80b-468d-b733-1b80d0c3e80f \
      ip a

    # Check routing table inside the router namespace
    $ ip netns exec qrouter-1fabd5f0-f80b-468d-b733-1b80d0c3e80f \
      ip r

    # IP config inside the router namesapce 
    $ ip netns exec qrouter-1fabd5f0-f80b-468d-b733-1b80d0c3e80f \
      ifconfig

    # IP configu inside the dhcp namesace
    $ ip netns exec qrouter-1fabd5f0-f80b-468d-b733-1b80d0c3e80f \
      ifconfig

    # Ping the private IP (of the cirros guest)
    $ ip netns exec qrouter-1fabd5f0-f80b-468d-b733-1b80d0c3e80f \
      ping -c2 30.0.0.7
    $ ip netns exec qrouter-1fabd5f0-f80b-468d-b733-1b80d0c3e80f \
      ping -c2 192.168.122.14

    # ssh into cirros guest
    $ ip netns exec qdhcp-4a04382f-03bf-49a9-9d4a-35ab9ffc22ad ssh   cirros@30.0.0.7

## Common issues

*   I can create an instance, but cannot SSH or ping it
    -   Verify that traffic to port 22 and ICMP traffic of any type (-1:-1) is allowed in the default security group
        In the dashboard, in the Project tab, under "Access and Security", check the rules which are active on the security group you are using with your instances (typically "default"). You should see a rule allowing traffic to port 22 over tcp from all hosts, and a port enabling icmp traffic of all types (-1). If you don't, create the necessary rules, and try again.

    -   Verify that you can ping and SSH the host where the instance is running
        From the host where you are attempting to connect to your instance, verify that network traffic is being correctly routed to the compute node in question.

    -   Ensure that the router is correctly created, that the internal subnet and external subnet are attached to it, and that it can route traffic from your IP to the instance IP
        If your VM is in the 192.168.1.x subnet, and the host from which you are trying to connect is in the 192.168.0.x subnet, then you will need to have a route from one to the other. Ensure that the subnet 192.168.1.x and 192.168.0.x are both added to a router which you create in Neutron

    -   Check that you can ping an instance from inside its network namespace.
        If you are using network namespaces, then each VLAN will have its own namespace, and entities inside that namespace will be invisible from outside. You can check whether you can ping an instance from inside the namespace by first finding the namespace identifier, and then using the iproute toolset to execute a "ping" inside that namespace:

<!-- -->

    ip netns list
    # Identify virtual router to which your subnet is connected
    ip netns exec qrouter-de0b9dbe-6b65-45ee-9ff2-c752c7937a9e ping 10.10.0.7
    # IP address and qrouter ID correspond to the network namespace and private IP address for instance

*   -   Check the OVS routing table to ensure that it is correctly routing traffic from internal to external.
        You should see a route for each subnet attached to your virtual router, and you should see routing which will allow traffic from the VM to get to the subnet of the host from which you are trying to connect (or to a public gateway)

            ip netns exec qrouter-de0b9dbe-6b65-45ee-9ff2-c752c7937a9e route -n

    -   Verify that br-ex is associated with the physical NIC, and that the virtual router can route traffic to the IP address of the host. For a single NIC set-up, you will need to bring up br-ex at boot time, and connect eth0 to it.
        To set up br-ex initially (on a host with static IP 192.168.0.2), the following will do the initial configuration:

<!-- -->

    ip addr flush eth0
    ovs-vsctl add-port br-ex eth0
    ip addr add 192.168.0.2 dev br-ex
    ip link set br-ex up

To make changes persist after boot, you will need to create /etc/sysconfig/network-scripts/ifcfg-br-ex as follows (replace DNS, IP addresses for your local network):

    DEVICE=br-ex
    TYPE=Ethernet
    BOOTPROTO=static
    ONBOOT=yes
    IPADDR=192.168.0.2
    NETMASK=255.255.255.0
    GATEWAY=192.168.0.1
    DNS1=89.2.0.1
    DNS2=89.2.0.1
    DOMAIN=neary.home
    NAME="System br-ex"

After this, you will no longer need to bring up eth0, and all going well you will be able to access both instances and the management interface on the same host.

*   I cannot associate a floating IP with an instance
    -   If the error is that the external network is not visible from the subnet: Check that br-ex has its MAC address set correctly. Check for the error "Device or resource busy" in /var/log/messages - if it's present, you will need to bring down br-ex, set its MAC address to match that of the physical NIC, and bring it back up.
*   I can create an instance, however, it does not get a DHCP address
    -   See [network troubleshooting](http://docs.openstack.org/trunk/openstack-ops/content/network_troubleshooting.html) for information on sniffing the various steps of the allocation of an IP address by DHCP - verify that your DHCP agent is running, is receiving the DHCPDISCOVER request, and is replying to it - and verify that your host is receiving the DHCP reply.
    -   Make sure that IPv6 is enabled. Disabling IPv6 will give an error such as "Address family not supported".
    -   If you are using OpenvSwitch with VLAN, make sure that the network created includes VLAN information. You may need to restart the quantum-openvswitch-agent service and/or create a network using specific VLAN information.

<!-- -->

*   If you are using more than one node for OpenStack (i.e., not an all-in-one installation), then you must use VLANs.
*   If you are using a virtual machine as a node in OpenStack, you must use the virtio network driver when using VLANs. The default rt8139 driver seems to drop VLAN information.
*   You must have an external network set as the gateway to the router if you want to get network traffic out of the private instance network.

## Other resources

*   [Network troubleshooting (OpenStack Operations Guide)](//docs.openstack.org/ops-guide/ops-network-troubleshooting.html)

<Category:Troubleshooting> <Category:Documentation> <Category:In progress> <Category:Networking>
