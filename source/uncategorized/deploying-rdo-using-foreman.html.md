---
title: Deploying RDO using Foreman
authors: cbrown ocf, cwolfe, dneary, jayg, jistr, matty dubs, merdoc, ohochman, rbowen,
  rob, rperryman, vaneldik
wiki_title: Deploying RDO using Foreman
wiki_revision_count: 47
wiki_last_updated: 2015-07-16
---

# Deploying RDO using Foreman

__NOTOC__

__TOC__

## Foreman with RDO

This guide is meant to help you set up [Foreman](http://theforeman.org/) to deploy RDO. We have wrapped this up in an installer with some predefined Foreman Host Groups to get you started. You can, of course, add your own to do thing we havenot yet added. If you do, please feel free to contribute them to our upstream [installer](https://github.com/redhat-openstack/astapor) project!

### Deploying on VMs

Before using Foreman to deploy OpenStack on your bare metal machines, you might want to do a test drive using virtual machines. You can use vftool to set up the machines, or you can do it manually. For a real deployment, of course, you will want to use multiple bare metal servers. If you are using bare metal servers, you may skip this section.

#### Using vftool

[vftool](https://github.com/cwolferh/vms-and-foreman/) is a tool to build and configure multiple VMs. We will be using it in this example to allow you to test this process within virtual machines on a single physical host.

Vftool is completely optional, with the purpose of making it a bit easier to set up and get a base configuration for a set of VMs to test with a multi-machine OpenStack setup, using Foreman. IOW, this is for PoC/disposable setups just to try things out. Anything done in/with this tool can also be done manually using your virtualization commands of choice/preference. If you choose to use this tool, first, clone it from:

<https://github.com/cwolferh/vms-and-foreman/>

##### RHEL/RHOS install/setup with vftool

create a .rhel_vftoolrc with:

    export INITIMAGE=rhel64init
    export VMSET='set1fore1 set1client1 set1client2'
    export INSTALLURL=http://your-mirror/released/RHEL-6/6.4/Server/x86_64/os

Then, source this file (`source .rhel_vftoolrc`).

INITIMAGE defines the name of the base image. VMSET is a space-delimited list of virtual machine names; we will, below, use 'set1fore1' as the Foreman server, and 'set1client1' and 'set1client2' as clients managed by Foreman. INSTALLURL should point to your OS install tree.

Then, follow the directions in [the vftool README](https://github.com/cwolferh/vms-and-foreman/) through the end of the first set of example commands, with one exception. When you reach the step '$ bash -x vftool.bash create_images', it may be helpful to do a little additional base configuration on your init image before creating the test VMs. For instance, assuming RHEL, you may wish to register with subscription-manager (or RHN) and attach to the appropriate pools, or any other steps you will take on each instance. Also complete the "Repo setup" step below.

#### Manual setup without vftool

You can also set up your VM playground manually. You'll need a set of VMs (3 for Nova Network setup, 4 for Neutron setup) linked together with at least two networks.

##### Networking

In virt-manager, under Edit -> Connection Details -> Virtual Networks create two new virtual networks, you can name them "openstack-private" and "openstack-public". Don't enable DHCP on the new networks.

Create new VMs and give them network interfaces to those networks. Assign IPs manually on those network interfaces. You can save time by creating just one VM, then cloning it and editing network settings on the clones.

For altering network interface setup on RHEL 6 / CentOS 6, look into `/etc/sysconfig/network-interfaces/ifcfg-eth*` and into `/etc/udev/rules.d/70-persistent-net.rules`.

Make sure that interfaces to a particular network are named the same on all VMs. (E.g. `eth0` for private network and `eth1` for public network.)

Eventually you should have a VM setup similar to this:

    Foreman VM
    eth0: 192.168.200.20 (on openstack-private network)
    eth1: 192.168.201.20 (on openstack-public network)

    Controller VM
    eth0: 192.168.200.10
    eth1: 192.168.201.10

    Compute VM
    eth0: 192.168.200.11
    eth1: 192.168.201.11

    Neutron VM (if you want the Neutron setup)
    eth0: 192.168.200.12
    eth1: 192.168.201.12

##### Hostname and FQDN

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

### Initial setup

#### Repo setup

For RHEL systems, make sure you are registered to both rhel-6-server-rpms and the Optional channel:

    yum-config-manager --enable rhel-6-server-rpms
    yum-config-manager --enable rhel-6-server-optional-rpms

For all systems, you will also want the following two repositories:

    yum install http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
    yum install http://repos.fedorapeople.org/repos/openstack/openstack-havana/rdo-release-havana-6.noarch.rpm

These steps should be run on each system.

At this point, you will be ready to start installing your Foreman and OpenStack deployment.

### Foreman Non-Provisioning setup

Foreman supports *provisioning mode*, where nodes boot from a PXE server controlled by Foreman, and *non-provisioning mode*, which works with existing nodes. Because provisioning mode has not been tested in this usage, we'll focus on non-provisioning mode here.

#### Configure the Foreman server

First, let's configure the machine that will be our Foreman server. If you are using vftool, this is "set1fore1".

vftool users may want to take a snapshot before continuing in case they want to revert later. This can be done by running `SNAPNAME=beforeforeman_server bash -x vftool.bash reboot_snap_take set1fore1`

Begin by installing openstack-foreman-installer:

    yum install openstack-foreman-installer

##### Configuration

If using vftool, the following would be an example environment file for non-provisioning mode. You may set this directly from the command line, or save it in a file and source it:

    export PRIVATE_CONTROLLER_IP=192.168.200.10
    export PRIVATE_INTERFACE=eth1
    export PRIVATE_NETMASK=192.168.200.0/24
    export PUBLIC_CONTROLLER_IP=192.168.201.10
    export PUBLIC_INTERFACE=eth2
    export PUBLIC_NETMASK=192.168.201.0/24
    export FOREMAN_GATEWAY=false
    export FOREMAN_PROVISIONING=false 

If you are not using vftool, you can customize the above to match your actual network setup.

Check that `hostname --fqdn` returns an actual FQDN (i.e., it includes one or more dots, not just a hostname), and that `facter fqdn` is not blank. If it does not, edit /etc/resolv.conf to append `domain example.com`.

If using vftool, use set1fore1 as the foreman server. Use the networks `openstackvms1_1` and `openstackvms1_2` as the OpenStack networks, i.e. eth1 and eth2 on the OpenStack VMs (set1client1 and set1client2). All three VMs can communicate over the default network.

This network configuration can either by done manually, or with a couple example scripts to be run on your clients. As a concrete example, we will assume you wish to make client1 the Controller node, and client2 the Compute node. If you wish to run the following as scripts (pre-requisite would be to `yum install augeas` on each client), they would be as follows:

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

##### Run it!

    cd /usr/share/openstack-foreman-installer/bin/

initialize the environment settings described in the example above for non-provisioning mode.

    (sudo, if you are not root) bash -x foreman_server.sh

After a moment, this will leave you with a working Foreman install. Further details are below in 'Finishing the setup', but first, go ahead and configure the clients:

#### Steps for controller/compute nodes

You will want to run `foreman_client.sh` on each client.

This is located in `/tmp` on the Foreman server. If you are using vftool, an NFS mount will exist at `/mnt/vm-share`, so you can simply:

    mv /tmp/foreman_client.sh /mnt/vm-share/

to make it available to all your machines. If you're not using vftool, you'll want to copy this to each machine.

Once it's in place, go ahead and run it on each machine:

    bash -x /mnt/vm-share/foreman_client.sh

If there is an error that the client did not get a signed certificate back from the puppet server, check on your Foreman server with:

    puppet cert list

And, if needed, puppet cert sign <client_fqdn>

You may receive this error during the installation:

    Error: Could not retrieve catalog from remote server: Error 400 on SERVER: Failed when searching for
    node set1client1: Failed to find set1client1  via exec: Execution of '/etc/puppet/node.rb set1client1'
    returned 1: --- false
    Warning: Not using cache on failed catalog
    Error: Could not retrieve catalog; skipping run

This is non-fatal and can be safely ignored.

### Finishing the setup

Assuming everything has been successful up to this point, now you just have a bit of configuration in the Foreman UI to configure the nodes you have registered with the desired host groups (Controller and Compute for now).

First, log in to your Foreman instance (https://{foreman_fqdn}). The default login and password are admin/changeme; we recommend changingthis if you plan on keeping this host around.

Next, you’ll need to assign the correct puppet classes to each of your hosts. Click the 'Hosts' link and select your host from the list. Select 'Change Group' in the dropdown menu above the host list, select the appropriate Host Group, and Click 'submit'. When applying host groups, you can override any values (such as service passwords) in the Foreman UI. This can either be done on a per-host basis (by clicking the host link, and then clicking the 'edit host' button'), or at the Host Group level, which will affect all hosts assigned to that hostgroup. To have the change pick up immediately, run puppet on the host (client1 and client2 in our examples) in question (or just wait for the next puppet run, which defaults to every 30 minutes):

    puppet agent -tv

It is recommended that you provision the controller before the compute node, as the compute node has dependencies on the controller.

Repeat for all of your nodes. Both Controller and Compute nodes take quite a while to setup. After about <some number of> minutes on each host, you will have a working OpenStack installation! Add more Compute nodes at any time with Foreman.

#### Optional Heat APIs

By default, the controller nodes will install without CloudFormations and CloudWatch APIs enabled. To enable one or both of them:

*   In Foreman UI navigate to More -> Configuration -> Host Groups and click on the Controller host group (Neutron Controller or Nova Network Controller, depending on which one you use).

<!-- -->

*   Switch to the Parameters tab.

<!-- -->

*   Click the Override button next to `heat_cfn` and/or `heat_cloudwatch` variables.

<!-- -->

*   Change the value(s) "false" to "true" (you might need to scroll down if you don't see the form right away) and submit the form.

When Puppet runs on the controller node, it will install the optional APIs you enabled.

#### Running Nova instances when compute node is a VM

For running Nova instances inside a VM, you'll either need to set up nested virtualization, or make Nova use QEMU instead of KVM.

To use QEMU in Nova, set `libvirt_type=qemu` in `/etc/nova/nova.conf` on the compute node. Then run `service openstack-nova-compute restart`.

### Usage notes for vftool

To revert a given host to a previous snapshot you can use: SNAPNAME=$mysnap bash -x vftool.bash reboot_snap_revert set2fore1

### Troubleshooting with foreman/puppet

*   If you have mod_nss installed, foreman-proxy will not start, as they both attempt to use port 8443. This is something we will try to address in the near future, but in the meantime, you can easily edit your httpd conf file for either of these modules to get around this issue.
*   foreman-proxy restart is needed if you change certificates, or change Puppet versions (as it's loaded), or its settings file
*   httpd restart emcompasses both the puppetmaster and Foreman as they run inside with passenger, so it's a quick way to restart both.
*   Restart after changing certs (mod_ssl configuration), upgrading Puppet, changing Foreman's settings file and sometimes editing puppet.conf (especially if modifying environments).
*   you can restart just Foreman by touching ~foreman/tmp/restart.txt, or just 'service foreman restart'

For clients with puppet 2.6, you need to add to /etc/puppet/puppet.conf "report = true", and then 'puppet agent -tv' to get it to check in with foreman. Since we are using the puppet from puppetlabs (ie, 3,2,x), this is unlikely to be a problem if you are following the above directions.

### Foreman Provisioning setup with vftool

This is going to work largely the same as the non-provisioning mode, with the exception of changing the environment file we used earlier to configure the setup script a bit. For instance, you would enable the foreman gateway and set provisioning to true, as well as configure the appropriate eth\* devices on the foreman server to allow it to provision.

The Foreman server should have eth0 and eth1 (foreman1) up. The clients are going to pxeboot off of foreman1 Those clients are not going to have an OS on them. foreman will actually do the provisioning The foreman server is on the default network and the foreman provisioning network. the clients are *not* on the default network, but just their eth0 is going to be the foreman provisioning network (eg foreman1) and eth1 and eth2 on the openstack networks vftool creates 3 sets of networks (3 networks in each set) just for convenience. so if you have vm's working on the networks `foreman1`, `openstackvms1_1`, `openstack1_2` and you wanted to try out something new without screwing those up, you could bring up more test vm's on a different "set" of networks e.g., `foreman2`, `openstackvms2_1`, `openstack2_2`.

### Using other types of Hostgroups

This describes (and still needs more detail) a setup of hostgroups including a Controller, Compute, and Networker nodes, using Neutron. At the current time, these hostgroups are pushed to master of the astapor project in github, and should go into the next rpm release sometime during September. Thanks to gdubreuil for the initial work on this and beginning docs below .

#### Neutron with Networker Node

##### Notes

*   This is for GRE Tunnel only (for now)
*   Minimum 3 hosts - 4 are needed for full validation (VMs communication across compute hosts)

##### Prerequisites

*   rhel6.4+ core build
*   rhel + rhel optional + rdo havana + epel6 + puppetlabs repos
*   2 x physical networks: 1 private, 1 public. (Assuming consistent network interface name across hosts.)
*   1 x Controller
*   1 x Networker
    -   Network node needs to have br-ex setup:
        -   scp /usr/share/openstack-foreman-installer/bin/bridge-create.sh from Foreman node to Network node and run these commands on the Network node:
        -   \`yum install openvswitch\`
        -   \`service openvswitch start\`
        -   \`bridge-create.sh br-ex eth0\` (assuming eth0 is your public interface)
*   N x Computer(s)

##### Setup

Set quickstack/params.pp values (directly or though foreman globals/hostgroups/smart variables).

Assign hosts to their respective target Quickstack Puppet module classes (hostgroups): Controller -> neutron_controller.pp Networker -> neutron_network.pp Computer -> neutron_compute.pp

#### Cinder Storage Nodes

The controller node contains Cinder API and scheduler. For deploying storage capacity nodes there is "OpenStack Block Storage" hostgroup.

The nodes assigned to the "OpenStack Block Storage" hostgroup need to have a `cinder-volumes` LVM volume group before you run puppet on them. This should be considered before you install operating system on the node and you should partition your disk if needed. (LVM volume group needs to be backed by at least one physical volume, which means you'll need to dedicate at least one disk partition to it.) You might use Kickstart to partition the disk and set up the LVM volume group automatically during OS installation.

For more information regarding LVM setup see [LVM Administration Guide](https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html-single/Logical_Volume_Manager_Administration/index.html) and [Kickstart docs](http://fedoraproject.org/wiki/Anaconda/Kickstart).

##### Quick volume group creation for testing

If you just want to give Cinder a quick try, there is a script that sets up a `cinder-volumes` volume group backed by a loop file. This means you will not have to do any special partitioning and the data will be saved in file `/var/lib/cinder/cinder-volumes`. You'll find the script on the node where you installed Foreman at `/usr/share/openstack-foreman-installer/bin/cinder-testing-volume.sh`. Steps to use the script:

1. SCP `cinder-testing-volume.sh` script from the Foreman node to nodes that you want to use for block storage.

2. Run `bash cinder-testing-volume.sh 5G` on the storage nodes. The parameter is the desired size of loop file to be created (5 gigabytes in the example).

Note that `cinder-testing-volume.sh` script is meant for testing only, and the volume group will not persist between reboots. In production environment Cinder storage should be always backed by disks or disk partitions, not by loop files.
