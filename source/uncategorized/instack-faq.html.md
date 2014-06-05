---
title: Instack FAQ
authors: bcrochet, bnemec, ccrouch, rbowen, rbrady, rlandy, slagle, sradvan
wiki_title: Instack FAQ
wiki_revision_count: 62
wiki_last_updated: 2015-02-13
---

# Instack FAQ

[ ← Deploying RDO using Instack](Deploying RDO using Instack)

This page includes tips, fixes and debugging steps for Instack installs:

## I got a "disk is in use" error when deploying the Overcloud

If the undercloud machine was installed using LVM, when deploying overcloud nodes, you may see an error related to the disk being "in use". The workaround for this error is to:

    # Modify /etc/lvm/lvm.conf to set use_lvmetad to be 0
    vi /etc/lvm/lvm.conf
    use_lvmetad=0
    # Disable and stop relevant services
    systemctl stop lvm2-lvmetad
    systemctl stop lvm2-lvmetad.socket
    systemctl disable lvm2-lvmetad.socket
    systemctl stop lvm2-lvmetad

## Are there any example rc files for Overcloud deployment?

Example rc files to source before deploying the overcloud are included as part of the instack-undercloud package. Descriptions of the variables are below

Example deploy-overcloudrc file for deploying the overcloud on a virtual machine setup:

    /usr/share/doc/instack-undercloud/deploy-virt-overcloudrc

Example deploy-overcloudrc file for deploying the overcloud on a bare metal machine setup:

    /usr/share/doc/instack-undercloud/deploy-baremetal-overcloudrc

Descriptions of the variables in the rc files

*   CPU: number of cpus on baremetal nodes
*   MEM: amount of ram on baremetal nodes, in MB
*   DISK: amount of disk on baremetal nodes, in GB
*   ARCH: architecture of baremetal nodes, amd64 or i386
*   MACS: list of MAC addresses of baremetal nodes
*   PM_IPS: list of Power Management IP addresses
*   PM_USERS: list of Power Management Users
*   PM_PASSWORDS: list of Power Management Passwords
*   NeutronPublicInterface: Overcloud management interface name
*   OVERCLOUD_LIBVIRT_TYPE: Overcloud libvirt type: qemu or kvm
*   NETWORK_CIDR: neutron network cidr
*   FLOATING_IP_START: floating ip allocation start
*   FLOATING_IP_END: floating ip allocation end
*   FLOATING_IP_CIDR: floating ip network cidr
*   COMPUTESCALE: # of overcloud compute nodes
*   BLOCKSTORAGESCALE: # of overcloud block storage nodes
*   SWIFTSTORAGESCALE: # of overcloud object storage nodes

## How do I delete the Overcloud?

There are delete scripts included with the instack-undercloud package If you want to delete an overcloud and reset the environment to a state where you can deploy another overcloud. Then follow these steps:

1. While logged into the undercloud node export the required variables into your shell:

      command $(sudo cat /root/stackrc | xargs)

2. Run one of the following examples that matches how you deployed the overcloud.

       #heat
       ./instack-delete-overcloud

       #tuskar
       ./instack-delete-overcloud-tuskarcli

Once the command has completed successfully you are now ready to run instack-prepare-for-overcloud again.

## How do I view the Undercloud Dashboard when using a remote virt host?

If you're virt host is a remote system, and not the same system that you're running your web browser from, you can create an ssh tunnel from the virt host to the instack virtual machine for connectivity. On the virt host enter the following:

       sudo iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
      `  ssh -g -N -L 8080:192.168.122.55:80 `hostname` `

where 192.168.122.55 is the IP address of the instack virtual machine. Update appropriately for your environment. With the ssh tunnel created you can launch a browser on a system with connectivity to the virt host and go to <http://><virt-host>:8080/dashboard and the dashboard should appear. If you need to connect remotely through the virt host, you can chain ssh tunnels as needed.

When logging into the dashboard the default user and password are found in the /root/stackrc file on the instack virtual machine, OS_USERNAME and OS_PASSWORD. You can read more about using the dashboard in the User Guide.
