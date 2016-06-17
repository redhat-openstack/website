---
title: Connecting to TripleO Baremetal VMs from remote machine
category: documentation
authors: bcrochet, rbowen
wiki_category: Documentation
wiki_title: Connecting to TripleO Baremetal VMs from remote machine
wiki_revision_count: 8
wiki_last_updated: 2015-05-26
---

# Connecting to TripleO Baremetal VMs from remote machine

## Work in progress

There are still some kinks to be worked out with this method. Expect changes. YMMV.

## Motivation

In order to test a TripleO VM setup, it would be ideal to be able to connect to the "Baremetal" VMs from a host other than the VM host. This would allow, for instance, a distributed Jenkins master/slave setup to be able to run arbitrary code against the Baremetal VMs (BMVM).

## Assumptions

The below document uses the following:

Public, routable addresses of machines participating in tunnel

10.0.0.1 10.0.0.2

Address of "private" subnet

192.168.100.0/24

## Setup

This is a pretty simple setup, since the VM host (if set up with Instack) will already be using OpenVSwitch for the brbm bridge.

1. Install OpenVSwitch on the host from which you want to connect. This can be anything, as long as it has an IP address that the TripleO VM host can reach. In this case, 10.0.0.1, remote peer is 10.0.0.2.

2. Set up a new switch to be used for a VxLAN tunnel

         cat << EOF > /etc/sysconfig/network-scripts/ifcfg-ovsbr2
         DEVICE=ovsbr2
         DEVICETYPE=ovs
         ONBOOT=yes
         TYPE=OVSBridge
         BOOTPROTO=none
         DELAY=0
         HOTPLUG=no
         EOF

Now start the bridge

         ifup ovsbr2

3. Setup up the tunnel

         ovs-vsctl add-port ovsbr2 vx1 -- set interface vx1 type=vxlan options:remote_ip=10.0.0.2

4. Open up a port

with firewall-cmd (recommended, F20+, RHEL 7+, F19 doesn't seem to work):

         firewall-cmd --permanent --add-rich-rule 'rule family="ipv4" source address="10.0.0.2/32" port port="4789" protocol="udp" accept'
         firewall-cmd --reload

iptables can also be used directly:

         lineno=$(iptables -nvL INPUT --line-numbers | grep "state RELATED,ESTABLISHED" | awk '{print $1}')
         iptables -I INPUT $lineno -s `<vxlan-endpoint>`/32 -p udp -m multiport --dports 4789 -m comment --comment "001 vxlan incoming `<vxlan-endpoint>`" -j ACCEPT

5. Now, create the veth pair, and bring the interfaces up.

         ip link add name veth0 type veth peer name veth1
         ip link set veth0 up && ip link set veth1 up

6. Give one of the interfaces an IP address on the subnet into which you are connecting.

         ip addr add 192.168.100.9/24 dev veth0
         ovs-vsctl add-port ovsbr2 veth1

7. Do the same on the virtual host (10.0.0.2), except we don't need to give the veth an IP address.

         cat << EOF > /etc/sysconfig/network-scripts/ifcfg-ovsbr2
         DEVICE=ovsbr2
         DEVICETYPE=ovs
         ONBOOT=yes
         TYPE=OVSBridge
         BOOTPROTO=none
         DELAY=0
         HOTPLUG=no
         EOF

Now start the bridge

         ifup ovsbr2

8. Setup up the tunnel

         ovs-vsctl add-port ovsbr2 vx1 -- set interface vx1 type=vxlan options:remote_ip=10.0.0.1

9. Open up a port

with firewall-cmd (recommended, F20+, RHEL 7+, F19 doesn't seem to work):

         firewall-cmd --permanent --add-rich-rule 'rule family="ipv4" source address="10.0.0.1/32" port port="4789" protocol="udp" accept'
         firewall-cmd --reload

iptables can also be used directly:

         lineno=$(iptables -nvL INPUT --line-numbers | grep "state RELATED,ESTABLISHED" | awk '{print $1}')
         iptables -I INPUT $lineno -s `<vxlan-endpoint>`/32 -p udp -m multiport --dports 4789 -m comment --comment "001 vxlan incoming `<vxlan-endpoint>`" -j ACCEPT

10. Now, create the veth pair, and bring the interfaces up.

         ip link add name veth0 type veth peer name veth1
         ip link set veth0 up && ip link set veth1 up

11. Plug one veth into the brbm

         ovs-vsctl add-port brbm veth1

12. Plug the other veth into the tunnel switch

         ovs-vsctl add-port ovsbr2 veth0

13. At this point, you should be able to ping a VM from the remote host.

         (From 10.0.0.1): ping 192.168.100.55

<Category:Documentation> <Category:Networking> <Category:TripleO>
