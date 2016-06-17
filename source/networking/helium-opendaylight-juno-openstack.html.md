---
title: Helium OpenDaylight Juno OpenStack
authors: alvinho, dneary, flaviof, shague
wiki_title: Helium OpenDaylight Juno OpenStack
wiki_revision_count: 16
wiki_last_updated: 2015-02-01
---

# Helium OpenDaylight Juno OpenStack

## Introduction

This page describes how to setup a two node OpenStack setup using ml2 to integrate with Helium-SR1 and Helium OpenDaylight and Juno OpenStack. The setup guide for Hydrogen OpenDaylight and Icehouse Openstack can be found [OpenDaylight_integration](OpenDaylight_integration).

The topology:

*   Everything is hosted on a Fedora host.
*   KVM is the hypervisor.
*   OpenDaylight runs directly on the host.
*   Two VMs are created for the OpenStack nodes: one control+network+compute node and one compute node.

## Create OpenStack VM's

Follow the instructions [OVSDB:Helium and OpenStack on Fedora 20](https://wiki.opendaylight.org/view/OVSDB:Helium_and_Openstack_on_Fedora20#VMs) to create two guest VMs to serve as the OpenStack nodes. Skip the last steps for installing devstack.

## Packstack

Use [Quickstart](Quickstart) to install the packstack on the control node and install the OpenStack components. This will create the packstack file that we will change to also install OpenStack on the second node. Try these forms of the command to keep the system as clean as possible: `packstack --allinone --provision-demo=n --provision-all-in-one-ovs-bridge=n` and `packstack --answer-file=packstack-answers.txt --provision-demo=n --provision-all-in-one-ovs-bridge=n`.

I ran packstack once, changed all the 192.168.122.xx addresses to 192.168.120.51 and reran packstack. I did this because by default the allinone used eth0 for the control addresses but in my setup I wanted eth2 to be the controller interface.

You could probably also just use the attached packstack-answers.txt file and start with it. Modify the values to fit the addresses you chose for the guest VMs. This would also get around having to run packstack twice as I did above. [packstack-answers.txt](https://github.com/shague/packstack_stuff/blob/master/packstack/packstack-answers-20141130-164347.txt)

In the example packstack_answer.txt file the node IP addresses are:

*   control+compute: 192.168.120.51
*   compute: 192.168.120.52

Next we modify the packstack-answers.txt file to also install OpenStack on the compute node. Make the following changes to the file:</br>

*   CONFIG_COMPUTE_HOSTS=192.168.120.51,192.168.120.52
*   CONFIG_NETWORK_HOSTS=192.168.120.51,192.168.120.52

Rerun packstack, packstack --answer-file=packstack-answers.txt. This should install OpenStack on the compute node.

I like to create really small VM images when testing so do the following if you want the smaller images. Then you can use m1.nano for VM instantiation.

      glance image-create \
        --copy-from http://download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img \
        --is-public true \
        --container-format bare \
        --disk-format qcow2 \
        --name cirros
      nova flavor-create m1.nano auto 128 1 1

Now we should have a functioning setup using ML2 and OpenvSwitch networking. You can create some VMs and see what happens.

If you hit this error [Fedora20: packstack gives undefined method \`split' for nil:NilClass](https://bugzilla.redhat.com/show_bug.cgi?id=1080481) then increase the memory for the VM to 4GB.

## Clean Up Networking on Nodes

By default the allinone install created OpenvSwitch bridges and OpenStack projects that just pollutes the setup so if you did not use

    --provision-demo=n

, we will clean up everything before changing Neutron's configuration. Once we have switched Neutro to using ML2 to OpenDaylight, we will need to stop and disable neutron-openvswitch-agent on all hosts. This is because OpenDaylight replaces the l2 agent and manages the remote vSwitches directly. I also ran some vxlan tunnel tests with using the standard ml2 OpenvSwitch setup and I believe that is where many extra crumbs were left.

This script is more of a template for some neutron commands to run to clean out the existing projects and networks. If your system is clean there is no need to run the commands. Use the neutron list commands to see if these steps are needed.

      neutron port-list
      neutron port-delete id

      neutron net-list
      neutron dhcp-agent-list-hosting-net vx-net
      neutron dhcp-agent-network-remove <subnet UUID from previous command> vx-net

      neutron router-list
      neutron router-port-list vx-rtr
      neutron router-interface-delete vx-rtr <subnet_id>
      neutron router-gateway-clear vx-rtr <subnet_id> - the 172.x address
      neutron router-delete vx-rtr

      neutron subnet-list
      neutron subnet-list id|name
      neutron subnet-delete private-subnet

      neutron net-list
      neutron net-show private
      neutron net-delete private

      keystone tenant-list
      keystone tenant-delete demo

      neutron subnet-delete public-subnet
      neutron net-delete public

## Configure Control+Network+Compute Node to use OpenDaylight ML2 Plugin

Packstack does not have support for OpenDaylight yet so we need to do manual steps to enable the support. The below steps will disable the openvswitch agent, add ML2 OpenDaylight support and restart neutron. Recall that in this setup the OpenDaylight controll is running on the host at 192.168.120.1. Change the value below if you have a different address.

      sudo systemctl stop neutron-server
      sudo systemctl stop neutron-openvswitch-agent
      sudo systemctl disable neutron-openvswitch-agent

      # Stops, cleans and restarts openvswitch and logs captured.

      sudo systemctl stop openvswitch
      sudo rm -rf /var/log/openvswitch/*
      sudo rm -rf /etc/openvswitch/conf.db
      sudo systemctl start openvswitch

      sudo crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 mechanism_drivers opendaylight 
      sudo crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 tenant_network_types vxlan

      cat <<EOT | sudo tee -a /etc/neutron/plugins/ml2/ml2_conf.ini > /dev/null
      [ml2_odl]
      password = admin
      username = admin
      url = http://192.168.120.1:8080/controller/nb/v2/neutron
      EOT

      sudo mysql -e "drop database if exists neutron_ml2;"
      sudo mysql -e "create database neutron_ml2 character set utf8;"
      sudo mysql -e "grant all on neutron_ml2.* to 'neutron'@'%';"
      sudo neutron-db-manage --config-file /usr/share/neutron/neutron-dist.conf --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini upgrade head

      sudo systemctl start neutron-server

This next script will attempt to clean up any namespaces, ports or bridges still hanging around. Make sure to use `sudo ovs-vsctl show` to determine if this is even needed.

      #!/bin/bash

      ` for ns in `ip netns` `
      do
      `     `sudo ip netns del $ns` `
      done

      ` for qvb in `ifconfig -a | grep qvb | cut -d' ' -f1` `
      do
      `     `sudo ip link set $qvb down` `
      `     `sudo ip link delete $qvb` `
      done
      ` for qbr in `ifconfig -a | grep qbr | cut -d' ' -f1` `
      do
      `     `sudo ip link set $qbr down` `
      `     `sudo ip link delete $qbr` `
      done
      ` for qvo in `ifconfig -a | grep qvo | cut -d' ' -f1` `
      do
      `     `sudo ovs-vsctl --if-exists del-port br-int $qvo` `
      done
      ` for tap in `ifconfig -a | grep tap | cut -d' ' -f1` `
      do
          tap="${tap%?}"
      `     `sudo ip link set $tap down` `
      `     `sudo ovs-vsctl --if-exists del-port br-int $tap` `
      done

      ` for i in `sudo ovs-vsctl show | grep Bridge | awk '{print $2}'` ; do `
          if [[ $i == *br-eth1* ]]; then
              sudo ovs-vsctl --if-exists del-br 'br-eth1'
          else
              sudo ovs-vsctl --if-exists del-br $i
          fi
      done

      ` for i in `ip addr | grep tap | awk '{print $2}'`; do `
          tap="${i%?}"
          echo "tap=$tap"
          sudo ip link del dev $tap
      done

      for i in phy-br-eth1 int-br-eth1; do
          ip -o link show dev $i &> /dev/null
          if [ $? -eq 0 ]; then
              sudo ip link del dev $i
          fi
      done

      for iface in br-ex br-int br-tun; do
          sudo ovs-dpctl del-if ovs-system $iface
      done

      echo "Delete vxlan_xxx if present"
      ` for iface in `sudo ovs-dpctl show | awk 'match($0, /[Pp]ort\s+[[:digit:]]+\s*\:\s*(.+).+\(vxlan/, m) { print m[1]; }'` ; do `
         echo ${iface} ; sudo ovs-dpctl del-if ovs-system ${iface}
      done

      sudo ovs-dpctl show

At this point the control node should be clean so now clean up the compute node. Use the above two steps to clean anything up. Then use the following script to stop the openvswitch agent and reset OpenvSwitch:

      sudo systemctl stop neutron-openvswitch-agent
      sudo systemctl disable neutron-openvswitch-agent

      # Stops, cleans and restarts openvswitch and logs captured.

      sudo systemctl stop openvswitch
      sudo rm -rf /var/log/openvswitch/*
      sudo rm -rf /etc/openvswitch/conf.db
      sudo systemctl start openvswitch
      sudo ovs-vsctl show

## Start OpenDaylight

Follow the instructions at [OVSDB:Helium and OpenStack on Fedora 20](https://wiki.opendaylight.org/view/OVSDB:Helium_and_Openstack_on_Fedora20#OpenDaylight_Distribution) to see how to download the Helium-SR1 version and start it. In this setup OpenDaylight is installed on the host and started there.

## Configure Nodes to Connect to OpenDaylight

The nodes need to be configured to use the OpenDaylight controller. Recall that in this setup the OpenDaylight controll is running on the host at 192.168.120.1. Change the value below if you have a different address. Run the below script on both nodes.

      #/bin/bash

      eth2=$(ip -o addr show dev eth2 | grep -w inet | awk '{print $4}' | sed -e 's/\/.*//g')
      ovs-vsctl set-manager tcp:192.168.120.1:6640
      read ovstbl <<< $(ovs-vsctl get Open_vSwitch . _uuid)
      ovs-vsctl set Open_vSwitch $ovstbl other_config:bridge_mappings=physnet1:eth1,physnet3:eth3
      ovs-vsctl set Open_vSwitch $ovstbl other_config:local_ip=$eth2

      ovs-vsctl list Manager
      echo
      ovs-vsctl list Open_vSwitch

## Verification

Setup a vxlan tunnel between the two nodes to verify the setup. Use the vnc console of one of the VM's and try to ping the other VM. In the test below the two VMs should have the addresses 10.100.5.2 and 10.100.5.4 if ran the first time.

      neutron net-create vx-net --provider:network_type vxlan --provider:segmentation_id 1400
      neutron subnet-create vx-net 10.100.5.0/24 --name vx-subnet
      neutron router-create vx-rtr
      neutron router-interface-add vx-rtr vx-subnet
      nova boot --flavor m1.nano --image $(nova image-list | grep 'uec\s' | awk '{print $2}' | tail -1) --nic net-id=$(neutron net-list | grep -w vx-net | awk '{print $2}') vmvx1 --availability_zone=nova:fedora51
      nova boot --flavor m1.nano --image $(nova image-list | grep 'cirros\s' | awk '{print $2}' | tail -1) --nic net-id=$(neutron net-list | grep -w vx-net | awk '{print $2}') vmvx2 --availability_zone=nova:fedora52
      nova get-vnc-console vmvx1 novnc
      nova get-vnc-console vmvx2 novnc
