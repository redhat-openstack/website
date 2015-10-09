---
title: Galera-boot-process-for-HA-deployments-and-manual-override
authors: dciabrin
date: 2015-10-09 16:48:27 UTC
tags: ha, galera
---


# Galera boot process for HA deployments and manual override

Deployments of OpenStack that rely on MariaDB+Galera benefit from a HA database thanks to Galera's synchronous replication. In such deployments, the Galera cluster is typically managed via Pacemaker, by means of a galera resource agent.

While Galera itself has its own notion of cluster management (membership, health check, write-set replication...), a resource agent is still necessary for Pacemaker to perform the basic cluster management duties, for example:

  * Starting up the Galera servers on the available nodes in the cluster

  * Health monitoring and recovery actions on failure (e.g. fencing)

This document describes the concepts involved in booting a Galera cluster with Pacemaker, how the galera resource agent decomposes the boot process, and how it can be overridden for recovery scenarios.

## Galera cluster overview

A Galera cluster is identified by a cluster address, stored in the configuration variable `wsrep_cluster_address`. The value of this variable is a URI identifying all the nodes that can potentially be member of the cluster. For example:

    wsrep_cluster_address=gcomm://node1,node2,node3

It is used by MariaDB at boot time to register to the cluster and to synchronize its local database with the cluster. The value of `wsrep_cluster_address` conveys a special meaning which can be used to either start a cluster or rejoin it.

## Galera boot process explained

Galera replicates database writes across all nodes of the cluster. A write succeeds if more than half of the nodes in the cluster acknowledge it (quorum). On success, a global counter representing the most recent transaction is incremented: this is called the last sequence number, or `seqno`. Desynchronized nodes or newly joining nodes will automatically sync their local database to this last sequence number.

In order to restart an existing Galera cluster, one needs first to identify a node whose local database contains the latest transaction acknowledged by the cluster, i.e. the one with the biggest `seqno`. Once identified, MariaDB can be started on the node with option:

    wsrep_cluster_address=gcomm://

This bootstraps a new cluster[^1] from this node's local state: the node becomes the new Primary partition, which means the remaining nodes will sync against this new cluster when started with `wsrep_cluster_address=gcomm://node1,node2,node3`.

## How the resource agent boots the cluster

The resource agent encodes the process of booting a Galera cluster as a series of unitary steps; electing a bootstrap node, booting Galera servers in a specific order, and marking nodes as available in the clusters. It tracks those steps via Pacemaker's multi-state resource plus various attributes stored in Pacemaker's Cluster Information Base (CIB).

In order to boot or restart a Galera cluster, the resource agent needs to retrieve the last `seqno` of all the nodes in the clusters. Without that information, the resource agent cannot safely identify a bootstrap node and it will not tell Pacemaker to start the Galera cluster.

The boot process works as follows:

  * When a galera resource is in state *Started*, the resource agent retrieves the last `seqno` from the local MariaDB, stores it in the CIB and goes to *Slave* state. At this stage, no Galera server is running.

  * Once all the nodes are in *Slave* state, the resource agent elects the bootstrap node, tags it in the CIB, and tells Pacemaker that it can promote the galera resource on this node to the *Master* state.

  * When Pacemaker promotes the bootstrap node, the resource agent starts the Galera server, which bootstraps a new cluster. It then marks the remaining nodes as being ready for promotion. The resource on the bootstrap node is switched to *Master*, and the Galera cluster is ready to process SQL queries.

  * Pacemaker promotes the remaining nodes. For each node, the resource agent start a Galera server, which synchronizes its local state with the cluster via a State Snapshot Transfer (SST). This operation can take some time. The promotion to *Master* finishes when the synchronization is over and the Galera server is ready to process SQL queries.

At this stage, the entire cluster is up and running, and the galera resource is set *Master* on all nodes.

Note: the notion of Master / Slave state is completely different from Galera's notion of Primary / Non-primary state:

  * A Galera node is in primary state if it belongs to a partition of the cluster which has quorum (and is thus active).

  * If a Galera node detects the partition it belongs to is inquorate, it will switch to Non-primary state, and SQL queries will fail[^2].


## Overriding the boot process

The resource agent expects that all the nodes are available for performing a boot. However, there are times where this is not the case and for practical reasons it is necessary to force the boot process.

Here are some examples of manual override scenarios, and their associated steps to bring the Galera cluster up. The examples assume that the Pacemaker cluster is composed of nodes `node1`, `node2`, `node3`, and that the galera resource is called `galeracluster`.

### Scenario 1: Galera cluster to be restarted, but one Galera server won't come up

Suppose that `node3` in the cluster is unavailable following an unexpected event (e.g. Galera crashed and left in a inconsistent state, hardware failure on `node3`...). In such case, the resource agent is not able to retrieve all `seqno` in the cluster, so no bootstrap node can be elected, and the cluster will not be restarted. One can force the election of a bootstrap node and start it, in order to unblock the resource agent and let Pacemaker boot the rest of the Galera cluster.

__Do the following steps only if you're sure that the forced bootstrap node is up-to-date, otherwise you will permanently desynchronize your cluster and will lose data!__

That being said, to unblock the boot process, you will need to elect and promote a bootstrap node manually. So first, take control of Galera away from Pacemaker:

    # pcs resource unmanage galeracluster

Next, identify the node with the most recent `seqno`. If Pacemaker previously tried to restart the cluster, you can retrieve this information in the CIB, e.g. for `node1`:

    # crm_attribute -N node1 -l reboot --name galeracluster-last-committed -Q

If the last `seqno` is not present in the CIB[^3], you can retrieve it with MariaDB:

    # mysqld_safe --wsrep-recover
    151002 13:59:35 mysqld_safe Logging to '/var/log/mariadb/mariadb.log'.
    151002 13:59:35 mysqld_safe Starting mysqld daemon with databases from /var/lib/mysql
    151002 13:59:35 mysqld_safe WSREP: Running position recovery with --log_error='/var/lib/mysql/wsrep_recovery.2FkYLQ' --pid-file='/var/lib/mysql/db1-recover.pid'
    151002 13:59:50 mysqld_safe WSREP: Recovered position 4c7ba2a8-566a-11e5-8250-1e939ac17c77:9
    151002 13:59:52 mysqld_safe mysqld from pid file /var/run/mariadb/mariadb.pid ended

MariaDB will recover its last known cluster position as `UUID:seqno`. In our case, on `node1` the last `seqno` is thus `9`.

Once you have determined which node has the bigger `seqno`, make it the bootstrap node and force Pacemaker to start Galera by switching the resource's state to *Master*. In our case, assuming `node1` is the bootstrap node, connect to `node1` and run the following commands locally:

    # crm_attribute -N node1 -l reboot --name galeracluster-bootstrap -v true
    # crm_attribute -N node1 -l reboot --name master-galeracluster -v 100
    # crm_resource --force-promote -r galeracluster -V

Then, instruct Pacemaker to re-detect the current state of the galera resource. This will clean up failcount and purge knowledge of past failures:

    # pcs resource cleanup galeracluster

At this point Galera is up and Pacemaker knows that it is up. Give back control of Galera to Pacemaker and the remaining node will join automatically[^4]:

    # pcs resource enable galeracluster
    # pcs resource manage galeracluster



### Scenario 2: Multiple hardware failures, keep service on the remaining node

If `node2` and `node3` fail successively in the three-node cluster, you may end up with only `node1` up and running. Pacemaker will react differently to this condition depending on how quorum is configured in the cluster[^5].

For Galera, things are less flexible: if two nodes out of three quit the cluster unexpectedly, the remaining node is considered inquorate and the Galera server will switch to Non-primary state. This is an error condition for the resource agent, and that causes Pacemaker to stop the Galera server on the remaining node.

You can force the restart of Galera on `node1` if this node is still up and running in Pacemaker[^6]. You just need to bootstrap the Galera cluster by applying similar steps as those described in Scenario 1. __Please only do so if you are sure that the node is in sync with the latest revision of the cluster, otherwise you will lose data__.

Apply the step from Scenario 1 __and stop before giving back control to Pacemaker__[^7]. At this point, check whether the Pacemaker cluster has quorum:

    # corosync-quorumtool -s
    Quorum information
    ------------------
    Date:             Fri Oct  2 18:20:37 2015
    Quorum provider:  corosync_votequorum
    Nodes:            1
    Node ID:          1
    Ring ID:          1376
    Quorate:          No

    Votequorum information
    ----------------------
    Expected votes:   3
    Highest expected: 3
    Total votes:      1
    Quorum:           2 Activity blocked
    Flags:

    Membership information
    ----------------------
    Nodeid      Votes Name
	     1          1 node1 (local)


If it does not, you have to unblock quorum temporarily for Pacemaker to manage resources, i.e. set the number of expected votes the the number of nodes which are still on-line. In our example, only `node1` is on-line, so quorum can be temporarily unblocked with:

    # corosync-quorumtool -e1

Note that this setting is not permanent. As soon as other nodes rejoin, the number of expected votes will go back to the original value (3 in the example).

Once the cluster is quorate again, you can give back control of Galera to Pacemaker:

    # pcs resource manage galeracluster




- - -


[^1]: Starting a new cluster can also be achieved with `--wsrep_new_cluster`. The two options are equivalent.

[^2]: Data-related SQL queries will fail with `ERROR 1047 (08S01): WSREP has not yet prepared node for application use`.

[^3]: If the information is not in the CIB, `crm_attribute` will report an error like `Error performing operation: No such device or address`.

[^4]: `pcs resource enable galeracluster` will ensure that Pacemaker always try to promote this resource's state to *Master*, i.e. start Galera server on the node if not already done.

[^5]: See `man votequorum` and [no-quorum-policy settings](http://clusterlabs.org/doc/en-US/Pacemaker/1.0/html/Pacemaker_Explained/s-cluster-options.html).

[^6]: Check whether `node1` is still online with `pcs status nodes`.

[^7]: Applying `pcs resource manage galeracluster` will fail if the cluster is inquorate, and that will stop the Galera server that was manually restarted.
