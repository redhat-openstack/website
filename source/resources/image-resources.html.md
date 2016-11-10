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

## Download pre-built images for OpenStack

You can run a number of different Linux distributions and operating systems on top of your RDO cloud. This is a collection of various OpenStack-ready images that you can use:

*   Fedora [cloud images](https://getfedora.org/cloud/download/)
*   [RHEL 7 image](https://access.redhat.com/downloads/content/69/ver=/rhel---7/7.0/x86_64/product-downloads) (requires RHEL subscription)
*   [RHEL 6 image](https://access.redhat.com/downloads/content/69/ver=/rhel---6/6.0/x86_64/product-software) (requires RHEL subscription)
*   [CentOS 7 images](http://cloud.centos.org/centos/7/images/)
*   [CentOS 6 images](http://cloud.centos.org/centos/6/images/)
*   [Ubuntu cloud images](//cloud-images.ubuntu.com/)
*   [Windows Server 2012 test image](http://www.cloudbase.it/ws2012/)
*   [openSUSE cloud images](http://download.opensuse.org/repositories/Cloud:/Images:/)
*   [Debian cloud images](http://cdimage.debian.org/cdimage/openstack/)
*   The [OpenStack Community App Catalog](https://apps.openstack.org/#tab=glance-images) contains a large number of OpenStack-ready Glance images

## Import images into Glance

You can load an image from the command line with Glance. For example:

    $ curl -O https://download.fedoraproject.org/pub/fedora/linux/releases/24/CloudImages/x86_64/images/Fedora-Cloud-Base-24-1.2.x86_64.qcow2

    $ glance --os-image-api-version 2 image-create --name 'Fedora-24-x86_64' --disk-format qcow2 --container-format bare --file Fedora-Cloud-Base-24-1.2.x86_64.qcow2

Alternatively, go to the **Images** tab in your OpenStack dashboard to add images via the GUI.

See the [OpenStack documentation](http://docs.openstack.org/user-guide/common/cli_manage_images.html) for more details about the Glance command-line tools.

## Build your own images

*   The OpenStack documentation has good guidance on various methods for building your own images: [http://docs.openstack.org/image-guide/create-images-automatically.html](http://docs.openstack.org/image-guide/create-images-automatically.html)
*   See also [Creating custom images for OpenStack](/resources/creating-centos-and-fedora-images-ready-for-openstack/)
*   [A blog post on building a Windows image for OpenStack](http://poolsidemenace.wordpress.com/2011/06/16/porting-windows-to-openstack/)

The resulting image file can be imported into Glance similarly to any other image:

    $ glance image-create --name Fedora-24-x86_64 --disk-format qcow2 --container-format bare --is-public True < fedora-image.qcow2
