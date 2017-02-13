---
title: RDO blogs, week of Feb 13
author: rbowen
date: 2017-02-13 15:21:35 UTC
tags: rdo,blog,openstack
comments: true
published: true
---

Here's what RDO enthusiasts have been blogging about in the last few weeks. If you blog about RDO, please let me know (rbowen@redhat.com) so I can add you to my list.

**TripleO: Debugging Overcloud Deployment Failure** by bregman

> You run ‘openstack overcloud deploy’ and after a couple of minutes you find out it failed and if that’s not enough, then you open the deployment log just to find a very (very!) long output that doesn’t give you an clue as to why the deployment failed. In the following sections we’ll see how can […]

Read more at [http://tm3.org/dv](http://tm3.org/dv)


**RDO @ DevConf** by Rich Bowen

> It's been a very busy few weeks in the RDO travel schedule, and we wanted to share some photos with you from RDO's booth at DevConf.cz.

Read more at [http://tm3.org/dw](http://tm3.org/dw)


**The surprisingly complicated world of disk image sizes** by Daniel Berrange

> When managing virtual machines one of the key tasks is to understand the utilization of resources being consumed, whether RAM, CPU, network or storage. This post will examine different aspects of managing storage when using file based disk images, as opposed to block storage. When provisioning a virtual machine the tenant user will have an idea of the amount of storage they wish the guest operating system to see for their virtual disks. This is the easy part. It is simply a matter of telling ‘qemu-img’ (or a similar tool) ’40GB’ and it will create a virtual disk image that is visible to the guest OS as a 40GB volume. The virtualization host administrator, however, doesn’t particularly care about what size the guest OS sees. They are instead interested in how much space is (or will be) consumed in the host filesystem storing the image. With this in mind, there are four key figures to consider when managing storage:

Read more at [http://tm3.org/dx](http://tm3.org/dx)


**Project Leader** by rbowen

> I was recently asked to write something about the project that I work on – RDO – and one of the questions that was asked was:

Read more at [http://tm3.org/dy](http://tm3.org/dy)


**os_type property for Windows images on KVM** by Tim Bell

> The OpenStack images have a long list of properties which can set to describe the image meta data. The full list is described in the documentation. This blog reviews some of these settings for Windows guests running on KVM, in particular for Windows 7 and Windows 2008R2.

Read more at [http://tm3.org/dz](http://tm3.org/dz)


**Commenting out XML snippets in libvirt guest config by stashing it as metadata** by Daniel Berrange

> Libvirt uses XML as the format for configuring objects it manages, including virtual machines. Sometimes when debugging / developing it is desirable to comment out sections of the virtual machine configuration to test some idea. For example, one might want to temporarily remove a secondary disk. It is not always desirable to just delete the configuration entirely, as it may need to be re-added immediately after. XML has support for comments <!-- .... some text --> which one might try to use to achieve this. Using comments in XML fed into libvirt, however, will result in an unwelcome suprise – the commented out text is thrown into /dev/null by libvirt.

Read more at [http://tm3.org/d-](http://tm3.org/d-)


**Videos from the CentOS Dojo, Brussels, 2017** by Rich Bowen

> Last Friday in Brussels, CentOS enthusiasts gathered for the annual CentOS Dojo, right before FOSDEM.

Read more at [http://tm3.org/dp](http://tm3.org/dp)


**FOSDEM Day 0 - CentOS Dojo** by Rich Bowen

> FOSDEM starts tomorrow in Brussels, but there's always a number of events the day before.

Read more at [http://tm3.org/dq](http://tm3.org/dq)


**Gnocchi 3.1 unleashed** by Julien Danjou

> It's always difficult to know when to release, and we really wanted to do it  earlier. But it seems that each week more awesome work was being done  in Gnocchi, so we kept delaying it while having no  pressure to push it out.

Read more at [http://tm3.org/dr](http://tm3.org/dr)


**Testing RDO with Tempest: new features in Ocata** by ltoscano

> The release of Ocata, with its shorter release cycle, is close and  it is time to start a broader testing (even if one could argue that  it is always time for testing!).

Read more at [http://tm3.org/ds](http://tm3.org/ds)


**Barely Functional Keystone Deployment with Docker** by Adam Young

> My eventual goal is to deploy Keystone using Kubernetes.  However, I want to understand things from the lowest level on up.  Since Kubernetes will be driving Docker for my deployment, I wanted to get things working for a single node Docker deployment before I move on to Kubernetes.    As such, you’ll notice I took a few short cuts.  Mostly, these involve configuration changes.  Since I will need to use Kubernetes for deployment and configuration, I’ll postpone doing it right until I get to that layer.  With that caveat, let’s begin.  

Read more at [http://tm3.org/dt](http://tm3.org/dt)