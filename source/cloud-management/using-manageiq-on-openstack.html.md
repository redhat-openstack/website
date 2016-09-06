---
title: Using ManageIQ on OpenStack
category: cloud-management
authors: dneary
---

# Using ManageIQ on OpenStack

## Managing OpenStack with ManageIQ

[ManageIQ](http://manageiq.org) is a cloud management platform which can be deployed on OpenStack, and can manage instances running on OpenStack clouds.

### Installing ManageIQ

There are [basic instructions](http://manageiq.org/download/) available for downloading and installing ManageIQ. To display the instructions for OpenStack, choose OpenStack as your platform and select a desired release. The basic process is uploading an appliance to Glance, and launching it with an appropriately provisioned instance (ManageIQ needs a minimum of 6 GB RAM and a 45 GB persistent disk).

Once the application is installed, you can manage your OpenStack cloud by configuring it as a cloud provider for ManageIQ. 

See the [Documentation section](http://manageiq.org/documentation/) on the ManageIQ website for more information on deploying and using ManageIQ.

### Common cloud management tasks

ManageIQ reads images and templates directly from Glance (a process the project calls "fleecing"). It also gathers information about memory and processor usage of instances through Ceilometer. ManageIQ also detects and raises events which occur during the operation of the cloud.

Many common cloud management tasks can be accomplished with the ManageIQ tagging and scripting capabilities. Some examples are:

*   Generate a list of instances affected by a security vulnerability and prevent the creation of new instances from an affected template.
*   Provision instances using a service catalog or configuration management provider.
*   Automatically perform maintenance operations to rebalance clusters.
*   Identify over-resources instances.

Most of these tasks combine fleecing, monitoring, and events with tagging.

For example, you can ensure that VMs are protected against CVEs by comparing the software version to exposed versions, tag VMs which are vulnerable, and test for that tag when VM lifecycle events occur. You can tag instances with specific requirements (for example, a database server which has high I/O requirements) and ensure that it is launched in a configuration which meets its quality of service requirements. You can detect a threshold event on a host in a cluster, and kick off a rebalancing operation which will live-migrate some instances to different hosts, when it occurs.

