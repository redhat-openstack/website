---
title: RDO blog roundup, May 11, 2015
date: 2015-05-11 15:20:48
author: rbowen
---

Here's what RDO engineers have been writing about over the past week.

If you're writing about RDO, or about OpenStack on CentOS, Fedora or RHEL, and you're not on my list, please let me know!

**Leveraging Linux Platform for Identity Management in Enterprise Web Applications**, by Nathan Kinder

> I gave a presentation this past weekend at Linuxfest Northwest on the topic of using a collection of Apache HTTPD modules and SSSD to provide identity management for web applications.   This is an approach that is currently used by OpenStack, ManageIQ, and Foreman to allow the Apache HTTPD web server to handle all of the authentication and retrieval of user identity data and exposing it to the web applications.

... Read more at http://tm3.org/blog136

**Driving in the Fast Lane – CPU Pinning and NUMA Topology Awareness in OpenStack Compute**, by  Steve Gordon

> The OpenStack Kilo release, extending upon efforts that commenced during the Juno cycle, includes a number of key enhancements aimed at improving guest performance. These enhancements allow OpenStack Compute (Nova) to have greater knowledge of compute host layout and as a result make smarter scheduling and placement decisions when launching instances. Administrators wishing to take advantage of these features can now create customized performance flavors to target specialized workloads including Network Function Virtualization (NFV) and High Performance Computing (HPC).

... read more at http://tm3.org/blog137

**Heat SoftwareConfig resources - primer/overview.** by Steve Hardy

> In this post, I'm going to provide an overview of Heat's Software Configuration resources, as a preface to digging in more detail into the structure of TripleO heat templates, which leverage SoftwareConfig functionality to install and configure the deployed OpenStack cloud.

... Read more at http://tm3.org/blog138

**Extending Tsung to benchmark Swift3**, by  Cyril Roelandt

> Tsung is a multi-protocol distributed load testing tool released under the
GPLv2 license. In this article, we will see how we can create a scenario that
triggers the download of a file from a Swift container using the S3 API. In
fact, we are using Swift3, a compatibility layer that implements the S3 API
on top of OpenStack Swift. To do so, we will have to use some of the advanced
features of Tsung, but people not familiar with either Tsung or Erlang
should still be able to enjoy this article.

... read more at http://tm3.org/blog139

**TripleO Heat templates Part 1 - Roles and Groups**, by Steve Hardy

> This is the start of a series of posts aiming to de-construct the TripleO heat templates, explaining the abstractions that exist,and the heat features which enable them.

... read more at http://tm3.org/blog140

**Setting up an RDO deployment to be Identity V3 Only**, by Adam Young

> The OpenStack Identity API Version 3 provides support for many features that are not available in version 2. Much of the installer code from Devstack, Puppet Modules, and Packstack, all assumes that Keystone is operating with the V2 API. In the interest of hastening the conversion, I set up a deployment that is V3 only. Here is how I did it.

... read more at http://tm3.org/blog142

**Autoscaling with Heat, Ceilometer and Gnocchi**, by  Mehdi Abaakouk

> A while ago, I had made a quick article/demo of how to use Ceilometer instead of the built-in emulated Amazon CloudWatch resources of Heat.

... read more at http://tm3.org/blog143

**What’s Coming in OpenStack Networking for the Kilo Release**, by Nir Yechiel

> OpenStack  Kilo, the 11th release of the open source project, was officially released in April, and now is a good time to review some of the changes we saw in the OpenStack Networking (Neutron) community during this cycle, as well as some of the key new networking features introduced in the project.

... read more at http://tm3.org/blog144




