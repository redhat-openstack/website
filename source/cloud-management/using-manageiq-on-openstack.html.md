---
title: Using ManageIQ on OpenStack
category: cloud-management
authors: dneary
wiki_category: Cloud management
wiki_title: Using ManageIQ on OpenStack
wiki_revision_count: 1
wiki_last_updated: 2014-07-01
---

# Using ManageIQ on OpenStack

## Managing OpenStack with ManageIQ

[ManageIQ](http://manageiq.org) is a cloud management platform which can be deployed on OpenStack, and can manage instances running on OpenStack clouds.

### Installing ManageIQ

There are [detailed instructions](http://manageiq.org/download/openstack/) for deploying ManageIQ on OpenStack - the basic process is uploading an appliance to Glance, and launching it with an appropriately provisioned instance (30GB disk minimum required).

Once the application is installed, you can manage your OpenStack cloud by [configuring it as a cloud provider for ManageIQ](http://manageiq.org/documentation/top-tasks/#add-red-hat-openstack-providers).

### Common cloud management tasks

ManageIQ reads images and templates directly from Glance (a process the project calls "fleecing"). It also gathers information about memory and processor usage of instances through Ceilometer. ManageIQ also detects and raises events which occur during the operation of the cloud.

Many common cloud management tasks can be accomplished with this, and wil ManageIQ's tagging and scripting capabilities. Some examples are:

*   [Generate a list of instances affected by Heartbleed](http://ask.manageiq.org/question/33/protecting-myself-against-openssh-and-openssl-cves/) and prevent the creation of new instances from an affected template
*   Provisioning instances using a service catalog or config management provider
*   Automatically performing maintenance operations to rebalance clusters
*   Identifying over-resources instances

Most of these tasks combine fleecing, monitoring and events with tagging.

For example, we can ensure that VMs are protected against CVEs by comparing the software version to exposed versions, tag VMs which are vulnerable, and test for that tag when VM lifecycle events occur. We can tag instances with specific requirements (for example, a database server which has high I/O requirements) and ensure that it is launched in a configuration which meets its quality of service requirements. We can detect a threshold event on a host in a cluster, and kick off a rebalancing operation which will live-migrate some instances to different hosts, when it occurs.

[Category:Cloud management](Category:Cloud management)
