---
title: Recent RDO blogs, September 29th
author: rbowen
date: 2016-09-26 13:16:09 UTC
tags: blogs,openstack
published: false
comments: true
---

Here's what RDO enthusiasts have been blogging about in the last few weeks.


**Our Cloud in Liberty** by Tim Bell

> The upgrade to Liberty for the CERN cloud was completed at the end of August. Working with the upstream OpenStack, Puppet and RDO communities, this went pretty smoothly without any issues so there is no significant advice to report. We followed the same approach as the past, gradually upgrading component by component.  With the LHC reaching it's highest data rates so far this year (over 10PB recorded to tape during June), the upgrades needed to be done without disturbing the running VMs.Some hypervisors are still on Scientific Linux CERN 6 (Kilo) using Python 2.7 in a software collection but the backwards compatibility has allows the rest of the cloud to migrate while we complete the migration of 5000 VMs from old hardware and SLC6 to new hardware on CentOS 7 in the next few months.

Read more at [http://tm3.org/bc](http://tm3.org/bc)


**Cinder’s Ceph Replication Sneak peek** by geguileo

> Have you been dying to try out the Volume Replication functionality in OpenStack but you didn’t have some enterprise level storage with replication features lying around for you to play with? Then you are in luck!, because thanks to Ceph’s new RBD mirroring functionality and Jon Bernard’s work on Cinder, you can now have the […]

Read more at [http://tm3.org/bd](http://tm3.org/bd)


**Distinct RBAC Policy Rules** by Adam Young

> The ever elusive bug 968696 is still out there, due, in no small part, to the distributed nature of the policy mechanism. One Question I asked myself as I chased this beastie is “how many distinct policy rules do we actually have to implement?” This is an interesting question because, if we can an automated way to answer that question, it can lead to an automated way to transforming the policy rules themselves, and thus getting to a more unified approach to policy.    The set of policy files used in a Tripleo overcloud have around 1400 rules:

Read more at [http://tm3.org/be](http://tm3.org/be)


**Red Hat OpenStack Platform and Tesora Database-as-a-Service Platform: What’s New** by Rob Young, Principal Product Manager, Red Hat

>  As OpenStack users build or migrate more applications and services for private cloud deployment, users are expanding their plans for how these deployments will be serviced by non-core, emerging components. Based on the           April 2016 OpenStack User Survey         (see page 35), Trove is among the top “as a service” non-core components that OpenStack users are deploying or plan to deploy on top of the core components. This comes as no surprise as every application requires a database and Trove provides OpenStack with an integrated Database-as-a-Service option that works smoothly with the core OpenStack services.  

Read more at [http://tm3.org/b6](http://tm3.org/b6)


**Integrating Red Hat Virtualization and Red Hat OpenStack Platform with Neutron Networking** by CaptainKVM

> As applications are designed, redesigned, or even simply thought about at a high level, we frequently think about technical barriers along side business needs. Business needs may dictate that a new architecture move forward, but technical limitations can sometimes counter how far forward – unless there is something to bridge the gap. The new Neutron network integration between Red Hat Virtualization (RHV) and Red Hat OpenStack Platform (RHOSP) provides such a bridge for business and technical solutions.

Read more at [http://tm3.org/b7](http://tm3.org/b7)


**Install your OpenStack Cloud before lunchtime** by Eric D. Schabell

> Figure 1. The inner workings of QuickStart Cloud Installer  What if I told you that you can have your OpenStack Cloud environment setup before you have to stop for lunch?

Read more at [http://tm3.org/b4](http://tm3.org/b4)


**Your Cloud Installed Before Lunch with QuickStart Cloud Installer 1.0** by Eric D. Schabell

> Figure 1. Inside QuickStart Cloud Installer.  What if I told you that you can have your Red Hat Enterprise Linux (RHEL) based Cloud infrastructure, with Red Hat Virtualization, OpenStack, OpenShift and CloudForms all setup before you have to stop for lunch?

Read more at [http://tm3.org/b9](http://tm3.org/b9)


**Red Hat Confirms Over 40+ Accepted Sessions at OpenStack Summit Barcelona** by Jeff Jameson, Sr. Principal Product Marketing Manager

>  This Fall’s 2016 OpenStack Summit in Barcelona, Spain is gearing up to be a fulfilling event. After some challenging issues with the voting system (which prevented direct URLs to each session), the Foundation has posted the final session agenda detailing the entire week’s schedule of events. Once again, I am thrilled to see the voting results of the greater community with Red Hat sharing over 40 sessions of technology overview and deep dive’s around OpenStack services for containers, storage, networking, compute, network functions virtualization (NFV), and much more.   

Read more at [http://tm3.org/ab](http://tm3.org/ab)