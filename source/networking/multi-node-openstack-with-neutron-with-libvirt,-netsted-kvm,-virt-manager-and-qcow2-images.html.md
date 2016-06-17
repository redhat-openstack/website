---
title: Multi-node Openstack with Neutron with libvirt, netsted kvm, virt-manager and
  qcow2 images
category: networking
authors: otherwiseguy, rbowen
wiki_category: Networking
wiki_title: Multi-node Openstack with Neutron with libvirt, netsted kvm, virt-manager
  and qcow2 images
wiki_revision_count: 4
wiki_last_updated: 2013-12-18
---

# Multi-node Openstack with Neutron with libvirt, netsted kvm, virt-manager and qcow2 images

## Introduction

The goal of this process is to end up with a RHEL-based multi-node environment for working on Openstack with Neutron and packstack on a single physical machine using libvirt, netsted kvm, virt-manager and qcow2 images. This setup uses two libvirt networks, one for external communication and one data network for internal communication between openstack services. Four instances will be created: one controller node, two compute nodes, and a network node.

## Setting up the physical machine

Start with F19 default Gnome Desktop install, setting up your user account, etc.

### Install required packages

    $ sudo yum install virt-manager qemu-kvm sys libguestfs-tools

### Enable nested kvm

    $ echo "options kvm-intel nested=y" | sudo tee /etc/modprobe.d/kvm-intel.conf
    $ reboot

### Creating a RHEL 6.4 base install VM

*   Start virt-manager
*   Click New VM

![](new_vm.png "new_vm.png")

*   Fields
    -   Name: rhel-6.4
    -   Network Install
*   Click Forward

![](net_install.png "net_install.png")

*   Fields
    -   URL: The network install location for your distro, e.g. <http://><server>/RHEL-6/6.4/Server/x86_64/os/
*   Click Forward

![](memory_cpu.png "memory_cpu.png")

*   Fields
    -   Memory: 2048
    -   CPU: 2
*   Click Forward

![](vm_storage_cfg.png "vm_storage_cfg.png")

*   Fields
    -   Check Enable storage for this virtual machine
    -   Select Select managed or other existing storage
*   Click Browse

![](manage_storage.png "manage_storage.png")

*   Click New Volume

To enable snapshot capability, we need to ensure that VMs are backed by a qcow2 image instead of the default raw.

![](new_volume.png "new_volume.png")

*   Fields
    -   Name: rhel-6.4
    -   Format: qcow2
    -   Max Capacity: 8192MB (Works for me, but I don't use cinder. Might as well make this 30GB if you want space to store lots of images)
    -   Allocation: 8192MB (I pre-allocate out of habit)
*   Click Finish

Select rhel-6.4.img and click Choose Volume Click Forward

Check "Customize configuration before install" and click Finish

![](8-configure_cpu.png "8-configure_cpu.png")

*   Fields
    -   Select "Processor" and expand > Configuration and click "Copy host CPU configuration"
    -   Ensure 'vme' and 'vmx' are set to 'require' and click 'Apply' and then "Begin Installation"
*   Click Apply

## Setting up the base RHEL 6.4 VM

### Installation

Go through the RHEL 6.4 installation process

*   Notes
    -   I edit the default partitioning layout to reduce the swap size by half and give the extra space to lv_root. If you make your base install larger than I do, you don't have to worry so much about this.
    -   Select "Minimal" install (not Basic Server)

### Configuration

After VM installation completes and reboot, we need to do some basic setup and make a snapshot of the fresh install so you can just clone new VMs from it. Make sure your base distro repositories are set up, RHEL registration is done, etc.

Install the EPEL repo:

    # yum -y localinstall http://mirrors.kernel.org/fedora-epel/6/i386/epel-release-6-8.noarch.rpm

and update the system

    # yum -y update

To take a snapshot, open up a terminal on your physical machine and run:

    sudo virsh snapshot-create-as rhel-6.4 fresh_install "Fresh RHEL 6.4 install" --atomic --reuse-external

After creating the base install snapshot, set up the repo for the RDO version you are targeting for development.

RDO-grizzly:

    # yum install -y http://rdo.fedorapeople.org/openstack-grizzly/rdo-release-grizzly.rpm

RDO-havana:

    yum install -y http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm

NOTE: Repository mirroring isn't in the scope of this document, but if you are not on the same LAN as your yum repositories, it is an extremely good idea to create a local mirror of your repositories. A quick and dirty method is to essentially copy over all of the /etc/yum.repos.d/ repo contents to something like ~/reposync/yum.conf, then:

    reposync -n -c yum.conf
    for i in */;do createrepo -c cache $i;done.

      and a quick and dirty way to serve them up is:

    sudo python -m SimpleHTTPServer 80

(make sure to open port 80 on your firewall).

At this point, the rhel-6.4 VM should be powered off.

## Setting up the Openstack nodes

### Introduction

We are going to create 4 VMs:

1x Controller node: All of the openstack API services go here
2x Compute node: VMs will be launched from here
1x Network node: Neutron L3 and DCHP services will be run from here.  

This installation will use two different libvirt networks:

data: This will be the "internal" network that openstack services use to communicate with each other. We will have to create this network.
default: This is the default libvirt network. This will serve as our "external" network. It is a NATed connection and will have access to the outside world. Theoretically, only the Network Node will need this connection--but this is only the case if we have local mirrors set up accessible via the 'data' network for all of the repositories we need.  

This document will assume that a local mirror has \*not\* exist and add the default network to each VM. If you have a local mirror, just add the default network interface to the Network Node.

### Creating the "data" network

Edit -> Connection Details -> Virtual Networks

![](9-new_virtual_network.png "9-new_virtual_network.png")

*   Click '+' and the Click Forward through the instructions

![](10-name_virtual_netowrk.png "10-name_virtual_netowrk.png")

*   Fields
    -   Network Name: data
*   Click Forward

![](11-ipv4_network_setup.png "11-ipv4_network_setup.png")

*   Fields
    -   Check Enable IPv4 network address space definition
    -   Network:192.168.100.0/24
    -   Enable DHCPv4 (we will add static DHCP assignments for our instances later)
*   Click Forward

<!-- -->

*   Skip IPv6 for now (sigh)
*   Click Forward

![](12-misc_network_setup.png "12-misc_network_setup.png")

*   Fields
    -   Select isolated virtual network
*   Click Forward

![](13-finalize_network_setup.png "13-finalize_network_setup.png")

*   Click Finish

### Cloning the openstack service nodes

First, clone rhel-6.4 for the controller node: Since we have an snapshot of the existing install already, we can run virt-sysprep to fix some of the issues that cloning would cause. First and foremost is that /etc/udev/rules.d/70-persistent-net.rules and /etc/sysconfig/network-scripts/ifcfg-eth0 will have the hard-coded MACs from the cloned VM which will change.

From a terminal on the physical machine:

    $ sudo virt-sysprep -d rhel-6.4

From virt-manager: Right-click rhel-6.4 -> Clone

![](14-clone_controller.png "14-clone_controller.png")

*   Fields
    -   Name: rhel-6.4-controller
    -   Networking: NAT
    -   Storage: rhel-6.4.img
        -   Clone this disk (8.0 GB)
*   Click Clone

Select rhel-6.4-controller and click Open View -> Details

![](15-add_hardware.png "fig:15-add_hardware.png") Click Add Hardware Select Network

![](16-add_network_interface.png "16-add_network_interface.png")

*   Fields
    -   Host device: Virtual network 'data': Isolated network, internal and host routing only
*   Click Finish

NOTE: If you have a local mirror of your yum repositories, instead of adding a new network interface, modify the existing network interface to Source device: Virtual network 'data': Isolated network, internal and host routing only

### Add static DHCP address mapping

It's ugly, but you can add that static DHCP entry for the VM by:

    sudo virsh net-update data add-last ip-dhcp-host --xml "<host mac='`sudo virsh domiflist rhel-6.4-controller|grep data|awk '{print $5}'`' ip='192.168.100.10'/>" --live --config

Since parsing human-readable output from CLI commands that are just wrappers for an API is evil, I also wrote <https://github.com/otherwiseguy/virt-add-static-dhcp> to quickly do this part using the libvirt python bindings.

### Add the eth1 network script

Add a second network adapter using Virtual Machine Manager for the script to bind to.

View -> Console Virtual Machine -> Run

Add a startup script for the "data" interface:

    cp /etc/sysconfig/network-scripts/ifcfg-eth{0,1}

Edit /etc/sysconfig/network-scripts/ifcfg-eth1: DEVICE=eth1, delete UUID line, and add PEERDNS=no

    service network restart

Ensure that eth0 and eth1 have addresses and that eth1's address is the static IP we assigned above

At this point, it is also usually a good idea to go ahead and update the packages on the system, since we will be cloning this vm for our other nodes.

    yum -y update

### Create a snapshot for the base install of the new VM

Make a snapshot for rhel-6.4-controller

    sudo virsh snapshot-create-as rhel-6.4-controller base "RHEL 6.4 controller base" --atomic --reuse-external

Power off rhel-6.4-controller

Repeat, cloning rhel-6.4-compute1 (192.168.100.20), rhel-6.4-compute2 (192.168.100.21), rhel-6.4-network (192.168.100.30) VMs from rhel-6.4-controller, running:

    $ sudo virt-sysprep -d rhel-6.4-controller

before each clone.

### Reverting to a snapshot

For example, to revert the controller to the base snapshot:

    sudo virsh snapshot-revert --force rhel-6.4-controller base

<Category:Networking>
