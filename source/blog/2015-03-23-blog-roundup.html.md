---
title: RDO blog roundup, March 23 2015
date: 2015-03-23 15:47:02
author: rbowen
---

Here's what RDO engineers have been writing about over the past week.

If you're writing about RDO, or about OpenStack on CentOS, Fedora or RHEL, and you're not on my list, please let me know!

**QEMU QCow2 built-in encryption: just say no. Deprecated now, to be deleted soon**, by Daniel Berrange

> A little over 5 years ago now, I wrote about a how libvirt introduced support for QCow2 built-in encryption. The use cases for built-in qcow2 encryption were compelling back then, and remain so today. In particular while LUKS is fine if your disk backend is already a kernel visible block device, it is not a generically usable alternative for QEMU since it requires privileged operation to set it up, would require yet another I/O layer via a loopback or qemu-nbd device, and finally is entirely Linux specific. 

... read more at http://tm3.org/blog111

**Minimal DevStack with OpenStack Neutron networking**, by Kashyap Chamarthy

> This post discusses a way to setup minimal DevStack (OpenStack development environment from git sources) with Neutron networking, in a virtual machine.

... read more at http://tm3.org/blog112

**Custom Cloud Images for OpenStack pt1**, by Captain KVM

> We previously finished our multi-part series on deploying RHEL-OSP with the RHEL-OSP-Installer. In a few weeks, if all goes according to plan I’ll fire up a new series on the next gen installer… In the mean time, I’d like to show you some useful things to do once you’ve got everything up and running. So what’s up first? Well, as the title suggests, we’re going to create some custom images.

... read more at http://tm3.org/blog113

**Co-Engineered Together: OpenStack Platform and Red Hat Enterprise Linux**, by Arthur Berezin

> OpenStack is not a software application that just runs on top of any random Linux. OpenStack is tightly coupled to the operating system it runs on and choosing the right Linux  operating system, as well as an OpenStack platform, is critical to provide a trusted, stable, and fully supported OpenStack environment.

... read more at http://tm3.org/blog114

