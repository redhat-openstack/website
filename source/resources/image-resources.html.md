---
title: Image resources
category: resources
authors: berendt, dneary, jpeeler, kallies, mattdm, pixelbeat, pmyers, rbowen, rdo
wiki_category: Resources
wiki_title: Image resources
wiki_revision_count: 29
wiki_last_updated: 2015-07-22
---

# Image resources

## Downloading Pre-Built Images for OpenStack

This is a collection of various OpenStack-ready images of different distributions and operating systems.

*   Fedora 22 [cloud images](https://getfedora.org/cloud/download/)
*   Fedora 20: [32-bit](http://cloud.fedoraproject.org/fedora-20.i386.qcow2) / [64 bit](http://cloud.fedoraproject.org/fedora-20.x86_64.qcow2) ([*more info*](http://cloud.fedoraproject.org/))
*   Fedora 19: [32-bit](http://archive.fedoraproject.org/pub/archive/fedora/linux/releases/19/Images/i386/Fedora-i386-19-20130627-sda.qcow2) / [64 bit](http://archive.fedoraproject.org/pub/archive/fedora/linux/releases/19/Images/x86_64/Fedora-x86_64-19-20130627-sda.qcow2) ([*more info*](http://cloud.fedoraproject.org/)) **Outdated:** already in archive
*   [CentOS 7 images](http://cloud.centos.org/centos/7/images/)
*   [CentOS 6 images](http://cloud.centos.org/centos/6/images/)
*   [Ubuntu cloud images](//cloud-images.ubuntu.com/)
*   [RHEL 7 image](https://access.redhat.com/downloads/content/69/ver=/rhel---7/7.0/x86_64/product-downloads) (Requires RHEL subscription)
*   [RHEL 6 image](https://rhn.redhat.com/rhn/software/channel/downloads/Download.do?cid=16952) (Requires RHEL subscription)
*   [Windows Server 2012 test image](http://www.cloudbase.it/ws2012/)
*   See also [the oz-image-build list on Github](https://github.com/rackerjoe/oz-image-build)

## Importing Images into Glance

You can load an image from the command line with glance, eg:

      glance image-create --name 'Fedora 20 x86_64' --disk-format qcow2 --container-format bare --is-public true \
`--copy-from `[`http://cloud.fedoraproject.org/fedora-20.x86_64.qcow2`](http://cloud.fedoraproject.org/fedora-20.x86_64.qcow2)

... or go to the 'Images and Snapshots' tab in your OpenStack dashboard to add them via the gui.

See the [glance documentation](http://docs.openstack.org/trunk/openstack-compute/admin/content/adding-images.html) for more details about the glance command line tools.

## Building Your Own Images

*   Information on building an image via Oz for OpenStack (RHOS and RDO) is available in the [RHOS 3.0 Installation and Configuration Guide](https://access.redhat.com/site/documentation/en-US/Red_Hat_OpenStack/3/html/Installation_and_Configuration_Guide/Building_a_Custom_Disk_Image.html).
*   [Building a Windows Image for OpenStack](http://poolsidemenace.wordpress.com/2011/06/16/porting-windows-to-openstack/)

Alternatively, one can use diskimage-builder, which is available in the RDO repository:

    $ yum install diskimage-builder
    $ disk-image-create -a amd64 fedora vm -o fedora-image.qcow2

Note: using the vm element as shown above is currently required for EPEL. Otherwise, one may instead not specify the vm element and extract the kernel and ramdisk as documented here: <https://wiki.openstack.org/wiki/Baremetal#Image_Requirements>

The resulting image file can be imported into glance similar to any other image:

    $ glance image-create --name F20-x86_64 --disk-format qcow2 --container-format bare --is-public True < fedora-image.qcow2

<Category:Resources> <Category:Documentation>
