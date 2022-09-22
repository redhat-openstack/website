---
title: Image resources
category: resources
authors: berendt, dneary, jpeeler, kallies, mattdm, pixelbeat, pmyers, rbowen, rdo, snecklifter
---

# Image resources

## Download pre-built images for OpenStack

You can run a number of different Linux distributions and operating systems on top of your RDO cloud. This is a collection of various OpenStack-ready images that you can use:

*   [Fedora cloud images](https://getfedora.org/cloud/download/)
*   [RHEL 9 image](https://access.redhat.com/downloads/content/479/ver=/rhel---9/9.0/x86_64/product-software) (requires RHEL subscription)
*   [RHEL 8 image](https://access.redhat.com/downloads/content/479/ver=/rhel---8/8.6/x86_64/product-software) (requires RHEL subscription)
*   [RHEL 7 image](https://access.redhat.com/downloads/content/69/ver=/rhel---7/7.0/x86_64/product-downloads) (requires RHEL subscription)
*   [CentOS Stream 9 images](https://cloud.centos.org/centos/9-stream/)
*   [CentOS Stream 8 images](https://cloud.centos.org/centos/8-stream/)
*   [CentOS 7 images](http://cloud.centos.org/centos/7/images/)
*   [Ubuntu cloud images](//cloud-images.ubuntu.com/)
*   [Windows Server 2012 test image](http://www.cloudbase.it/ws2012/)
*   [openSUSE cloud images](http://download.opensuse.org/repositories/Cloud:/Images:/)
*   [Debian cloud images](http://cdimage.debian.org/cdimage/openstack/)

### Additional resources

*   The [OpenStack Virtual Machine Image Guide](https://docs.openstack.org/image-guide/obtain-images.html) provides another list of Glance images

## Import images into Glance

You can load an image from the command line with Glance. For example:

    $ curl -O https://mirror.in2p3.fr/pub/fedora/linux/releases/36/Cloud/x86_64/images/Fedora-Cloud-Base-36-1.5.x86_64.qcow2

    $ glance --os-image-api-version 2 image-create --name 'Fedora-36-x86_64' --disk-format qcow2 --container-format bare --file Fedora-Cloud-Base-36-1.5.x86_64.qcow2

Alternatively, go to the **Images** tab in your OpenStack dashboard to add images via the GUI.

See the [OpenStack documentation](http://docs.openstack.org/user-guide/common/cli_manage_images.html) for more details about the Glance command-line tools.

## Build your own images

*   Section [Tool support for image creation](http://docs.openstack.org/image-guide/create-images-automatically.html) in the OpenStack Virtual Machine Image Guide provides a list of tools you can use to build your own images
*   Section [Create images manually](https://docs.openstack.org/image-guide/create-images-manually.html) in the OpenStack Virtual Machine Image Guide contains instructions on how to manually create images based on various operating systems, including CentOS Stream and Fedora

### Import your own images

The resulting image file can be imported into Glance similarly to any other image:

    $ glance image-create --name Fedora-Image-x86_64 --disk-format qcow2 --container-format bare --is-public True < fedora-image.qcow2
