---
title: Fedora 20 with existing network
authors: rbowen
wiki_title: Fedora 20 with existing network
wiki_revision_count: 2
wiki_last_updated: 2015-03-13
---

# Fedora 20 with existing network

(Originally posted at <https://ask.openstack.org/en/question/24719/how-to-install-packstack-allinone-on-fedora-20-with-an-existing-external-network/> )

Goal: install a working openstack allinone deployment on Fedora 20 with an existing external network

Environment: This machine is at home which means that it uses DHCP to acquire a local address from my router. The router is the DHCP and DNS server for the home network. My machine gets the address 192.168.1.4 and the router is 192.168.1.1. I am running Fedora 20. My installation automatically created em1 (not eth0).

    yum -y update

    # enable sshd
    systemctl enable sshd
    systemctl start sshd

    # enable zfs-fuse
    yum -y install zfs-fuse
    systemctl enable zfs-fuse
    systemctl start zfs-fuse

    # do initial setup of openvswitch

    # this is following "openstack packstack installation with external connectivity"
    # (http://allthingsopen.com/2013/08/23/openstack-packstack-installation-with-external-connectivity/)

    yum -y install openvswitch

    # Make /etc/sysconfig/network-scripts/ifcfg-br-ex resemble this:

    cat <<EOF >/etc/sysconfig/network-scripts/ifcfg-br-ex
    DEVICE=br-ex
    OVSBOOTPROTO=dhcp
    OVSDHCPINTERFACES=em1
    NM_CONTROLLED=no
    ONBOOT=yes
    TYPE=OVSBridge
    DEVICETYPE=ovs
    EOF

    # Make /etc/sysconfig/network-scripts/ifcfg-em1 resemble this (but change the HWADDR and UUID to match what is currently in ifcfg-em1

    cat <<EOF >/etc/sysconfig/network-scripts/ifcfg-em1
    DEVICE="em1"
    HWADDR="BC:AE:C5:74:97:11"
    UUID="dd86d0fb-dedf-4fd8-be7c-f99b19dbfe0d"
    TYPE="OVSPort"
    DEVICETYPE="ovs"
    OVS_BRIDGE="br-ex"
    ONBOOT="yes"
    NM_CONTROLLED="no"
    EOF

    # stop using NetworkManager, start using network

    systemctl stop NetworkManager
    systemctl disable NetworkManager

    systemctl enable network

    reboot

    # once we are back from the reboot, verify that we still have network connectivity:

    curl rdoproject.org/QuickStart

    # at this point, 'ovs-vsctl show' looks like:

    ovs-vsctl show

        Bridge br-ex
            Port "em1"
                Interface "em1"
            Port br-ex
                Interface br-ex
                    type: internal
        ovs_version: "2.0.0"

    # install packstack (but don't run it yet)

    yum -y install openstack-packstack

    # (from the allthingsopen site)
    # "Edit /usr/lib/python2.7/site-packages/packstack/puppet/modules/openstack/manifests/provision.pp and change $floating_range to a range that is suitable for the network em1 is on.". As I stated previous, my network is a local network behind the router. I chose 192.168.1.192-192.168.1.222 for my floating_range

    sed -e "s/^  $floating_range            = .*$/  $floating_range            = '192.168.1.192\/27',/g" -i /usr/lib/python2.7/site-packages/packstack/puppet/modules/openstack/manifests/provision.pp

    # (again from the allthingsopen site)
    # "One last modification before we run packstack, and thanks to Terry Wilson for pointing this out, we need to remove a a firewall rule that is added during the packstack run that adds a NAT rule which will effectively block inbound traffic to a launched instance. You can edit /usr/lib/python2.7/site-packages/packstack/puppet/templates/provision.pp and comment out the following lines.

    # firewall { '000 nat':
    #   chain  =&gt; 'POSTROUTING',
    #   jump   =&gt; 'MASQUERADE',
    #   source =&gt; $::openstack:rovision::floating_range,
    #   outiface =&gt; $::gateway_device,
    #   table =&gt; 'nat',
    #   proto =&gt; 'all',
    # }

    # implement workarounds found in "Workarounds 2014 01" (http://rdoproject.org/Workarounds_2014_01)

    setenforce 0

    # I go further and disable selinux by editing /etc/selinux/config and setting
    # SELINUX=enforcing to SELINUX=permissive

    # Fedora 20 uses mariadb instead of mysql. Install it now

    yum -y install mariadb-server

    rm -f /usr/lib/systemd/system/mysqld.service
    cp /usr/lib/systemd/system/mariadb.service /usr/lib/systemd/system/mysqld.service

    # precreate the mysqld.log otherwise the packstack script will fail
    touch /var/log/mysqld.log
    chown mysql:mysql /var/log/mysqld.log

    sed -e 's/mysql/mariadb/g' -i /usr/lib/python2.7/site-packages/packstack/puppet/modules/tempest/manifests/params.pp

    # stop sshd for a moment so that when we run packstack it creates the answer file and then stops at the first step

    systemctl stop sshd

    # pre-generate the answer file

    packstack --allinone

    # rename the answer file to make it easier to reference in the following steps

    cd /root
    mv packstack-answers-*.txt packstack-answers.txt

    # restart sshd

    systemctl start sshd

    # change the password for the demo user

    sed -e 's/CONFIG_KEYSTONE_DEMO_PW=.*$/CONFIG_KEYSTONE_DEMO_PW=openstack/g' -i /root/packstack-answers.txt

    # change the floating ip range to be the $floating_range we set above 

    sed -e 's/CONFIG_PROVISION_DEMO_FLOATRANGE=.*$/CONFIG_PROVISION_DEMO_FLOATRANGE=192.168.1.192\/27/g' -i /root/packstack-answers.txt

    # run packstack. This should run without errors
    packstack --answer-file=/root/packstack-answers.txt

    # when it is finally done, continue

    # set dns for demo private_subnet
    source /root/keystonerc_demo
    neutron subnet-update private_subnet --dns_nameservers list=true 192.168.1.1

    # set public interface for floating ip addresses to em1
    sed -e 's/#public_interface=eth0$/public_interface=em1/g' -i /etc/nova/nova.conf

    # restart the nova-api service
    systemctl restart openstack-nova-api

    # add the floating ips
    source /root/keystonerc_admin
    nova floating-ip-bulk-create 192.168.1.192/27
    nova-manage floating list

    # (from the allthingsopen site)
    # "Before we start provisioning instances in Horizon let’s take care of one last step and add two security group rules to allow ssh and icmp to our instances.

    source /root/keystonerc_demo 
    nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
    nova secgroup-add-rule default tcp 22 22 0.0.0.0/0

    # if you don't have an existing pair of private/public keys, generate one

    ssh-keygen -t rsa

    # create the matching pem file

    openssl rsa -in ~/.ssh/id_rsa -outform PEM -out ~/.ssh/<your login>.pem

    # login in to the dashboard http://localhost/dashboard

    # create a keypair -> Access & Security -> Keypairs -> ImportKeypair (paste in your public key - id_rsa.pub)

    # launch a instance from the cirros image (name it, set admin pass, select private network)

    # associate a floating ip address (select '+' - a floating ip address from the list shown above with 'nova-manage floating list' should be selected)

    # after the instance launches, you should be able to ssh in to the instance

    ssh -i ~/.ssh/<your login>.pem cirros@<associated floating ip>

    # I had real problems with my instances once I installed gnome on them. After much searching I figured out that I needed to change the cpu mode qemu uses. My cpu reports that it supports avx, but when kvm tries to emulate that instruction it crashes. I had to  change the libvirt_cpu_mode to be host-passthrough so that libvirt didn't know about the support for avx

    sed -e 's/#libvirt_cpu_mode=.*$/libvirt_cpu_mode=host-passthrough/g' -i /etc/nova/nova.conf

    # rename the demo project to something more appropriate
    # Sign Out of the dashboard and login as the admin user
    #  - remember that the password for the admin user is in /root/keystonerc_admin
    # Navigate to Projects and under the More actions for the demo project, select
    #    Edit Project.
    # Change the name. I chose 'home' because I'm using this at home. Click Save.

    # rename the demo user to someone more appropriate
    # Navigate to Users and select Edit for the demo user
    # Change the name and the password. I chose my login id. Click Save.
    # Sign out and sign back in as that user.

    # Remember to change the tenant id in /root/keystonerc_admin and the tenant, username and password in /root/keystonerc_demo (you might rename keystonerc_demo as well)

    # note that after rebooting, the network will be messed up
    # to get connectivity restored, run the following script

    cat <<EOF >restore-network-after-reboot.sh
    #!/bin/bash

    ifdown em1
    ifdown br-ex
    ifup br-ex
    ifup em1
    ip route add default via 192.168.1.1
    EOF

    # to get openstack running again, rerun packstack

    packstack --answer-file=/root/packstack-answers.txt
