---
title: TripleO VM Setup
authors: ccrouch, jcoufal, slagle
wiki_title: TripleO VM Setup
wiki_revision_count: 12
wiki_last_updated: 2015-05-05
---

# TripleO VM Setup

<h2 style="color: #B40B0C">
**Note:** These instructions are outdated. Please follow [TripleO Quickstart](RDO-Manager) site which replaces this setup.

</h2>
## Background

The steps in this setup are a way of trying out an OpenStack deployment using TripleO. TripleO is the OpenStack Deployment program whose goal is to be able to deploy OpenStack using OpenStack wherever possible. Using baremetal provisioning from Nova, orchestration from Heat, and other OpenStack projects, you can deploy your cloud.

These steps refer to an Undercloud and an Overcloud. The Undercloud is an OpenStack installation that will deploy your Overcloud. The Overcloud is the cloud for end users, whether it be public, private, hybrid, etc.

This setup uses 3 vm's: 1 for your Undercloud, and 2 for your Overcloud (a Control and a Compute node). The Overcloud vm's will be PXE booted, installed, and setup for your OpenStack deployment, just like you were using baremetal.

The vm images are based on the icehouse-2 milestone tarballs from <http://tarballs.openstack.org/> (with 1 or 2 exceptions for some needed bug fixes).

## Prerequisites

1.  These steps have been tested on Fedora 20. However, they're likely to work on Fedora 19.
2.  You need to have git installed and have configured sudo access (with no password) for your user.
3.  You will also need about 6.5 GB of free RAM.

Note that some of the commands below use '\' for bash line continuation to make it easier to read, so if you're copying and pasting, make sure you grab the whole command!

------------------------------------------------------------------------

## Undercloud Setup

1.  Define a location for the tripleo code and images you will need.
        export TRIPLEO_ROOT=~/tripleo
        mkdir -p $TRIPLEO_ROOT
        cd $TRIPLEO_ROOT

2.  Download the undercloud, overcloud, and deploy images. Note that if you choose you can download the images to a directory other than $TRIPLEO_ROOT. However, if you do so, you will need symlinks pointing to each of the images in $TRIPLEO_ROOT.
        # Fedora
        curl -L -O http://fedorapeople.org/~slagle/slagle-tripleo-images-fedora-i2/undercloud.qcow2
        curl -L -O http://fedorapeople.org/~slagle/slagle-tripleo-images-fedora-i2/deploy-ramdisk.initramfs
        curl -L -O http://fedorapeople.org/~slagle/slagle-tripleo-images-fedora-i2/deploy-ramdisk.kernel
        curl -L -O http://fedorapeople.org/~slagle/slagle-tripleo-images-fedora-i2/overcloud-compute.qcow2
        curl -L -O http://fedorapeople.org/~slagle/slagle-tripleo-images-fedora-i2/overcloud-control.qcow2
        curl -L -O http://fedorapeople.org/~slagle/slagle-tripleo-images-fedora-i2/user.qcow2

3.  Clone the repository for tripleo-incubator and add its scripts directory to your $PATH.
        git clone https://github.com/slagle/tripleo-incubator.git
        cd tripleo-incubator
        git checkout undercloud-config-drive
        cd $TRIPLEO_ROOT
        export PATH=$TRIPLEO_ROOT/tripleo-incubator/scripts:$PATH
        write-tripleorc

4.  Run the script to install needed packages and do basic configuration. The script will add your user to the libvirtd group, if not already done. You may need to start a new shell to pick up the new group.
        install-dependencies
        # Make sure your user is in the libvirtd group
        id | grep libvirtd
        # If not, start a new shell to pick up the group, cd to your $TRIPLEO_ROOT directory and run 'source tripleorc'

5.  Run the script to download other needed tools.
        pull-tools

6.  Run the script to setup your network for the vm's.
        export LIBVIRT_DEFAULT_URI=&quot;qemu:///system&quot;
        echo 'export LIBVIRT_DEFAULT_URI=&quot;qemu:///system&quot;' &gt;&gt; ~/.bashrc
        setup-network

7.  Create and start the vm for the Undercloud.
        export UNDERCLOUD_VM_NAME=undercloud
        (virsh pool-list --all --persistent | grep -q default) || \
            (virsh pool-define-as --name default dir --target /var/lib/libvirt/images; \
             virsh pool-autostart default; \
             virsh pool-start default) 
        virsh vol-create-as default $UNDERCLOUD_VM_NAME.qcow2 20G --format qcow2
        virsh vol-upload --pool default $UNDERCLOUD_VM_NAME.qcow2 undercloud.qcow2
        configure-vm \
            --name $UNDERCLOUD_VM_NAME \
            --image /var/lib/libvirt/images/$UNDERCLOUD_VM_NAME.qcow2 \
            --seed \
            --libvirt-nic-driver virtio \
            --arch x86_64 \
            --memory 2097152 \
            --cpus 1 
        export UNDERCLOUD_CONFIG_DRIVE_ISO=$(undercloud-config-drive)
        virsh attach-disk $UNDERCLOUD_VM_NAME \
            $UNDERCLOUD_CONFIG_DRIVE_ISO hda \
            --type cdrom --sourcetype file --persistent
        virsh start $UNDERCLOUD_VM_NAME

8.  Get the Undercloud IP
        export UNDERCLOUD_IP=$(arp -an | grep $(get-vm-mac $UNDERCLOUD_VM_NAME) | sed 's/.*(\(.*\)).*/\1/')

9.  Wait for the Undercloud vm to finish booting and configuring. It will take around 3-5 minutes due to the configuration. Use the following command to check if it's done. You should see output from the command (example shown below).
        ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET fedora@$UNDERCLOUD_IP &quot;sudo journalctl -u os-collect-config | grep 'Completed phase post-configure'&quot;
        # Example output showing success after entering password at the prompt:
        # Dec 03 21:35:21 localhost os-collect-config[1006]: [2013-12-03 21:35:21,624] (os-refresh-config) [INFO] Completed phase post-configure

## Baremetal Setup

1.  Create 2 vm's to use as baremetal nodes.
        cd $TRIPLEO_ROOT
        source tripleorc
        export NODE_CPU=1 NODE_MEM=2048 NODE_DISK=20 NODE_ARCH=amd64
        export LIBVIRT_NIC_DRIVER=virtio
        write-tripleorc -o
        export UNDERCLOUD_MACS=`create-nodes $NODE_CPU $NODE_MEM $NODE_DISK $NODE_ARCH 2`

2.  Perform setup so you can use the OpenStack clients against the Undercloud.
        export UNDERCLOUD_ADMIN_PASSWORD=unset
        source $TRIPLEO_ROOT/tripleo-incubator/cloudprompt
        source $TRIPLEO_ROOT/tripleo-incubator/undercloudrc
        sudo ip route del 192.0.2.0/24 dev virbr0 || true
        sudo ip route add 192.0.2.0/24 dev virbr0 via $UNDERCLOUD_IP

3.  Perform setup of the baremetal nodes with the Undercloud.
        setup-baremetal $NODE_CPU $NODE_MEM $NODE_DISK $NODE_ARCH &quot;$UNDERCLOUD_MACS&quot; undercloud

## Deploying an Overcloud

1.  Load the images into glance.
        load-image overcloud-control.qcow2
        load-image overcloud-compute.qcow2

2.  Add your ssh key to nova.
        user-config

3.  Deploy the Overcloud. The heat stack-create command will return immediately and show CREATE_IN_PROGRESS. You can run 'heat stack-list' to check its status, it should show CREATE_COMPLETE once finished. It will take around 5-10 minutes to complete. If you have access to your vm's consoles via virt-manager or another tool, go ahead and watch the consoles as the vm's are powered on and PXE booted (the 2 Overcloud vm's are called baremetal_0 and baremetal_1).
        setup-overcloud-passwords
        source tripleo-overcloud-passwords
        make -C $TRIPLEO_ROOT/tripleo-heat-templates overcloud.yaml
        heat stack-create -f $TRIPLEO_ROOT/tripleo-heat-templates/overcloud.yaml \
            -P AdminToken=${OVERCLOUD_ADMIN_TOKEN} \
            -P AdminPassword=${OVERCLOUD_ADMIN_PASSWORD} \
            -P CinderPassword=${OVERCLOUD_CINDER_PASSWORD} \
            -P GlancePassword=${OVERCLOUD_GLANCE_PASSWORD} \
            -P HeatPassword=${OVERCLOUD_HEAT_PASSWORD} \
            -P NeutronPassword=${OVERCLOUD_NEUTRON_PASSWORD} \
            -P NovaPassword=${OVERCLOUD_NOVA_PASSWORD} \
            -P NeutronPublicInterface=eth0 \
            -P SwiftPassword=${OVERCLOUD_SWIFT_PASSWORD} \
            -P SwiftHashSuffix=${OVERCLOUD_SWIFT_HASH} \
            -P NovaComputeLibvirtType=qemu \
            overcloud

## Overcloud Steps

Once your Overcloud is up and running, it needs some initial orchestration to set it up. After that, you can deploy vm's on it if you want. Performance will be slow however since instances running on the Overcloud will be using qemu emulation only.

These steps are actually the same as the TripleO upstream process, so instead of reproducing those steps here, head on over to: <http://docs.openstack.org/developer/tripleo-incubator/devtest_overcloud.html>. Pick up with step 10, where you're waiting for the Overcloud to finish deploying.

## Future

In future updates, look to see some of these steps getting replaced with using Tuskar (https://wiki.openstack.org/wiki/TripleO/Tuskar), and a move to Ironic (https://wiki.openstack.org/wiki/Ironic).

Also, expect the vm images to be based off of the RDO icehouse packages in the near future.
