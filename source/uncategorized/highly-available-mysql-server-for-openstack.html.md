---
title: Highly Available MySQL server for OpenStack
authors: dneary, radez
wiki_title: Highly Available MySQL server for OpenStack
wiki_revision_count: 40
wiki_last_updated: 2013-10-07
---

# Highly Available MySQL with RDO

When running OpenStack API services with MySQL on a single node, the database is a single point of failure. This guide will show how to manually deploy pacemaker and and use it to manage your MySQL cluster across multiple nodes.

### Prerequisites

This guide assumes that OpenStack has been deployed on EL 6.5 with a single database node and that a second node has an unused mysql server installed on it. An all in one install will be fine for demonstration purposes. See the RDO QuickStart guide to get OpenStack installed.

### Overview

MySQL will be configured in an active/passive configuration. Pacemaker will manage a floating ip address across the two MySQL nodes. The ip address will live on the master node and the slave node will be configured to replicate all the activity on the master to the slave. In the event of a failure, Pacemaker will move the ip to the slave node. Once the slave starts to receive writes the master will be out of sync from the slave and will require a resync before replication can be reestablished.

### Installing Pacemaker and creating a cluster

We'll use 10.11.12.1 (node1) and 10.11.12.2 (node2) as the two MySQL nodes

On both nodes install pacemaker

    node1$ yum install pacemaker pcs cman
    node2$ yum install pacemaker pcs cman

On both nodes setup the cluster

    node1$ pcs cluster setup --name openstack_mysql node1 node2
    node2$ pcs cluster setup --name openstack_mysql node1 node2

If you use names instead of ip addresses like the example above be sure they resolve to the hosts.

On both nodes start the cluster

    node1$ pcs cluster cluster start
    node2$ pcs cluster cluster start

Now that the cluster is started commands only need to be run on one of the machines to add resources and check status.</br> You'll need to add stonith devices for resources to start properly. For this demonstration stonith it will be disabled instead.

    node1$ pcs property set stonith-enabled=true

Now add the floating ip address, lets use 10.11,12.37

    node1$ pcs resource create ip-10.11,12.37 IPaddr2 ip=10.11,12.37 cidr_netmask=32 op monitor interval=30s
