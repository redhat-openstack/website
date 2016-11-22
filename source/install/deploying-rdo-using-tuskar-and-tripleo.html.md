---
title: Deploying RDO using Tuskar and TripleO
authors: ccrouch, rbowen, slagle, tzumainn
wiki_title: Deploying RDO using Tuskar and TripleO
wiki_revision_count: 25
wiki_last_updated: 2014-09-15
---

# Deploying RDO using Tuskar and TripleO

{:.no_toc}

## **Note: These instructions are outdated. There's a new setup published [here](/install/deploying-rdo-using-instack/) which is designed to be an easier process for trying TripleO.**

## Deploying RDO Using Tuskar and TripleO

The following page describes a process for deploying RDO Havana using the [Tuskar](//wiki.openstack.org/wiki/TripleO/Tuskar) and [TripleO](//wiki.openstack.org/wiki/TripleO) projects.

NOTE: This install process is **NOT** suitable for production deployment, in fact it has **only** been tested as part of a demonstration for the OpenStack Icehouse summit in Hong Kong. The images used are in **NO** way secure and should only be utilized in a private, local environment where they will not be externally reachable.

## Goal

Deploy a virtualized OpenStack installation consisting of a single OpenStack controller node and single Nova compute node (known as the Overcloud). The instructions walk you through installing first Tuskar and TripleO (known as the Undercloud) then deploying this OpenStack install using the Tuskar UI.

[Here](//goo.gl/R6Ip5N) is a short video showing how to use Tuskar to deploy the Overcloud.

## Files to download

Download these files to the machine which you will use to host the virtual environment.

1.  [deploy-ramdisk.initramfs](//goo.gl/l07AMB)
2.  [deploy-ramdisk.kernel](//goo.gl/86tTQw)
3.  [fedora-cloud.qcow2](//goo.gl/ypXGZO)
4.  [Fedora-Undercloud-Control-2013-10-25-11_34_41.iso](//goo.gl/VmBwkA)
5.  [Fedora-Undercloud-Leaf-2013-10-23-18_40_22.iso](//goo.gl/yebuwc)
6.  [overcloud-compute.qcow2](//goo.gl/OBywFQ)
7.  [overcloud-control.qcow2](//goo.gl/wQ5E7R)
8.  [hash.md5](//ccrouch.fedorapeople.org/hash.md5)

## Instructions

Can be found [here](//github.com/mtaylor/tuskar_install/blob/master/README.md). If you run into issues please reach out on #tuskar on freenode irc.

## Future

The Tuskar and TripleO communities are continually extending the capabilities of the two projects. Over the course of the OpenStack Icehouse release we intend to reduce the complexity of the installation process. If you would like to help contribute please get in touch on #tuskar on freenode irc.

