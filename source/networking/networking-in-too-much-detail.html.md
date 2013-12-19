---
title: Networking in too much detail
category: networking
authors: jtaleric, larsks, mpavlase, rbowen
wiki_category: Networking
wiki_title: Networking in too much detail
wiki_revision_count: 6
wiki_last_updated: 2014-10-30
---

# Networking in too much detail

## The players

This document describes the architecture that results from a particular OpenStack configuration, specifically:

*   Quantum (or Neutron) networking using GRE tunnels;
*   A dedicated network controller;
*   A single instance running on a compute host

Much of the document will be relevant to other configurations, but details will vary based on your choice of layer 2 connectivity, number of running instances, and so forth.

The examples in this document were generated on a system with Quantum networking but will generally match what you see under Neutron as well, if you replace `quantum` by `neutron` in names.

## The lay of the land

This is a simplified architecture diagram of network connectivity in a quantum/neutron managed world:

![](neutron_architecture.png "neutron_architecture.png")

Section names in this document include parenthetical references to the nodes on the map relevant to that particular section.

## Compute host: instance networking (A,B,C)

An outbound packet starts on `eth0` of the virtual instance, which is connected to a `tap` device on the host, `tap7c7ae61e-05`. This `tap` device is attached to a Linux bridge device, `qbr7c7ae61e-05`. What is this bridge device for? From the [OpenStack Networking Administration Guide](http://docs.openstack.org/network-admin/admin/content/under_the_hood_openvswitch.html):

> Ideally, the TAP device vnet0 would be connected directly to the integration bridge, br-int. Unfortunately, this isn't possible because of how OpenStack security groups are currently implemented. OpenStack uses iptables rules on the TAP devices such as vnet0 to implement security groups, and Open vSwitch is not compatible with iptables rules that are applied directly on TAP devices that are connected to an Open vSwitch port.

Because this bridge device exists primarily to support firewall rules, I'm going to refer to it as the "firewall bridge".

If you examine the firewall rules on your compute host, you will find that there are several rules associated with this `tap` device:

    # iptables -S | grep tap7c7ae61e-05
    -A quantum-openvswi-FORWARD -m physdev --physdev-out tap7c7ae61e-05 --physdev-is-bridged -j quantum-openvswi-sg-chain 
    -A quantum-openvswi-FORWARD -m physdev --physdev-in tap7c7ae61e-05 --physdev-is-bridged -j quantum-openvswi-sg-chain 
    -A quantum-openvswi-INPUT -m physdev --physdev-in tap7c7ae61e-05 --physdev-is-bridged -j quantum-openvswi-o7c7ae61e-0 
    -A quantum-openvswi-sg-chain -m physdev --physdev-out tap7c7ae61e-05 --physdev-is-bridged -j quantum-openvswi-i7c7ae61e-0 
    -A quantum-openvswi-sg-chain -m physdev --physdev-in tap7c7ae61e-05 --physdev-is-bridged -j quantum-openvswi-o7c7ae61e-0 

The `quantum-openvswi-sg-chain` is where `neutron`-managed security groups are realized. The `quantum-openvswi-o7c7ae61e-0` chain controls outbound traffic FROM the instance, and by default looks like this:

    -A quantum-openvswi-o7c7ae61e-0 -m mac ! --mac-source FA:16:3E:03:00:E7 -j DROP 
    -A quantum-openvswi-o7c7ae61e-0 -p udp -m udp --sport 68 --dport 67 -j RETURN 
    -A quantum-openvswi-o7c7ae61e-0 ! -s 10.1.0.2/32 -j DROP 
    -A quantum-openvswi-o7c7ae61e-0 -p udp -m udp --sport 67 --dport 68 -j DROP 
    -A quantum-openvswi-o7c7ae61e-0 -m state --state INVALID -j DROP 
    -A quantum-openvswi-o7c7ae61e-0 -m state --state RELATED,ESTABLISHED -j RETURN 
    -A quantum-openvswi-o7c7ae61e-0 -j RETURN 
    -A quantum-openvswi-o7c7ae61e-0 -j quantum-openvswi-sg-fallback 

The `quantum-openvswi-i7c7ae61e-0` chain controls inbound traffic TO the instance. After opening up port 22 in the default security group:

    # neutron security-group-rule-create --protocol tcp \
      --port-range-min 22 --port-range-max 22 --direction ingress default

The rules look like this:

    -A quantum-openvswi-i7c7ae61e-0 -m state --state INVALID -j DROP 
    -A quantum-openvswi-i7c7ae61e-0 -m state --state RELATED,ESTABLISHED -j RETURN 
    -A quantum-openvswi-i7c7ae61e-0 -p icmp -j RETURN 
    -A quantum-openvswi-i7c7ae61e-0 -p tcp -m tcp --dport 22 -j RETURN 
    -A quantum-openvswi-i7c7ae61e-0 -p tcp -m tcp --dport 80 -j RETURN 
    -A quantum-openvswi-i7c7ae61e-0 -s 10.1.0.3/32 -p udp -m udp --sport 67 --dport 68 -j RETURN 
    -A quantum-openvswi-i7c7ae61e-0 -j quantum-openvswi-sg-fallback 

A second interface attached to the bridge, `qvb7c7ae61e-05`, attaches the firewall bridge to the integration bridge, typically named `br-int`.

## Compute host: integration bridge (D,E)

The integration bridge, `br-int`, performs VLAN tagging and un-tagging for traffic coming from and to your instances. At this moment, `br-int` looks something like this:

    # ovs-vsctl show
    Bridge br-int
        Port &quot;qvo7c7ae61e-05&quot;
            tag: 1
            Interface &quot;qvo7c7ae61e-05&quot;
        Port patch-tun
            Interface patch-tun
                type: patch
                options: {peer=patch-int}
        Port br-int
            Interface br-int
                type: internal

The interface `qvo7c7ae61e-05` is the other end of `qvb7c7ae61e-05`, and carries traffic to and from the firewall bridge. The `tag: 1` you see in the above output integrates that this is an access port attached to VLAN 1. Untagged outbound traffic from this instance will be assigned VLAN ID 1, and inbound traffic with VLAN ID 1 will stripped of it's VLAN tag and sent out this port.

Each network you create (with `neutron net-create`) will be assigned a different VLAN ID.

The interface named `patch-tun` connects the integration bridge to the tunnel bridge, `br-tun`.

## Compute host: tunnel bridge (F,G)

The tunnel bridge translates VLAN-tagged traffic from the integration bridge into `GRE` tunnels. The translation between VLAN IDs and tunnel IDs is performed by OpenFlow rules installed on `br-tun`. Before creating any instances, the flow rules on the bridge look like this:

    # ovs-ofctl dump-flows br-tun
    NXST_FLOW reply (xid=0x4):
     cookie=0x0, duration=871.283s, table=0, n_packets=4, n_bytes=300, idle_age=862, priority=1 actions=drop

There is a single rule that causes the bridge to drop all traffic. Afrer you boot an instance on this compute node, the rules are modified to look something like:

    # ovs-ofctl dump-flows br-run
    NXST_FLOW reply (xid=0x4):
     cookie=0x0, duration=422.158s, table=0, n_packets=2, n_bytes=120, idle_age=55, priority=3,tun_id=0x2,dl_dst=01:00:00:00:00:00/01:00:00:00:00:00 actions=mod_vlan_vid:1,output:1
     cookie=0x0, duration=421.948s, table=0, n_packets=64, n_bytes=8337, idle_age=31, priority=3,tun_id=0x2,dl_dst=fa:16:3e:dd:c1:62 actions=mod_vlan_vid:1,NORMAL
     cookie=0x0, duration=422.357s, table=0, n_packets=82, n_bytes=10443, idle_age=31, priority=4,in_port=1,dl_vlan=1 actions=set_tunnel:0x2,NORMAL
     cookie=0x0, duration=1502.657s, table=0, n_packets=8, n_bytes=596, idle_age=423, priority=1 actions=drop

In general, these rules are responsible for mapping traffic between VLAN ID 1, used by the integration bridge, and tunnel id 2, used by the GRE tunnel.

The first rule...

     cookie=0x0, duration=422.158s, table=0, n_packets=2, n_bytes=120, idle_age=55, priority=3,tun_id=0x2,dl_dst=01:00:00:00:00:00/01:00:00:00:00:00 actions=mod_vlan_vid:1,output:1

...matches all multicast traffic (see [ovs-ofctl(8)](http://openvswitch.org/cgi-bin/ovsman.cgi?page=utilities%2Fovs-ofctl.8)) on tunnel id 2 (`tun_id=0x2`), tags the ethernet frame with VLAN ID 1 (`actions=mod_vlan_vid:1`), and sends it out port 1. We can see from `ovs-ofctl show br-tun` that port 1 is `patch-int`:

    # ovs-ofctl show br-tun
    OFPT_FEATURES_REPLY (xid=0x2): dpid:0000068df4e44a49
    n_tables:254, n_buffers:256
    capabilities: FLOW_STATS TABLE_STATS PORT_STATS QUEUE_STATS ARP_MATCH_IP
    actions: OUTPUT SET_VLAN_VID SET_VLAN_PCP STRIP_VLAN SET_DL_SRC SET_DL_DST SET_NW_SRC SET_NW_DST SET_NW_TOS SET_TP_SRC SET_TP_DST ENQUEUE
     1(patch-int): addr:46:3d:59:17:df:62
         config:     0
         state:      0
         speed: 0 Mbps now, 0 Mbps max
     2(gre-2): addr:a2:5f:a1:92:29:02
         config:     0
         state:      0
         speed: 0 Mbps now, 0 Mbps max
     LOCAL(br-tun): addr:06:8d:f4:e4:4a:49
         config:     0
         state:      0
         speed: 0 Mbps now, 0 Mbps max
    OFPT_GET_CONFIG_REPLY (xid=0x4): frags=normal miss_send_len=0

The next rule...

     cookie=0x0, duration=421.948s, table=0, n_packets=64, n_bytes=8337, idle_age=31, priority=3,tun_id=0x2,dl_dst=fa:16:3e:dd:c1:62 actions=mod_vlan_vid:1,NORMAL

...matches traffic coming in on tunnel 2 (`tun_id=0x2`) with an ethernet destination of `fa:16:3e:dd:c1:62` (`dl_dst=fa:16:3e:dd:c1:62`) and tags the ethernet frame with VLAN ID 1 (`actions=mod_vlan_vid:1`) before sending it out `patch-int`.

The following rule...

     cookie=0x0, duration=422.357s, table=0, n_packets=82, n_bytes=10443, idle_age=31, priority=4,in_port=1,dl_vlan=1 actions=set_tunnel:0x2,NORMAL

...matches traffic coming in on port 1 (`in_port=1`) with VLAN ID 1 (`dl_vlan=1`) and set the tunnel id to 2 (`actions=set_tunnel:0x2`) before sending it out the GRE tunnel.

## Network host: tunnel bridge (H,I)

Traffic arrives on the network host via the GRE tunnel attached to `br-tun`. This bridge has a flow table very similar to `br-tun` on the compute host:

    # ovs-ofctl dump-flows br-tun
    NXST_FLOW reply (xid=0x4):
     cookie=0x0, duration=1239.229s, table=0, n_packets=23, n_bytes=4246, idle_age=15, priority=3,tun_id=0x2,dl_dst=01:00:00:00:00:00/01:00:00:00:00:00 actions=mod_vlan_vid:1,output:1
     cookie=0x0, duration=524.477s, table=0, n_packets=15, n_bytes=3498, idle_age=10, priority=3,tun_id=0x2,dl_dst=fa:16:3e:83:69:cc actions=mod_vlan_vid:1,NORMAL
     cookie=0x0, duration=1239.157s, table=0, n_packets=50, n_bytes=4565, idle_age=148, priority=3,tun_id=0x2,dl_dst=fa:16:3e:aa:99:3c actions=mod_vlan_vid:1,NORMAL
     cookie=0x0, duration=1239.304s, table=0, n_packets=76, n_bytes=9419, idle_age=10, priority=4,in_port=1,dl_vlan=1 actions=set_tunnel:0x2,NORMAL
     cookie=0x0, duration=1527.016s, table=0, n_packets=12, n_bytes=880, idle_age=527, priority=1 actions=drop

As on the compute host, the first rule maps multicast traffic on tunnel ID 2 to VLAN 1.

The second rule...

     cookie=0x0, duration=524.477s, table=0, n_packets=15, n_bytes=3498, idle_age=10, priority=3,tun_id=0x2,dl_dst=fa:16:3e:83:69:cc actions=mod_vlan_vid:1,NORMAL

...matches traffic on the tunnel destined for the DHCP server at `fa:16:3e:83:69:cc`. This is a `dnsmasq` process running inside a network namespace, the details of which we will examine shortly.

The next rule...

     cookie=0x0, duration=1239.157s, table=0, n_packets=50, n_bytes=4565, idle_age=148, priority=3,tun_id=0x2,dl_dst=fa:16:3e:aa:99:3c actions=mod_vlan_vid:1,NORMAL

...matches traffic on tunnel ID 2 destined for the router at `fa:16:3e:aa:99:3c`, which is an interface in another network namespace.

The following rule...

     cookie=0x0, duration=1239.304s, table=0, n_packets=76, n_bytes=9419, idle_age=10, priority=4,in_port=1,dl_vlan=1 actions=set_tunnel:0x2,NORMAL

...simply maps outbound traffic on VLAN ID 1 to tunnel ID 2.

## Network host: integration bridge

The integration bridge on the network controller serves to connect instances to network services, such as routers and DHCP servers.

    # ovs-vsctl show
    .
    .
    .
    Bridge br-int
        Port patch-tun
            Interface patch-tun
                type: patch
                options: {peer=patch-int}
        Port &quot;tapf14c598d-98&quot;
            tag: 1
            Interface &quot;tapf14c598d-98&quot;
        Port br-int
            Interface br-int
                type: internal
        Port &quot;tapc2d7dd02-56&quot;
            tag: 1
            Interface &quot;tapc2d7dd02-56&quot;
    .
    .
    .

It connects to the tunnel bridge, `br-tun`, via a patch interface, `patch-tun`.

## Network host: DHCP server (O,P)

Each network for which DHCP is enabled has a DHCP server running on the network controller. The DHCP server is an instance of [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) running inside a *network namespace*. A *network namespace* is a Linux kernel facility that allows groups of processes to have a network stack (interfaces, routing tables, iptables rules) distinct from that of the host.

You can see a list of network namespace with the `ip netns` command, which in our configuration will look something like this:

    # ip netns
    qdhcp-88b1609c-68e0-49ca-a658-f1edff54a264
    qrouter-2d214fde-293c-4d64-8062-797f80ae2d8f

The first of these (`qdhcp...`) is the DHCP server namespace for our private subnet, while the second (`qrouter...`) is the router.

You can run a command inside a network namespace using the `ip netns exec` command. For example, to see the interface configuration inside the DHCP server namespace (`lo` removed for brevity):

    # ip netns exec qdhcp-88b1609c-68e0-49ca-a658-f1edff54a264 ip addr
    71: ns-f14c598d-98: &lt;BROADCAST,MULTICAST,UP,LOWER_UP&gt; mtu 1500 qdisc pfifo_fast state UP qlen 1000
        link/ether fa:16:3e:10:2f:03 brd ff:ff:ff:ff:ff:ff
        inet 10.1.0.3/24 brd 10.1.0.255 scope global ns-f14c598d-98
        inet6 fe80::f816:3eff:fe10:2f03/64 scope link 
           valid_lft forever preferred_lft forever

Note the MAC address on interface `ns-f14c598d-98`; this matches the MAC address in the flow rule we saw on the tunnel bridge. This interface connects to the integration bridge via a tap device:

        Port &quot;tapf14c598d-98&quot;
            tag: 1
            Interface &quot;tapf14c598d-98&quot;

You can find the `dnsmasq` process associated with this namespace by search the output of `ps` for the id (the number after `qdhcp-` in the namespace name):

    # ps -fe | grep 88b1609c-68e0-49ca-a658-f1edff54a264
    nobody   23195     1  0 Oct26 ?        00:00:00 dnsmasq --no-hosts --no-resolv --strict-order --bind-interfaces --interface=ns-f14c598d-98 --except-interface=lo --pid-file=/var/lib/quantum/dhcp/88b1609c-68e0-49ca-a658-f1edff54a264/pid --dhcp-hostsfile=/var/lib/quantum/dhcp/88b1609c-68e0-49ca-a658-f1edff54a264/host --dhcp-optsfile=/var/lib/quantum/dhcp/88b1609c-68e0-49ca-a658-f1edff54a264/opts --dhcp-script=/usr/bin/quantum-dhcp-agent-dnsmasq-lease-update --leasefile-ro --dhcp-range=tag0,10.1.0.0,static,120s --conf-file= --domain=openstacklocal
    root     23196 23195  0 Oct26 ?        00:00:00 dnsmasq --no-hosts --no-resolv --strict-order --bind-interfaces --interface=ns-f14c598d-98 --except-interface=lo --pid-file=/var/lib/quantum/dhcp/88b1609c-68e0-49ca-a658-f1edff54a264/pid --dhcp-hostsfile=/var/lib/quantum/dhcp/88b1609c-68e0-49ca-a658-f1edff54a264/host --dhcp-optsfile=/var/lib/quantum/dhcp/88b1609c-68e0-49ca-a658-f1edff54a264/opts --dhcp-script=/usr/bin/quantum-dhcp-agent-dnsmasq-lease-update --leasefile-ro --dhcp-range=tag0,10.1.0.0,static,120s --conf-file= --domain=openstacklocal

## Network host: Router (M,N)

A Neutron router is a network namespace with a set of routing tables and iptables rules that performs the routing between subnets. Recall that we saw two network namespaces in our configuration:

    # ip netns
    qdhcp-88b1609c-68e0-49ca-a658-f1edff54a264
    qrouter-2d214fde-293c-4d64-8062-797f80ae2d8f

Using the `ip netns exec` command, we can inspect the interfaces associated with the router (`lo` removed for brevity):

    # ip netns exec qrouter-2d214fde-293c-4d64-8062-797f80ae2d8f ip addr
    66: qg-d48b49e0-aa: &lt;BROADCAST,MULTICAST,UP,LOWER_UP&gt; mtu 1500 qdisc pfifo_fast state UP qlen 1000
        link/ether fa:16:3e:5c:a2:ac brd ff:ff:ff:ff:ff:ff
        inet 172.24.4.227/28 brd 172.24.4.239 scope global qg-d48b49e0-aa
        inet 172.24.4.228/32 brd 172.24.4.228 scope global qg-d48b49e0-aa
        inet6 fe80::f816:3eff:fe5c:a2ac/64 scope link 
           valid_lft forever preferred_lft forever
    68: qr-c2d7dd02-56: &lt;BROADCAST,MULTICAST,UP,LOWER_UP&gt; mtu 1500 qdisc pfifo_fast state UP qlen 1000
        link/ether fa:16:3e:ea:64:6e brd ff:ff:ff:ff:ff:ff
        inet 10.1.0.1/24 brd 10.1.0.255 scope global qr-c2d7dd02-56
        inet6 fe80::f816:3eff:feea:646e/64 scope link 
           valid_lft forever preferred_lft forever

The first interface, `qg-d48b49e0-aa`, connects the router to the gateway set by the `router-gateway-set` command. The second interface, `qr-c2d7dd02-56`, is what connects the router to the integration bridge:

        Port &quot;tapc2d7dd02-56&quot;
            tag: 1
            Interface &quot;tapc2d7dd02-56&quot;

Looking at the routing tables inside the router, we see that there is a default gateway pointing to the `.1` address of our external network, and the expected network routes for directly attached networks:

    # ip netns exec qrouter-2d214fde-293c-4d64-8062-797f80ae2d8f ip route
    172.24.4.224/28 dev qg-d48b49e0-aa  proto kernel  scope link  src 172.24.4.227 
    10.1.0.0/24 dev qr-c2d7dd02-56  proto kernel  scope link  src 10.1.0.1 
    default via 172.24.4.225 dev qg-d48b49e0-aa 

The netfilter `nat` table inside the router namespace is responsible for associating floating IP addresses with your instances. For example, after associating the address `172.24.4.228` with our instance, the `nat` table looks like this:

    # ip netns exec qrouter-2d214fde-293c-4d64-8062-797f80ae2d8f iptables -t nat -S
    -P PREROUTING ACCEPT
    -P POSTROUTING ACCEPT
    -P OUTPUT ACCEPT
    -N quantum-l3-agent-OUTPUT
    -N quantum-l3-agent-POSTROUTING
    -N quantum-l3-agent-PREROUTING
    -N quantum-l3-agent-float-snat
    -N quantum-l3-agent-snat
    -N quantum-postrouting-bottom
    -A PREROUTING -j quantum-l3-agent-PREROUTING 
    -A POSTROUTING -j quantum-l3-agent-POSTROUTING 
    -A POSTROUTING -j quantum-postrouting-bottom 
    -A OUTPUT -j quantum-l3-agent-OUTPUT 
    -A quantum-l3-agent-OUTPUT -d 172.24.4.228/32 -j DNAT --to-destination 10.1.0.2 
    -A quantum-l3-agent-POSTROUTING ! -i qg-d48b49e0-aa ! -o qg-d48b49e0-aa -m conntrack ! --ctstate DNAT -j ACCEPT 
    -A quantum-l3-agent-PREROUTING -d 169.254.169.254/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 9697 
    -A quantum-l3-agent-PREROUTING -d 172.24.4.228/32 -j DNAT --to-destination 10.1.0.2 
    -A quantum-l3-agent-float-snat -s 10.1.0.2/32 -j SNAT --to-source 172.24.4.228 
    -A quantum-l3-agent-snat -j quantum-l3-agent-float-snat 
    -A quantum-l3-agent-snat -s 10.1.0.0/24 -j SNAT --to-source 172.24.4.227 
    -A quantum-postrouting-bottom -j quantum-l3-agent-snat 

There are `SNAT` and `DNAT` rules to map traffic between the floating address, `172.24.4.228`, and the private address `10.1.0.2`:

    -A quantum-l3-agent-OUTPUT -d 172.24.4.228/32 -j DNAT --to-destination 10.1.0.2 
    -A quantum-l3-agent-PREROUTING -d 172.24.4.228/32 -j DNAT --to-destination 10.1.0.2 
    -A quantum-l3-agent-float-snat -s 10.1.0.2/32 -j SNAT --to-source 172.24.4.228 

When you associate a floating ip address with an instance, similar rules will be created in this table.

There is also an `SNAT` rule that NATs all outbound traffic from our private network to `172.24.4.227`:

    -A quantum-l3-agent-snat -s 10.1.0.0/24 -j SNAT --to-source 172.24.4.227 

This permits instances to have outbound connectivity even without a public ip address.

## Network host: External traffic (K,L)

"External" traffic flows through `br-ex` via the `qg-d48b49e0-aa` interface in the router name space, which connects to `br-ex` as `tapd48b49e0-aa`:

    Bridge br-ex
        Port &quot;tapd48b49e0-aa&quot;
            Interface &quot;tapd48b49e0-aa&quot;
        Port br-ex
            Interface br-ex
                type: internal

What happens when traffic gets this far depends on your local configuration.

### NAT to host address

If you assign the gateway address for your public network to `br-ex`:

    # ip addr add 172.24.4.225/28 dev br-ex

Then you can create forwarding and NAT rules that will cause "external" traffic from your instances to get rewritten to your network controller's ip address and sent out on the network:

    # iptables -A FORWARD -d 172.24.4.224/28 -j ACCEPT 
    # iptables -A FORWARD -s 172.24.4.224/28 -j ACCEPT 
    # iptables -t nat -I POSTROUTING 1 -s 172.24.4.224/28 -j MASQUERADE

### Direct network connection

If you have an external router that will act as a gateway for your public network, you can add an interface on that network to the bridge. For example, assuming that `eth2` was on the same network as `172.24.4.225`:

    # ovs-vsctl add-port br-ex eth2

<Category:Networking>
