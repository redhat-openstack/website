---
title: Deploying RDO using Tuskar and TripleO
authors: ccrouch, rbowen, slagle, tzumainn
wiki_title: Deploying RDO using Tuskar and TripleO
wiki_revision_count: 25
wiki_last_updated: 2014-09-15
---

# Deploying RDO using Tuskar and TripleO

The following page describes a process for deploying RDO Havana using the Tuskar [1](https://github.com/openstack/tuskar/) and TripleO [2](https://wiki.openstack.org/wiki/TripleO) projects.

NOTE: This install process is **NOT** suitable for production deployment, in fact it has **only** been tested as part of a demonstration for the OpenStack Icehouse summit in Hong Kong. The images used are in **NO** way secure and should only be utilized in a private, local environment where they will not be externally reachable.

## Goal

Deploy a virtualized OpenStack installation consisting of a single Controller Node and single Compute Node. The instructions walk you through installing Tuskar and TripleO themselves then deploying this OpenStack install using the Tuskar UI.

## Files to down

deploy-ramdisk.initramfs [3](http://goo.gl/l07AMB) deploy-ramdisk.kernel [4](http://goo.gl/86tTQw) fedora-cloud.qcow2 [5](http://goo.gl/ypXGZO) Fedora-Undercloud-Control-2013-10-25-11_34_41.iso [6](http://goo.gl/VmBwkA) Fedora-Undercloud-Leaf-2013-10-23-18_40_22.iso [7](http://goo.gl/yebuwc) overcloud-compute.qcow2 [8](http://goo.gl/OBywFQ) overcloud-control.qcow2 [9](http://goo.gl/wQ5E7R) hash.md5 [10](http://ccrouch.fedorapeople.org/hash.md5)

## Instructions

Can be found here [11](https://github.com/mtaylor/tuskar_install/blob/master/README.md). If you run into issues please reach out on #tuskar on freenode irc.
