---
title: Deploying RDO using Instack
authors: gfidente, jcoufal, rbrady, rlandy, slagle, sradvan
wiki_title: Deploying RDO using Instack
wiki_revision_count: 31
wiki_last_updated: 2015-05-05
---

# Deploying RDO using Instack

<h2 style="color: #B40B0C">
**Note:** These instructions are outdated. Please follow [TripleO Quickstart](/tripleo) site which replaces this setup.

</h2>
[ ← Installation and Configuration](Install)

This tutorial covers how to deploy a [TripleO](https://wiki.openstack.org/wiki/TripleO) [Undercloud](http://docs.openstack.org/developer/tripleo-incubator/devtest_undercloud.html) and [Overcloud](http://docs.openstack.org/developer/tripleo-incubator/devtest_overcloud.html) using RDO and Instack on an all bare metal or an all virtual environment. TripleO is a program aimed at installing, upgrading and operating OpenStack clouds using OpenStack's own cloud facilities as the foundations - building on Nova, Neutron and Heat to automate fleet management at datacenter scale (and scaling down to as few as 2 machines).

## What is Instack?

[Instack](https://github.com/agroup/instack) is a scripted installer for an OpenStack TripleO Undercloud that uses [tripleo-image-elements](https://github.com/openstack/tripleo-image-elements). Using instack, you can quickly build an Undercloud to deploy your Overcloud.

## Preparing for Undercloud Deployment

The following sections describe the steps for preparing for an Undercloud deployment on all bare metal or all virtual machine environments using RDO packages and Instack.

### Baremetal Setup

[ Deploying RDO on a Bare metal Environment using Instack](Deploying RDO on a Baremetal Environment using Instack)

### Virtual Machine Setup

[ Deploying RDO on a Virtual Machine Environment using Instack](Deploying RDO on a Virtual Machine Environment using Instack)

## Deploying an Undercloud

[ Deploying an RDO Undercloud with Instack ](Deploying an RDO Undercloud with Instack)

## Deploying an Overcloud

[ Deploying an RDO Overcloud with Instack ](Deploying an RDO Overcloud with Instack)

## Testing the Overcloud

[ Testing an RDO Overcloud with Instack ](Testing an RDO Overcloud with Instack)

## Instack FAQ

[ Instack FAQ ](Instack FAQ)
