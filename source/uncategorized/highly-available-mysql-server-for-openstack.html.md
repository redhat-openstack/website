---
title: Highly Available MySQL server for OpenStack
authors: dneary, radez
wiki_title: Highly Available MySQL server for OpenStack
wiki_revision_count: 40
wiki_last_updated: 2013-10-07
---

# Highly Available MySQL server for OpenStack

When running OpenStack API services with MySQL on a single node, the database is a single point of failure. This guide will show how to manually deploy pacemaker and and use it to manage your MySQL cluster across multiple nodes.

## Prerequisites

This guide assumes that OpenStack has been deployed on EL 6.5. There should be two database nodes using shared storage for the database's storage. See the RDO QuickStart guide to get OpenStack installed.

## Overview

MySQL will be configured in an active/passive configuration. Pacemaker will manage a floating ip address and the MySQL service across the two MySQL nodes. In the event of a failure, Pacemaker will move the ip and shared storage to another node and start the MySQL service on that node.

## Installing Pacemaker and creating a cluster

We'll use 192.168.122.3 (node1) and 192.168.122.7 (node2) as the two MySQL nodes

On both nodes install pacemaker

    node1$ yum install pacemaker pcs cman
    node2$ yum install pacemaker pcs cman

On both nodes setup the cluster

    node1$ pcs cluster setup --name openstack_mysql 192.168.122.3 192.168.122.7
    node2$ pcs cluster setup --name openstack_mysql 192.168.122.3 192.168.122.7

The example above uses ip addresses instead of dns names. If you use names instead of ip addresses be sure they resolve to the hosts before performing this step.

On both nodes start the cluster

    node1$ pcs cluster start
    node2$ pcs cluster start

Now that the cluster is started commands only need to be run on one of the machines to add resources and check status. You'll need to add stonith devices for resources to start properly. For this demonstration stonith it will be disabled instead. For a properly configured highly available cluster stonith must be configured, do not disable it in that case.

    node1$ pcs property set stonith-enabled=true

Now add the floating ip address, lets use 192.168.122.203

    node1$ pcs resource create ip-192.168.122.203 IPaddr2 ip=192.168.122.203

## Adding the share storage Pacemaker resource

Before MySQL is started the shared storage needs to be mounted into the mysql storage directory. iSCSI or NFS can be used for this, here NFS will be demonstrated.

    node1$ pcs resource create nfs-mysql Filesystem device=192.168.122.1:/srv/mysql directory=/var/lib/mysql fstype=nfs

## Adding the MySQL Pacemaker resource

For MySql to be highly available we need to add it as a resource for pacemaker to manage and be sure that the service is running on the same node as the floating ip address and shared storage. Start by adding mysql as an LSB (linux standard build) resource.

    node1$ pcs resource create mysql1 mysql

Next MySQL needs to be grouped with the ip address resource so that they always run on the same node. This could have been done it the create command by passing --group test-group to each of the previous resources.

    node1$ pcs resource group add test-group ip-192.168.122.203 nfs-mysql mysql1

Now the ip address and the MySQL service will always run on the same host together.

## Pacemaker constraints

Constraints are unnecessary in this use case. When resources are added to a group pacemaker starts the resources in the order that they were added to the group. This ensures that the storage and ip are ready before MySQL is started without needing to define constraints.

## Summary

At this point there is a floating ip address and the MySQL service are being managed by pacemaker.

In the event of a failure pacemaker will move the floating ip and the MySQL service the other node and database service would stay available.
