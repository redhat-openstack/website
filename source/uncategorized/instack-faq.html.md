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

The following are example rc files to source before deploying the overcloud.

Example rc file for deploying the overcloud on a virtual machine setup:

    #!/bin/bash
    export CPU=1
    export MEM=2048
    export DISK=30
    export ARCH=amd64
    export NeutronPublicInterface=eth0
    export OVERCLOUD_LIBVIRT_TYPE=qemu
    export NETWORK_CIDR=10.0.0.0/8
    export FLOATING_IP_START=192.0.2.45
    export FLOATING_IP_END=192.0.2.64
    export FLOATING_IP_CIDR=192.0.2.0/24
    export MACS="52:54:00:01:f4:00 52:54:00:01:f4:01 52:54:00:01:f4:02 52:54:00:01:f4:03"
    export COMPUTESCALE=1
    export BLOCKSTORAGESCALE=1
    export SWIFTSTORAGESCALE=1

Example rc file for deploying the overcloud on a bare metal machine setup:

    #!/bin/bash
    export CPU=1
    export MEM=2048
    export DISK=30
    export ARCH=amd64
    export MACS="52:54:00:01:f4:00 52:54:00:01:f4:01 52:54:00:01:f4:02 52:54:00:01:f4:03"
    export PM_IPS="10.10.0.01 10.10.0.02 10.10.0.03 10.10.0.04"
    export PM_USERS="username username username username"
    export PM_PASSWORDS="password password password password"
    export NeutronPublicInterface=em2
    export OVERCLOUD_LIBVIRT_TYPE=kvm
    export NETWORK_CIDR="10.0.0.0/8"
    export FLOATING_IP_START="172.17.0.45"
    export FLOATING_IP_END="172.17.0.64"
    export FLOATING_IP_CIDR="172.17.0.0/16"
    export COMPUTESCALE=1
    export BLOCKSTORAGESCALE=1
    export SWIFTSTORAGESCALE=1

## How do I delete the Overcloud?

If you want to delete an overcloud and reset the environment to a state where you can deploy another overcloud, download the instack-delete-overcloud\* scripts from the github repository at <https://github.com/agroup/instack-undercloud/tree/master/scripts> . Run one of the following examples that matches how you deployed the overcloud.

       #heat
       instack-delete-overcloud
       #tuskar
       instack-delete-overcloud-tuskarcli

## How do I view the Undercloud Dashboard?

To access Horizon on the undercloud you need to create an ssh tunnel from the virt host to the instack virtual machine e.g.

      `  ssh -g -N -L 8080:192.168.122.55:80 `hostname` `

where 192.168.122.55 is IP address of the instack virtual machine, you will need to update appropriately for your environment. With the ssh tunnel created you can launch a browser on the virt host and go to <http://localhost:8080> and the dashboard should appear. If you need to connect remotely through the virt host, you can chain ssh tunnels as needed. Note: Depending on your virt host configuration, you may need to open up the correct port(s) in iptables.

When logging into the dashboard the default user and password are found in the stackrc file on the instack virtual machine, OS_USERNAME and OS_PASSWORD. You can read more about using the dashboard in the User Guide.
