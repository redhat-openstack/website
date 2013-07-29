---
title: Neutron with OVS and VLANs
category: networking
authors: adarazs, dneary, jlewis, rbowen, rkukura, rvaknin
wiki_category: Networking
wiki_title: Neutron with OVS and VLANs
wiki_revision_count: 27
wiki_last_updated: 2013-12-18
---

# Neutron Installation with OVS and VLANs (Grizzly)

### Preface

#### Components

Neutron consists of the following components:

**`Neutron` `service`**` - the API service.`
**`Neutron` `metadata` `agent`**` - proxies metadata requests from instances even in isolated networks to nova-api.`
**`L2` `agent`**` - agent which talks with the layer 2 plugin like OVS (Open vSwitch) or LB (Linux bridge) etc.`
**`L3` `agent`**` - layer 3 agent which mainly responsible for the routing and NAT (used for floating IP <--> private IP convertions).`
**`DHCP` `agent`**` - responsible to provide a private IP address to an instance that looks for his address.`

#### Some Notes

All components can be installed in one machine or distributed to different machines (and all the in-between variants).

L2 agent should run on all machines except for the Neutron service machine (unless Neutron service resides with other component in the same machine).

It's possible to install multiple L3/DHCP/metadata agents.

### Installation (packstack)

#### Installation Machines

The following packstack configuration define where each component is installed:

      CONFIG_QUANTUM_SERVER_HOST=ip
      CONFIG_QUANTUM_L3_HOSTS=ip_or_comma_separated_ips
      CONFIG_QUANTUM_DHCP_HOSTS=ip_or_comma_separated_ips
      CONFIG_QUANTUM_METADATA_HOSTS=ip_or_comma_separated_ips

#### Layer 2 configuration

The following packstack configuration defines L2 tenant network allocation as VLANs. For VLAN configuration you will need:

1.  a network interface (i.e. "eth0") on each compute and network node connected to a switch that is configured to trunk a set of VLANs (i.e. 1200-1205)
2.  a name (i.e."'inter-vlan") for the physical_network (the switch or set of switches) to which these interfaces are connected
3.  a name (i.e. "br-instances") for the OVS bridge that will be connected to these interfaces on each node

      CONFIG_QUANTUM_OVS_TENANT_NETWORK_TYPE=vlan
      CONFIG_QUANTUM_OVS_VLAN_RANGES=inter-vlan:1200:1205
      # inter-vlan - the name of the physical_network used for the VLANs
      # 1200:1205 - the range of VLANs available for tenant network allocation
       
      CONFIG_QUANTUM_OVS_BRIDGE_MAPPINGS=inter-vlan:br-instances
      # mapping from the physical_network name to the bridge name
      # inter-vlan - the name of the physical_network used for the VLANs
      # br-instances - the bridge name
      CONFIG_QUANTUM_OVS_BRIDGE_IFACES=br-instances:eth0
      # mapping from the bridge name to the physical interface name
      # br-instances - the bridge name
      # eth0 - the interface name

Note: You can specify non-continuous ranges of VLANs in this form:

      CONFIG_QUANTUM_OVS_VLAN_RANGES=inter-vlan:182:182,inter-vlan:206:207

This specifies that the VLANs 182 and 206-207 on physical_network "inter-vlan" are available for allocation as tenant networks.

#### Other - get familiar with, no changes required

Keep the following parameters with their default values:

      CONFIG_QUANTUM_INSTALL=y
      CONFIG_QUANTUM_USE_NAMESPACES=y
      # namespaces allow you to create 2 subnets with the same IPs without any collisions.
      CONFIG_QUANTUM_L2_PLUGIN=openvswitch
      CONFIG_QUANTUM_L3_EXT_BRIDGE=br-ex
      # just a name, no change requied unless VLAN Splinters required (read the next section).

#### Workaround for unsupported nic driver

Working with unsupported NIC drivers (like "be2net") might lead to hangs in TCP traffic. in order to workaround that you can enable "VLAN Splinters" which will take care of the vlan tagging instead of OVS:

Change the following in packstack's answer file:

      CONFIG_QUANTUM_L3_EXT_BRIDGE=provider

Run the following command on all L2 agent machines after packstack installation:

      ovs-vsctl set interface eth0 other-config:enable-vlan-splinters=true

### Configuration

Basic Neutron configuration includes networks and subnets creation, association with routers, security group rules creation and floating IPs association.

Post packstack installation, you'll need to create a router and set its gateway, external network and subnet + network and subnet and per tenant, and connect the subnets to the router.

#### Networks and Subnets

Typical vlan network creation:

      quantum net-create net_name --provider:network_type vlan --provider:physical_network inter-vlan --provider:segmentation_id 1200

Typical subnet creation (associated with the newly-created network "net_name"):

      quantum subnet-create netname 10.0.0.0/24 --name subnet_name

External network creation is the same as above, with the additional "--router:external=True" parameter, for instance

      quantum net-create ext_net --provider:network_type vlan --provider:physical_network inter-vlan --provider:segmentation_id 1205 --router:external=True

External subnet creation for instance:

      quantum subnet-create ext_net --gateway 10.35.1.254 10.35.1.0/24 -- --enable_dhcp=False

#### Routers

Router creation:

      quantum router-create router_name

Add interface (subnet) to the router

      quantum router-interface-add router_name subnet_name

Set the external network ("ext_net") as the router's gateway:

      quantum router-gateway-set router1 ext_net

#### Security Group Rules

By default, all traffic that goes out from the instances is allowed, in order to also allow traffic from outside of the tenant into the instance (you should create it per tenant):

      quantum security-group-rule-create --direction ingress --protocol icmp  default

#### Floating IPs

Floating IP is an IP that the instance uses when it goes out of the L3 machine, this is done by iptables NAT rules (you won't find it by running "ifconfig"/"ip addr" inside the instance).

Create a Floating IP:

      floatingip-create ext_net

Associate a Floating IP with an instance:

      quantum floatingip-associate floatingip_id port_id

### Troubleshooting

#### VLAN issues

It's possible that your computer's ports are not set up correctly. You can check your current port configuration by running the following command on your host, and wait a few seconds (sometimes even a minute) to get an LLDP packet that describes the switch's port config (shortened sample included):

      $ tcpdump -vvv -s 1500 ether proto 0x88cc -i eth0
      tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 1500 bytes
      17:42:50.740544 LLDP, length 240
      [..]
          System Name TLV (5), length 18: sw01-dist-lab.com
            0x0000:  7377 3031 2d64 6973 742d 6c61 6233 2e74
            0x0010:  6c76
      [..]
          Port Description TLV (4), length 11: xe-4/0/21.0
            0x0000:  7865 2d34 2f30 2f32 312e 30
      [..]
          Organization specific TLV (127), length 14: OUI Ethernet bridged (0x0080c2)
            VLAN name Subtype (3)
              vlan id (VID): 174
              vlan name: vlan174
            0x0000:  0080 c203 00ae 0776 6c61 6e31 3734
      [..]
      ^C
      1 packets captured
      1 packets received by filter
      0 packets dropped by kernel

Important informations regarding the port on the switch:

      ` * the switch is named `sw01-dist-lab.com` `
      ` * the machine is connected on port `xe-4/0/21.0` `
      ` * the port is configured to use `vlan174` `

You should see the vlans that you're planning to use in the list, but if you have too many (>6) then the list might be truncated.

#### Diagnose the network settings

You can actually look around what your OVS router and other elements see using namespaces.

Check what namespaces you have:

      $ ip netns
      qrouter-42b4f31a-23ad-436b-a25c-7a96cff29a8e
      qdhcp-8751655e-2b8e-4e52-a19d-3f038bce1192

Do diagnostic stuff:

Check your IP addresses

      $ ip netns exec qrouter-42b4f31a-23ad-436b-a25c-7a96cff29a8e ip a

Check the routing table

      $ ip netns exec qrouter-42b4f31a-23ad-436b-a25c-7a96cff29a8e ip r

check your iptables

      $ ip netns exec qrouter-42b4f31a-23ad-436b-a25c-7a96cff29a8e iptables -t nat -L -nv

Check the NAT table

      $ ip netns exec qrouter-42b4f31a-23ad-436b-a25c-7a96cff29a8e iptables -S -t nat

Ping to verify network connections

      $  ip netns exec qrouter-42b4f31a-23ad-436b-a25c-7a96cff29a8e ping 8.8.8.8
