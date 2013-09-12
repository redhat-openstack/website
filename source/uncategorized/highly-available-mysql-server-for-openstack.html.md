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

MySQL will be configured in an active/passive configuration. Pacemaker will manage a floating ip address across the two MySQL nodes. The ip address will live on the master node and the slave node will be configured to replicate all the activity on the master to the slave. In the event of a failure, Pacemaker will move the ip to the slave node. Once the slave starts to receive writes the master will be out of sync from the slave and will require a resync before replication can be reestablished.

## Installing Pacemaker and creating a cluster

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

## Setting up MySQL Master / Slave Replication

Start by adding a few lines to the my.cnf file on both nodes. Both nodes need a unique server-id. On node1 also define the binary log name. node1:

    server-id = 1
    log-bin=node1

node2:

    server-id = 2

To verify the server ids are being used query mysql for the value

    mysql> SHOW VARIABLES LIKE "server_id";

    +---------------+-------+
    | Variable_name | Value |
    +---------------+-------+
    | server_id     |   3   |
    +---------------+-------+

    1 row in set (0.00 sec)

Here's some optional directives to add to my.cnf. You'll have to do more research on them to decide if you want them or not.

    binlog-ignore-db = mysql
    max_binlog_size=200M
    expire_logs_days = 2
    binlog_cache_size = 64M

Next create a replication user on node1

    mysql> GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'replication'@'10.11.12.2' IDENTIFIED BY 'password';
    mysql> FLUSH PRIVILEGES;

Now that there is a replication user and the nodes have unique ids the slave can be told to replicate from the master node.
To do that you need the master's log name and position. On the master show the master status to get these.

    mysql> SHOW MASTER STATUS;
    +--------------+----------+--------------+------------------+
    | File | Position | Binlog_Do_DB | Binlog_Ignore_DB |
    +--------------+----------+--------------+------------------+
    | node1.000003 | 107      |              |                  |
    +--------------+----------+--------------+------------------+
    1 row in set (0.00 sec)

Take the file name and the log position and configure the slave node with it

    mysql> CHANGE MASTER TO master_host = '10.11.12.1', master_user='replication', master_password='password', master_log_file='node1.000003', master_log_pos=107;

Next start the slave on the slave node and check the slave status

    mysql> START SLAVE;
    mysql> SHOW SLAVE STATUS\G;
    *************************** 1. row ***************************
    Slave_IO_State: Waiting for master to send event
    Master_Host: 10.11.12.1
    Master_User: replication
    ...
    Slave_IO_Running: Yes
    Slave_SQL_Running: Yes
    ...
    Seconds_Behind_Master: 0
    1 row in set (0.00 sec)

A good indicator that things are in good shape is the Seconds_Behind_Master value. If that number is 0 or approaching 0 then your in replicating business.

The last thing to do is to seed the slave with all the master's data so they're in sync. All the data that existed before binary logging was turned on for repliciation does not exist in the binary logs, so you have to replicate it manually. Fortunatly with some ssh goodness this can be done fairly easily. Stop the slave on the slave node

    mysql> STOP SLAVE;

Then use mysqldump and ssh on the master to do the sync. Note that this command locks all the tables on the master while it's dumping.

    mysqldump --delete-master-logs --ignore-table=mysql.user --master-data --lock-all-tables --all-databases --hex-blob | ssh 10.11.12.2 "cat | mysql"

All this is really doing is dumping the master database and importing it into the slave while writes are prevented. It does it all in one command over ssh, there's probably other methods to do this if you choose not to do it this way.

Finally start the slave back up on the slave node

    mysql> START SLAVE;

## Summary

At this point there is a floating ip address being managed by pacemaker and mysql is running on both database nodes and is replicating data from the master to the slave. The floating ip is pointing to the master.

In the event of a failure pacemaker will move the floating ip to the slave node and database service would stay available. To move service back to the master node the master would need to be resynced with the slave and the ip would have to be moved back to the master node using pacemaker.

## Summary
