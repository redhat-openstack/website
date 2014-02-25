---
title: Virtualized Foreman dev setup
authors: jayg, oblaut, rbowen
wiki_title: Virtualized Foreman dev setup
wiki_revision_count: 6
wiki_last_updated: 2014-02-25
---

# Virtualized Foreman dev setup

__NOTOC__

__TOC__

## Deploying RDO with Foreman in a Virtualized environment

This guide is meant to help you set up a development/PoC environment to deploy and test RDO via Foreman. You can use vftool to set up the virtual machines, or you can do it manually. For a real deployment, of course, you will want to use multiple bare metal servers. Note there is also an excellent set of directions for setting up VMs [here](NeutronLibvirtMultinodeDevEnvironment), though you will need to add at least a foreman network to that, since it is geared toward a packstack use case.

### Using vftool

[vftool](https://github.com/cwolferh/vms-and-foreman/) is a tool to build and configure multiple VMs. We will be using it in this example to allow you to test this process within virtual machines on a single physical host.

Vftool is completely optional, with the purpose of making it a bit easier to set up and get a base configuration for a set of VMs to test with a multi-machine OpenStack setup, using Foreman. IOW, this is for PoC/disposable setups just to try things out. Anything done in/with this tool can also be done manually using your virtualization commands of choice/preference. If you choose to use this tool, first, clone it:

    git clone git@github.com:cwolferh/vms-and-foreman.git 
    # or, if any issues:
    git clone https://github.com/cwolferh/vms-and-foreman.git

##### RHEL/RHOS install/setup with vftool

create a .rhel_vftoolrc with:

    export INITIMAGE=rhel64init
    export VMSET='set1fore1 set1client1 set1client2'
    export INSTALLURL=http://your-mirror/released/RHEL-6/6.4/Server/x86_64/os

Then, source this file:

    source .rhel_vftoolrc

INITIMAGE defines the name of the base image. VMSET is a space-delimited list of virtual machine names; we will, below, use 'set1fore1' as the Foreman server, and 'set1client1' and 'set1client2' as clients managed by Foreman. INSTALLURL should point to your OS install tree.

Then, follow the directions in [the vftool README](https://github.com/cwolferh/vms-and-foreman/) through the end of the first set of example commands, with one exception. When you reach the step '$ bash -x vftool.bash create_images', it may be helpful to do a little additional base configuration on your init image before creating the test VMs. For instance, assuming RHEL, you may wish to register with subscription-manager (or RHN) and attach to the appropriate pools, or any other steps you will take on each instance. Also complete the [Repo setup](Deploying_RDO_Using_Foreman#Repo_setup) step from the Foreman installation page. Note that we have, at this point, not done aything to make the VM accessible via dns, so the easiest way to make these changes is to put any such changes you want into a small script and locate that in /mnt/vm-share. Then you can apply it with:

    bash-x vftool.bash run '. /mnt/vm-share/<your-script>'

#### Configure the Foreman server

First, let's configure the machine that will be our Foreman server. Using vftool, this is "set1fore1".

vftool users may want to take a snapshot before continuing in case they want to revert later. This can be done by running `SNAPNAME=beforeforeman_server bash -x vftool.bash reboot_snap_take set1fore1`

Begin by installing openstack-foreman-installer:

    yum install openstack-foreman-installer

##### Configuration

The following would be an example environment file for non-provisioning mode, using the networks set up by vftool. You may set this directly from the command line, or save it in a file and source it:

    export FOREMAN_PROVISIONING=false 

Check that `hostname --fqdn` returns an actual FQDN (i.e., it includes one or more dots, not just a hostname), and that `facter fqdn` is not blank. If it does not, follow the steps [below](#Hostname_and_FQDN) to troubleshoot .

Use set1fore1 as the foreman server. Use the networks `openstackvms1_1` and `openstackvms1_2` as the OpenStack networks, i.e. eth1 and eth2 on the OpenStack VMs (set1client1 and set1client2). All three VMs can communicate over the default network.

This network configuration can either be done manually, or with a couple example scripts to be run on your clients. As a concrete example, we will assume you wish to make client1 the Controller node, and client2 the Compute node. If you wish to run the following as scripts (pre-requisite would be to `yum install augeas` on each client), they would be as follows:

set1client1:

    augtool &lt;&lt;EOA
    set /files/etc/sysconfig/network-scripts/ifcfg-eth1/BOOTPROTO none
    set /files/etc/sysconfig/network-scripts/ifcfg-eth1/IPADDR    192.168.200.10
    set /files/etc/sysconfig/network-scripts/ifcfg-eth1/NETMASK   255.255.255.0
    set /files/etc/sysconfig/network-scripts/ifcfg-eth1/NM_CONTROLLED no
    set /files/etc/sysconfig/network-scripts/ifcfg-eth1/ONBOOT    yes
    save
    set /files/etc/sysconfig/network-scripts/ifcfg-eth2/BOOTPROTO none
    set /files/etc/sysconfig/network-scripts/ifcfg-eth2/IPADDR    192.168.201.10
    set /files/etc/sysconfig/network-scripts/ifcfg-eth2/NETMASK   255.255.255.0
    set /files/etc/sysconfig/network-scripts/ifcfg-eth2/NM_CONTROLLED no
    set /files/etc/sysconfig/network-scripts/ifcfg-eth2/ONBOOT    yes
    save
    EOA

    ifup eth1
    ifup eth2

set1client2:

    augtool &lt;&lt;EOA
    set /files/etc/sysconfig/network-scripts/ifcfg-eth1/BOOTPROTO none
    set /files/etc/sysconfig/network-scripts/ifcfg-eth1/IPADDR    192.168.200.11
    set /files/etc/sysconfig/network-scripts/ifcfg-eth1/NETMASK   255.255.255.0
    set /files/etc/sysconfig/network-scripts/ifcfg-eth1/NM_CONTROLLED no
    set /files/etc/sysconfig/network-scripts/ifcfg-eth1/ONBOOT    yes
    save
    set /files/etc/sysconfig/network-scripts/ifcfg-eth2/BOOTPROTO none
    set /files/etc/sysconfig/network-scripts/ifcfg-eth2/IPADDR    192.168.201.11
    set /files/etc/sysconfig/network-scripts/ifcfg-eth2/NETMASK   255.255.255.0
    set /files/etc/sysconfig/network-scripts/ifcfg-eth2/NM_CONTROLLED no
    set /files/etc/sysconfig/network-scripts/ifcfg-eth2/ONBOOT    yes
    save
    EOA

    ifup eth1
    ifup eth2

#### Usage notes for vftool

*   To revert a given host to a previous snapshot you can use:

<!-- -->

    SNAPNAME=$mysnap bash -x vftool.bash reboot_snap_revert <machine name or space-delimited list>

*   vftool creates 3 sets of networks (3 networks in each set) just for convenience. So, if you have vm's working on the networks `foreman1`, `openstackvms1_1`, `openstack1_2` and you wanted to try out something new without affecting those, you could bring up more test vm's on a different "set" of networks e.g., `foreman2`, `openstackvms2_1`, `openstack2_2`.

#### Foreman Provisioning setup with vftool

This is going to work largely the same as the non-provisioning mode, with the exception of changing the environment file we used earlier to configure the setup script a bit. For instance, you would enable the foreman gateway and set provisioning to true, as well as configure the appropriate eth\* devices on the foreman server to allow it to provision.

The Foreman server should have eth0 and eth1 (foreman1) up. The clients are going to pxeboot off of foreman1 Those clients are not going to have an OS on them. foreman will actually do the provisioning. The foreman server is on the default network and the foreman provisioning network. The clients are *not* on the default network, as their eth0 is going to be the foreman provisioning network (eg foreman1) and eth1 and eth2 on the openstack networks.

### Manual setup without vftool

You can also set up your VM playground manually. You'll need a set of VMs (3 for Nova Network setup, 4 for Neutron setup, more for Load Balancer or HA/Mysql) linked together with at least three networks.

#### Networking

In virt-manager, under Edit -> Connection Details -> Virtual Networks create two new virtual networks, you can name them "openstack-private" and "openstack-public". Don't enable DHCP on the new networks.

Create new VMs and give them network interfaces to those networks, as well as the default libvirt network. Assign IPs manually on those network interfaces. You can save time by creating just one VM, then cloning it and editing network settings on the clones.

For altering network interface setup on RHEL 6 / CentOS 6, look into `/etc/sysconfig/network-interfaces/ifcfg-eth*` and into `/etc/udev/rules.d/70-persistent-net.rules`.

Make sure that interfaces to a particular network are named the same on all VMs. (E.g. `eth0` for private network and `eth1` for public network.), otherwise, your nodes will not be able to communicate on the networks as expected.

Eventually you should have a VM setup similar to this:

    Foreman VM
    eth0: 192.168.200.20 (on openstack-private network)
    eth1: 192.168.201.20 (on openstack-public network)
    eth2: 192.168.122.100 (on default network)

    Controller VM
    eth0: 192.168.200.10
    eth1: 192.168.201.10
    eth2: 192.168.122.101

    Compute VM
    eth0: 192.168.200.11
    eth1: 192.168.201.11
    eth2: 192.168.122.102

    Neutron VM (if you want the Neutron setup)
    eth0: 192.168.200.12
    eth1: 192.168.201.12
    eth2: 192.168.122.103

Note that the foreman VM doesn't actually need to be on the public and private openstack networks, the above is just a result of doing the base configuration on the original VM that the rest are cloned from.

#### Hostname and FQDN

Each VM should have hostname and FQDN configured, and it should be able to reach other VMs by their FQDNs.

*   Set up hostname on each VM in `/etc/sysconfig/network`. Also run `hostname <new name>` so that the changes take effect immediately.

<!-- -->

*   Put a complete set of FQDN configuration into `/etc/hosts` on each VM. The last item on each line matches respective VM hostnames. This config will be exactly the same on all VMs:

<!-- -->

    192.168.200.20 foreman.example.org foreman
    192.168.200.10 control.example.org control
    192.168.200.11 compute.example.org compute
    192.168.200.12 neutron.example.org neutron

Now `hostname -f` should print a FQDN of the VM and you should be able to `ping` other VMs using their FQDNs.

You have a set of VMs networked together and suitable for deploying OpenStack. Congratulations!

### Compute node configuration when in a VM

*Note: This section needs a bit more detail still, as puppet will currently overwrite nova.conf changes made manually if you have the agent service enabled*

For running Nova instances inside a VM, you'll either need to set up nested virtualization, or make Nova use QEMU instead of KVM.

To use QEMU in Nova, set `libvirt_type=qemu` in `/etc/nova/nova.conf` on the compute node. Then run `service openstack-nova-compute restart`.
