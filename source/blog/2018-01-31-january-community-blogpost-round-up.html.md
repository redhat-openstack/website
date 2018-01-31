---
title: January Community Blogpost Round-up
author: mary_grace
date: 2018-01-31 02:21:59 UTC
published: false
comments: true
---

Here's the latest round-up of RDO- and OpenStack- related blogposts from the community. Thanks to all who continue to produce this great content!

**Keep calm and reboot: Patching recent exploits in a production cloud** by Tim Bell

> At CERN, we have around 8,500 hypervisors running 36,000 guest virtual machines. With the accelerator stopping over the CERN annual closure until mid March, this is a good period to be planning reconfiguration of compute resources such as the migration of our central batch system which schedules the jobs across the central compute resources to a new system based on HTCondor. However, this year we have had an unexpected additional task to deploy the fixes for the Meltdown and Spectre exploits across the centre. Here are the steps we took to upgrade.

Read more at [http://openstack-in-production.blogspot.com/2018/01/keep-calm-and-reboot-patching-recent.html](http://openstack-in-production.blogspot.com/2018/01/keep-calm-and-reboot-patching-recent.html)


**Creating an Ansible Inventory file using Jinja templating** by Adam Young

> While there are lots of tools in Ansible for generating an inventory file dynamically, in a system like this, you might want to be able to perform additional operations against the same cluster. For example, once the cluster has been running for a few months, you might want to do a Yum update. Eventually, you want to de-provision. Thus, having a remote record of what machines make up a particular cluster can be very useful. Dynamic inventories can be OK, but often it takes time to regenerate the inventory, and that may slow down an already long process, especially during iterated development.

Read more at [http://adam.younglogic.com/2018/01/creating-an-ansible-inventory-file-using-jinja-templating/](http://adam.younglogic.com/2018/01/creating-an-ansible-inventory-file-using-jinja-templating/)


**Getting Shade for the Ansible OpenStack modules** by Adam Young

> When Monty Taylor and company looked to update the Ansible support for OpenStack, they realized that there was a neat little library waiting to emerge:  Shade. Pulling the duplicated code into Shade brought along all of the benefits that a good refactoring can accomplish:  fewer cut and paste errors, common things work in common ways, and so on.  However, this means that the OpenStack modules are now dependent on a remote library being installed on the managed system.  And we do not yet package Shade as part of OSP or the Ansible products.  If you do want to use  the OpenStack modules for Ansible, here is the “closest to supported” way you can do so.

Read more at [http://adam.younglogic.com/2018/01/ansible-osp-shade/](http://adam.younglogic.com/2018/01/ansible-osp-shade/)


**Using JSON home on a Keystone server** by Adam Young

> Say you have an AUTH_URL... And now you want to do something with it.  You might think you can get the info you want from the /v3 url, but it does not tell you much. Turns out, though, that there is data, it is just requires the json-home accepts header.

Read more at [http://adam.younglogic.com/2018/01/using-json-home-keystone/](http://adam.younglogic.com/2018/01/using-json-home-keystone/)


**Safely restarting an OpenStack server with Ansible** by Lars Kellogg-Stedman

> The other day on #ansible, someone was looking for a way to safely shut down a Nova server, wait for it to stop, and then start it up again using the openstack cli. The first part seemed easy, but that will actually fail.

Read more at [http://blog.oddbit.com/2018/01/24/safely-restarting-an-openstack-server-wi/](http://blog.oddbit.com/2018/01/24/safely-restarting-an-openstack-server-wi/)
