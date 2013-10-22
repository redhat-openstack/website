---
title: Highly Available Qpid for OpenStack
authors: ipbabble, radez, sradvan
wiki_title: Highly Available Qpid for OpenStack
wiki_revision_count: 7
wiki_last_updated: 2013-12-05
---

# Highly Available Qpid for OpenStack

## Implementation Options

This document will cover 3 possible configurations available for qpid to be clustered and/or Highly Available. Each are described here, with configuration later in the document.

1. Pacemaker managed without Clustering

This configuration will make the qpid broker highly available but does not prevent message loss. Qpid will run on only one of the pacemaker nodes at a time, grouped with a floating ip. In the event of a node failure pacemaker will start the qpid broker and floating ip on another node. All openstack components will point to the floating ip grouped with the qpid broker for messaging services.

2. Clustered without pacemaker

This configuration runs multiple qpid brokers in a clustered configuration. This prevents message loss, though will require some other form of monitoring for the qpid brokers.

3. Pacemaker managed with clustering

This configuration makes the qpid broker highly available and prevents message loss. Qpid runs with multiple brokers and is monitored by pacemaker.

WARNING: Only set up one of these solutions. These solutions are not intended to be run simultaneously.

## Pacemaker managed without clustering

All that needs to be done is to install qpid on the pacemaker nodes and add it as a pacemaker resource. You can give qpid its own floating ip or just add it in the same group that already has a floating ip. For this demonstration they will be added to a group that already has an existing ip and MySQL.

    $ pcs resource create qpidd lsb:qpidd --group test-group

Finally ensure that all the qpid settings in the openstack components point to the floating ip of the group you added qpid to.

    # Qpid broker hostname (string value)
    qpid_hostname=192.168.122.203
    # Qpid broker port (integer value)
    qpid_port=5672

WARNING: This method of managing qpid through pacemaker makes the service highly available but does not prevent message loss.

## Clustered without pacemaker

The previous example of setting qpid up highly available lets it co-exist with pacemaker but doesn't prevent message loss. If you setup a separate set of nodes to run a qpid cluster then message loss can be prevented. In this scenario qpid must run on a separate set of nodes from pacemaker.

To do this, do the following on each qpid cluster node. First install the qpid cluster packages.

    # yum install -y qpid-cpp-server-cluster qpid-tools

Ensure that the corosync uidgid.d directory has a qpidd file with the following contents:

    # cat /etc/corosync/uidgid.d/qpidd 
    uidgid {
            uid: qpidd
            gid: qpidd
    }

copy the corosync.conf sample file into place

    # cp /etc/corosync/corosync.conf.sample /etc/corosync/corosync.conf

Set the corosync.conf bindnetaddr property to the network address for the interface.
This can be calculated by doing a bitwise AND of the inet addr. For example a 172.16.44.123/255.255.248.0 would result in bindnetaddr being set to 172.16.40.0. In this example 192.168.122.101/255.255.255.0 and 192.168.122.102/255.255.255.0 result in the bindnetaddr value of 192.168.122.0.

      the respective node's ip address
      update the multicast address too if necessary.

            bindnetaddr: 192.168.122.0

Open up a bunch of ports for the cluster to talk

    iptables -I INPUT -p udp -m udp --dport 5405  -j ACCEPT
    iptables -I INPUT -p tcp -m tcp --dport 5405  -j ACCEPT
    iptables -I INPUT -p tcp -m tcp --dport 8084  -j ACCEPT
    iptables -I INPUT -p tcp -m tcp --dport 11111  -j ACCEPT
    iptables -I INPUT -p tcp -m tcp --dport 14567  -j ACCEPT
    iptables -I INPUT -p tcp -m tcp --dport 16851  -j ACCEPT
    iptables -I INPUT -p tcp -m tcp --dport 21064  -j ACCEPT
    iptables -I INPUT -p tcp -m tcp --dport 50006  -j ACCEPT
    iptables -I INPUT -p udp -m udp --dport 50007  -j ACCEPT
    iptables -I INPUT -p tcp -m tcp --dport 50008  -j ACCEPT
    iptables -I INPUT -p tcp -m tcp --dport 50009  -j ACCEPT
    service iptables save
    service iptables restart

start corosync and then qpid

    # service corosync start
    # service qpidd start

Finally replace all the qpid settings in the openstack components to use the qpid_hosts parameter instead of the qpid_hostname and qpid_port parameters

    # Qpid broker hostname (string value)
    #qpid_hostname=localhost
    # Qpid broker port (integer value)
    #qpid_port=5672
    # Qpid HA cluster host:port pairs (list value)
    qpid_hosts=192.168.122.101:5672,192.168.122.102:5672

WARNING: This configuration requires another form of monitoring the qpid brokers.

## Pacemaker managed with clustering

The previous example of setting qpid up highly available lets it co-exist with pacemaker but doesn't prevent message loss. If you setup a separate set of nodes to run a qpid cluster then message loss can be prevented but then pacemaker isn't managing the service. In this scenario qpid runs on the pacemaker nodes and is configured for clustering to prevent message loss.

To do this, start with a working pacemaker install. Than do the following on each pacemaker/qpid cluster node. First install the qpid cluster packages.

    # yum install -y qpid-cpp-server-cluster qpid-tools

Add a uidgid entry to the /etc/cluster/cluster.conf file:

    # cat /etc/cluster/cluster.conf 
    <cluster config_version="9" cluster_name="cluster_name">
            <uidgid uid="qpidd" gid="qpidd" />
           ... other content ...
    </cluster>

On only one node add pacemaker as a cloned resource to pacemaker. A cloned resource runs on all pacemaker nodes. A floating ip is not needed in this configuration because the clients will know about all the brokers.

    node1$ pcs resource create qpidd lsb:qpidd --clone

Finally replace all the qpid settings in the openstack components to use the qpid_hosts parameter instead of the qpid_hostname and qpid_port parameters

    # Qpid broker hostname (string value)
    #qpid_hostname=localhost
    # Qpid broker port (integer value)
    #qpid_port=5672
    # Qpid HA cluster host:port pairs (list value)
    qpid_hosts=192.168.122.101:5672,192.168.122.102:5672
