---
title: Neutron with existing external network
authors: dneary, fale, javexed, mangelajo, mrunge, rbowen
wiki_title: Neutron with existing external network
wiki_revision_count: 12
wiki_last_updated: 2015-06-17
---

# Neutron with existing external network

Many people have asked how to use packstack --allinone with an existing external network. This method should allow any machine on the network to be able to access launched instances via their floating IPs. Also, at the end of this message, there are some ideas for making this process better that I thought we could discuss.

These instructions have been tested on a RHEL 6.4 "minimal" install VM attached to the default libvirt network. Make sure all of your repos are set up first:

    sudo yum install -y http://rdo.fedorapeople.org/rdo-release.rpm
    sudo yum install -y openstack-packstack

and that you have run

    yum update

and have rebooted first to ensure packages are up to date and you are running the correct kernel.

    # packstack --allinone --provision-all-in-one-ovs-bridge=n

After completion, given a single machine with a current IP of 192.168.122.212/24 via DHCP with gateway of 192.168.122.1:

Make /etc/sysconfig/network-scripts/ifcfg-br-ex resemble: (note this file shouldn't exist, but does due to a bug)

    DEVICE=br-ex
    DEVICETYPE=ovs
    TYPE=OVSBridge
    BOOTPROTO=static
    IPADDR=192.168.122.212 # Old eth0 IP since we want the network restart to not kill the connection, otherwise pick something outside your dhcp range
    NETMASK=255.255.255.0  # your netmask
    GATEWAY=192.168.122.1  # your gateway
    DNS1=192.168.122.1     # your nameserver
    ONBOOT=yes

Make /etc/sysconfig/network-scripts/ifcfg-eth0 resemble (no BOOTPROTO!):

Note: if on Centos7, the file is /etc/sysconfig/network-scripts/enp2s0

    DEVICE=eth0 # or enp2s0 if on CentOS 7
    HWADDR=52:54:00:92:05:AE # your hwaddr
    TYPE=OVSPort
    DEVICETYPE=ovs
    OVS_BRIDGE=br-ex
    ONBOOT=yes

Add to the /etc/neutron/plugin.ini file these lines:

    network_vlan_ranges = physnet1
    bridge_mappings = physnet1:br-ex

Restart the network service

    # service network restart

NOTE: It is important to do the network restart before setting up the router gateway below, because a network restart takes destroys and recreates br-ex which causes the router's interface in the qrouter-\* netns to be deleted, and it won't be recreated without clearing and re-setting the gateway.

    # . keystonerc_admin
    # neutron router-gateway-clear router1
    # neutron subnet-delete public_subnet

You need to recreate the public subnet with an allocation range outside of your external DHCP range and set the gateway to the default gateway of the external network.

    # neutron subnet-create --name public_subnet --enable_dhcp=False --allocation-pool=start=192.168.122.10,end=192.168.122.20 --gateway=192.168.122.1 public 192.168.122.0/24
    # neutron router-gateway-set router1 public

You should now be able to follow the steps at [running an instance with Neutron](running an instance with Neutron) to launch an instance with external network access.

## Possible improvements

Now, the question is how we make this better. Currently, Gilles Dubreuil is working on a patch to the puppet-vswitch module that can automatically handle the whole "move eth0 into the bridge and give the bridge its IP" issue. He's working through the last of the issues, but it is looking really good. If we are going to handle this automatically in packstack for people, though, it's really best if the external network interface is different from the one we are using for packstack since mucking with the interface you are connecting over is tricky. At the very least, if it is the same interface, then it needs to be configured with a static IP so that when br-ex comes up it will have the same address that eth0 had. Most likely things will pick up fine after the brief network interruption.

So, if we go this way, then it would make sense for us to add a config option for PROVISION_DEMO_EXT_IF (which should be determinable automatically, but overridable), PROVISION_DEMO_EXT_POOL and convert the existing PROVISION_DEMO_FLOATRANGE to be PROVISION_DEMO_EXT_CIDR since that was it really is. Also having an option that toggled whether or not we actually did the bridge setup would be advisable.

But, in the end it should be possible to have something like:

    packstack --allinone --use-existing-external-net=y --provision-demo-ext-cidr=192.168.122.0/24 --provision-demo-ext-pool=192.168.122.10,192.168.122.40

## See also

Watch this video for a demonstration of how to use DHCP on the bridge, including cloning the MAC address from eth0: <https://www.youtube.com/watch?v=8zFQG5mKwPk>
