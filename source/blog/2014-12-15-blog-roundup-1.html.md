---
title: Blog roundup, week of December 8th
date: 2014-12-15 16:10:25
author: rbowen
---

Here's what RDO engineers have been writing about in the last week.

If you're writing about RDO, or about OpenStack on CentOS, Fedora or RHEL, and you're not on my list, please let me know!


Three Flavours of Infrastructure Cloud, by Zane Bitter

> A curious notion that seems to be doing the rounds of the OpenStack traps at the moment is the idea that Infrastructure-as-a-Service clouds must by definition be centred around the provisioning of virtual machines. The phrase ‘small, stable core’ keeps popping up in a way that makes it sound like a kind of dog-whistle code for the idea that other kinds of services are a net liability. Some members of the Technical Committee have even got on board and proposed that the development of OpenStack should be reorganised around the layering of services on top of Nova.

... Read more at http://tm3.org/blog72

Isn’t Atomic on OpenStack Ironic, don’t you think?, by Steven Dake

> OpenStack Ironic is a bare metal as a service deployment tool.  Fedora Atomic is a µOS consisting of a very minimal installation of Linux, kernel.org, Kubernetes and Docker.  Kubernetes is an endpoint manager and container scheduler, while Docker is a container manager.  The basic premise of Fedora Atomic using Ironic is to present a lightweight launching mechanism for OpenStack.

... Read more at http://tm3.org/blog73

Fedora Cloud Images Available Today! by Rich Bowen

> The Fedora Project has released Fedora 21 today, and it includes two images of interest to RDO users who want have the latest and greatest Fedora to run in their cloud.

... Read more at http://tm3.org/blog74

Cloud-init and the case of the changing hostname, by Lars Kellogg-Stedman

> I ran into a problem earlier this week deploying RDO Icehouse under RHEL 6. My target systems were a set of libvirt guests deployed from the RHEL 6 KVM guest image, which includes cloud-init in order to support automatic configuration in cloud environments. I take advantage of this when using libvirt by attaching a configuration drive so that I can pass in ssh keys and a user-data script.

... Read more at http://tm3.org/blog75

