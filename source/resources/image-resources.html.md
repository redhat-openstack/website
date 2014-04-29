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

*   Fedora 19: [32-bit](http://cloud.fedoraproject.org/fedora-19.i386.qcow2) / [64 bit](http://cloud.fedoraproject.org/fedora-19.x86_64.qcow2) ([*more info*](http://cloud.fedoraproject.org/))
*   Fedora 18: [32-bit](http://mattdm.fedorapeople.org/cloud-images/Fedora18-Cloud-i386-latest.qcow2) / [64-bit](http://mattdm.fedorapeople.org/cloud-images/Fedora18-Cloud-x86_64-latest.qcow2)
*   [CentOS 6.5 images](http://repos.fedorapeople.org/repos/openstack/guest-images/)
*   [Ubuntu cloud images](//cloud-images.ubuntu.com/)
*   [RHEL 7 RC image](ftp://ftp.redhat.com/redhat/rhel/rc/7/GuestImage/)
*   [RHEL 6 image](https://rhn.redhat.com/rhn/software/channel/downloads/Download.do?cid=16952) (Requires RHEL subscription)
*   [Windows Server 2012 test image](http://www.cloudbase.it/ws2012/)
*   See also [the oz-image-build list on Github](https://github.com/rackerjoe/oz-image-build)

## Importing Images into Glance

You can load an image from the command line with glance, eg:

      glance image-create --name 'Fedora 19 x86_64' --disk-format qcow2 --container-format bare --is-public true \
`--copy-from `[`http://cloud.fedoraproject.org/fedora-19.x86_64.qcow2`](http://cloud.fedoraproject.org/fedora-19.x86_64.qcow2)

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

    $ glance image-create --name F19-x86_64 --disk-format qcow2 --container-format bare --is-public True < fedora-image.qcow2

<Category:Resources> <Category:Documentation>
