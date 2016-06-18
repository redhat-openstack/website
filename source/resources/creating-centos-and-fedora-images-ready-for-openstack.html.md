---
title: Creating CentOS and Fedora images ready for Openstack
category: resources
authors: edmv, strider
wiki_category: Resources
wiki_title: Creating CentOS and Fedora images ready for Openstack
wiki_revision_count: 2
wiki_last_updated: 2014-12-09
---

# Creating CentOS and Fedora images ready for Openstack

This is a short summary of steps you can use to successfully build CentOS and Fedora images capable of take advantage of Openstack's elasticity.

In the end, you'll have images that resize the root partition automatically and small enough to serve as base for your instances.

I'm showing two different methods since for CentOS I used [Linux rootfs resize](https://github.com/flegmatik/linux-rootfs-resize.git) and for Fedora I used *cloud-utils-growpart*.

For the steps shown here, be sure you have at least the following requirements already:

*   A Linux host of course (I used Fedora 20 x64 on a dual core machine)
*   libvirt, virt-manager. Get it with:

        yum groupinstall -y @virtualization

*   Libguestfs tools. Get it with:

        yum install -y libguestfs-tools-c

*   A CentOS 6.5 minimal ISO, you can get one from here: [mirror.globo.com/centos/6.5/isos/x86_64](http://mirror.globo.com/centos/6.5/isos/x86_64/)
*   A Text editor if you want to change kickstarts

Special thanks to Allan St. George, Kashyap and the RDO maillist for the tips when I was asking about this topic. :)

# Steps to create a CentOS image

*   Use virt-manager to install CentOS with a small disk (I used one of 10 GB) and do a *minimal* install, make special note of the name as it will be used later, for this guide the name chosen is **centos-6.5**. Also, during installation you need to create only *one* partition for / in *ext4* format (this means, no lvm, no swap, etc.)
    -   Alternatively you could do something like:

            $ qemu-img create -f qcow2 /tmp/centos-6.5-working.qcow2 10G
            $ virt-install --virt-type kvm --name centos-6.5 --ram 1024 \
            --cdrom=/tmp/CentOS-6.5-x86_64-minimal.iso \
            --disk /tmp/centos-6.5-working.qcow2,format=qcow2 \
            --network network=default \
            --graphics vnc,listen=0.0.0.0 --noautoconsole \
            --os-type=linux --os-variant=rhel6

*   After install, reboot the vm and log in as root.
*   Modify /etc/sysconfig/network-scripts/ifcfg-eth0 so it looks like the following (the important bits are: no mac defined and bootproto dhcp):

        TYPE=Ethernet
        DEVICE=eth0
        ONBOOT=yes
        BOOTPROTO=dhcp
        NM_CONTROLLED=no

*   Install the EPEL repository

        $ yum install -y http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

*   Update the system

        $ yum -y distro-sync

*   Install cloud-init packages and git (this one is required to install linux rootfs resize)

        yum install -y cloud-utils cloud-init parted git

*   Install linux rootfs resize

        cd /tmp
        git clone https://github.com/flegmatik/linux-rootfs-resize.git
        cd linux-rootfs-resize
        ./install

*   Edit /etc/cloud/cloud.cfg and under *cloud_init_modules* add:

        - resolv-conf

*   Add the following line to /etc/sysconfig/network (this is to avoid problems accessing the EC2 metadata service)

        NOZEROCONF=yes

*   Poweroff the vm

        $ poweroff

*   Reset and clean the image so it can be reused without issues

        $ virt-sysprep -d centos-6.5

*   Reduce image size by zero-in unused blocks in the virtual disk (Run as root to avoid issues changing selinux context on the final step)

        $ virt-sparsify --compress /tmp/centos-6.5-working.qcow2 centos-6.5-cloud.qcow2

You're done!

The image *centos-6.5-cloud.qcow2* is ready to be uploaded to Openstack.

An extra note though, virt-sparsify by default uses /tmp as temporary directory to make the sparse by creating an overlay temporary file which, depending on the original image, can be quite large, also some systems mount /tmp in tmpfs which mean it'll use your ram. If you don't have enough space you can export the variable TMPDIR pointing to a dir with enough space before runing virt-sparsify, as in:

    $ export TMPDIR="/some/dir/with/enough/space"

# Steps to create a Fedora image

Creating Fedora images is easier since you can take full advantage of automatition tools like [oz-install](https://github.com/clalancette/oz/wiki/oz-install) or [appliance-creator](http://thincrust.net/tooling.html).

For the Fedora image I used appliance-creator and a kickstart (you can find a few on the [cloud-kickstarts git](https://git.fedorahosted.org/cgit/cloud-kickstarts.git)). For this guide I use [fedora-20-cloud](https://git.fedorahosted.org/cgit/cloud-kickstarts.git/tree/generic/fedora-20-cloud.ks) as base.

*   Install appliance-tools

        yum install -y appliance-tools

*   Run appliance-creator with kickstart of your preference. The arguments here are **-c** for config, **-n** for name and **-f** for disk format.

        appliance-creator -c fedora-20-cloud.ks -n f20-cloud_openstack -f qcow2

*   Grab a coffee and wait, since appliance creator works like a netinstall so most of the time spent will be downloading the packages

After it's done, you'll end up with a directory with the same name you use for -n (in my case it's f20-cloud_openstack) in which you'll find a qcow2 image ready to be uploaded to Openstack (f20-cloud_openstack-sda.qcow2) and an xml file which could be used with virsh define to start the image directly in libvirt.

<Category:Resources> <Category:Documentation>
