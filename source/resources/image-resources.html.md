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

This page is a collection of various OpenStack-ready images of different distributions and operating systems.

*   Fedora 19: [32 bit](//download.fedoraproject.org/pub/fedora/linux/releases/19/Images/i386/Fedora-i386-19-20130627-sda.qcow2) [64 bit](//download.fedoraproject.org/pub/fedora/linux/releases/19/Images/x86_64/Fedora-x86_64-19-20130627-sda.qcow2)
*   Fedora 18: [64 bit](//mattdm.fedorapeople.org/cloud-images/Fedora18-Cloud-x86_64-latest.qcow2)
*   CentOS 6.3: [Various cloud ready images](//wiki.centos.org/Cloud/OpenNebula)
*   [Ubuntu cloud images](//cloud-images.ubuntu.com/)
*   [RHEL 6 image](https://rhn.redhat.com/rhn/software/channel/downloads/Download.do?cid=16952) (Requires RHEL subscription)
*   [OpenSuSE 12.1 image](http://susestudio.com/a/YRUrwO/testing-instance-for-openstack-opensuse-121)
*   [Windows Server 2012 test image](http://www.cloudbase.it/ws2012/)

See also [the oz-image-build list on Github](https://github.com/rackerjoe/oz-image-build)

You can load an image from the command line with glance, eg:

\` glance image-create --name "Fedora 19 x86_64" --disk-format qcow2 --container-format bare --is-public true --copy-from <http://cloud.fedoraproject.org/fedora-19.x86_64.qcow2> \`

... or go to the 'Images and Snapshots' tab in your OpenStack dashboard to add them via the gui.

See the [glance documentation](http://docs.openstack.org/trunk/openstack-compute/admin/content/adding-images.html) for more details about the glance command line tools.

<Category:Resources> <Category:Documentation>
