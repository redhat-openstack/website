---
title: Image resources
category: resources
authors: berendt, dneary, jpeeler, kallies, mattdm, pixelbeat, pmyers, rbowen, rdo, snecklifter
wiki_category: Resources
wiki_title: Image resources
wiki_revision_count: 29
wiki_last_updated: 2016-01-07
---

# Image resources

## Downloading Pre-Built Images for OpenStack

This is a collection of various OpenStack-ready images of different distributions and operating systems.

*   Fedora [cloud images](https://getfedora.org/cloud/download/)
*   [CentOS 7 images](http://cloud.centos.org/centos/7/images/)
*   [CentOS 6 images](http://cloud.centos.org/centos/6/images/)
*   [Ubuntu cloud images](//cloud-images.ubuntu.com/)
*   [RHEL 7 image](https://access.redhat.com/downloads/content/69/ver=/rhel---7/7.0/x86_64/product-downloads) (Requires RHEL subscription)
*   [RHEL 6 image](https://rhn.redhat.com/rhn/software/channel/downloads/Download.do?cid=16952) (Requires RHEL subscription)
*   [Windows Server 2012 test image](http://www.cloudbase.it/ws2012/)
*   [openSUSE cloud images](http://download.opensuse.org/repositories/Cloud:/Images:/)
*   [Debian cloud images](http://cdimage.debian.org/cdimage/openstack/)
*   See also [the oz-image-build list on Github](https://github.com/rackerjoe/oz-image-build)
*   The [OpenStack Community App Catalog](https://apps.openstack.org/#tab=glance-images) includes lots of OpenStack-ready Glance images

## Importing Images into Glance

You can load an image from the command line with glance, e.g.,:

    $ wget https://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/fedora/linux/releases/23/Cloud/x86_64/Images/Fedora-Cloud-Base-23-20151030.x86_64.qcow2
    $ glance --os-image-api-version 2 image-create --name 'Fedora-23-x86_64' --disk-format qcow2 --container-format bare --file Fedora-Cloud-Base-23-20151030.x86_64.qcow2 

or go to the 'Images and Snapshots' tab in your OpenStack dashboard to add images via the GUI.

See the [glance documentation](http://docs.openstack.org/trunk/openstack-compute/admin/content/adding-images.html) for more details about the glance command line tools.

## Building Your Own Images

*   Upstream has good guidance on various methods for doing this [here](http://docs.openstack.org/image-guide/create-images-automatically.html)
*   Also see [Creating custom images for OpenStack](Creating CentOS and Fedora images ready for Openstack)
*   [Building a Windows Image for OpenStack](http://poolsidemenace.wordpress.com/2011/06/16/porting-windows-to-openstack/)

Note: using the vm element as shown above is currently required for EPEL. Otherwise, one may instead not specify the vm element and extract the kernel and ramdisk as documented [here](https://wiki.openstack.org/wiki/Baremetal#Image_Requirements).

The resulting image file can be imported into glance similar to any other image:

    $ glance image-create --name F20-x86_64 --disk-format qcow2 --container-format bare --is-public True < fedora-image.qcow2

<Category:Resources> <Category:Documentation>
