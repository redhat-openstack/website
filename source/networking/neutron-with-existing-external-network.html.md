---
title: Neutron with existing external network
authors: dneary, fale, javexed, mangelajo, mrunge, rbowen
wiki_title: Neutron with existing external network
wiki_revision_count: 12
wiki_last_updated: 2015-06-17
---

# Neutron with existing external network

Many people have asked how to use packstack --allinone with an existing external network. This method should allow any machine on the network to be able to access launched instances via their floating IPs. Also, at the end of this message, there are some ideas for making this process better that I thought we could discuss.

These instructions have been tested on Centos 7.

Initially, follow the [Quickstart](Quickstart) but stop when you see the first "packstack --allinone" at Step 3, instead do:

    # packstack --allinone --provision-demo=n

(There's an alternate method using packstack --allinone --provision-all-in-one-ovs-bridge=n, but it's more complicated)

After completion, given a single machine with a current IP of 192.168.122.212/24 via DHCP with gateway of 192.168.122.1:

Make /etc/sysconfig/network-scripts/ifcfg-br-ex resemble: (note this file will exist, and IPADDR/NETMASK will be populated with _br_ex at the end, remove that part, and fill all the missing fields)

    DEVICE=br-ex
    DEVICETYPE=ovs
    TYPE=OVSBridge
    BOOTPROTO=static
    IPADDR=192.168.122.212 # Old eth0 IP since we want the network restart to not 
                           # kill the connection, otherwise pick something outside your dhcp range
    NETMASK=255.255.255.0  # your netmask
    GATEWAY=192.168.122.1  # your gateway
    DNS1=192.168.122.1     # your nameserver
    ONBOOT=yes

This file will configure the network parameters we probably had into our eth0 interface but, over br-ex.

Make /etc/sysconfig/network-scripts/ifcfg-eth0 resemble (no BOOTPROTO!):

Note: if on Centos7, the file could be /etc/sysconfig/network-scripts/enp2s0

    DEVICE=eth0
    HWADDR=52:54:00:92:05:AE # your hwaddr (find via ip link show eth0)
    TYPE=OVSPort
    DEVICETYPE=ovs
    OVS_BRIDGE=br-ex
    ONBOOT=yes

This means, we will bring up the interface, and plug it into br-ex OVS bridge as a port, providing the uplink connectivity.

Modify the following config parameter:

    openstack-config --set /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini ovs bridge_mappings extnet:br-ex

This will define a logical name for our external physical L2 segment, as "extnet", this will be referenced as a provider network when we create the external networks.

This one will overcome a packstack deployment bug where only vxlan is made available.

    openstack-config --set /etc/neutron/plugin.ini ml2 type_drivers vxlan,flat,vlan

Restart the network service

    # reboot

    or, alternatively:

    # service network restart
    # service neutron-openvswitch-agent restart
    # service neutron-server restart

NOTE: It is important to do the network restart before setting up the router gateway below, because a network restart takes destroys and recreates br-ex which causes the router's interface in the qrouter-\* netns to be deleted, and it won't be recreated without clearing and re-setting the gateway.

    # . keystonerc_admin
    # neutron net-create external_network --provider:network_type flat --provider:physical_network extnet  --router:external --shared

Please note: "extnet" is the L2 segment we defined in the bridge_mappings above (plugin.ini file, ml2 section).

You need to recreate the public subnet with an allocation range outside of your external DHCP range and set the gateway to the default gateway of the external network.

Please note: 192.168.122.1/24 is the router and CIDR we defined in /etc/sysconfig/network-scripts/ifcfg-br-ex for external connectivity.

    # neutron subnet-create --name public_subnet --enable_dhcp=False --allocation-pool=start=192.168.122.10,end=192.168.122.20 \
                            --gateway=192.168.122.1 external_network 192.168.122.0/24
    # neutron router-create router1
    # neutron router-gateway-set router1 external_network

Now create a private network and subnet, since that provisioning has been disabled:

    # neutron net-create private_network
    # neutron subnet-create --name private_subnet private_network 192.168.100.0/24

And connect this private network to the public network via the router, which will provide the floating IP addresses.

    # neutron router-interface-add router1 private_subnet

Get a cirrus image, not provisioned without demo provisioning:

    curl http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img | glance \
             image-create --name='cirros image' --is-public=true  --container-format=bare --disk-format=qcow2

Finally, for your user, you need to create a network and connect that network through a router to your shared and external network. Since you don't created a user yet

    keystone tenant-create --name internal --description "internal tenant" --enabled true
    keystone user-create --name internal --tenant internal --pass "foo" --email bar@corp.com --enabled true

Easiest way to the network and to launch instances is via horizon, which was set up by packstack.

You should now be able to follow the steps at [running an instance with Neutron](running an instance with Neutron) to launch an instance with external network access as admin, if you want other tenants you may need to create them manually.

## Possible improvements

Now, the question is how we make this better. Currently, Gilles Dubreuil is working on a patch to the puppet-vswitch module that can automatically handle the whole "move eth0 into the bridge and give the bridge its IP" issue. He's working through the last of the issues, but it is looking really good. If we are going to handle this automatically in packstack for people, though, it's really best if the external network interface is different from the one we are using for packstack since mucking with the interface you are connecting over is tricky. At the very least, if it is the same interface, then it needs to be configured with a static IP so that when br-ex comes up it will have the same address that eth0 had. Most likely things will pick up fine after the brief network interruption.

So, if we go this way, then it would make sense for us to add a config option for PROVISION_DEMO_EXT_IF (which should be determinable automatically, but overridable), PROVISION_DEMO_EXT_POOL and convert the existing PROVISION_DEMO_FLOATRANGE to be PROVISION_DEMO_EXT_CIDR since that was it really is. Also having an option that toggled whether or not we actually did the bridge setup would be advisable.

But, in the end it should be possible to have something like:

    packstack --allinone --use-existing-external-net=y --provision-demo-ext-cidr=192.168.122.0/24 --provision-demo-ext-pool=192.168.122.10,192.168.122.40

## See also

Watch this video for a demonstration of how to use DHCP on the bridge, including cloning the MAC address from eth0: <https://www.youtube.com/watch?v=8zFQG5mKwPk>
