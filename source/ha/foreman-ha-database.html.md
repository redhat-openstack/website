---
title: Foreman HA Database
authors: cwolfe, jayg
wiki_title: Foreman HA Database
wiki_revision_count: 3
wiki_last_updated: 2013-11-05
---

# Foreman HA Database

**The HA Mysql Host Group** provides a mechanism to set up a HA active/passive Mysql cluster which may be pointed to as the database backend for the various OpenStack service endpoints.

To use HA/Mysql within an OpenStack deployment, you need to make sure to have your Mysql cluster up and running \*before\* spinning up the controller node(s), and make sure the controller Host Group has correct database IP (the virtual Mysql cluster IP) specified. You also need the HA channel enabled if you are on RHEL. Centos should not need this.

      # yum-config-manager --enable rhel-ha-for-rhel-6-server-rpms

At a high level, the required steps are:

*   Edit the default HA Mysql Host Group Parameters relevant to your environment.
*   Run the puppet agent to get the Mysql cluster up and verify that the cluster was set up with no errors.
*   Run the puppet agent again to create the OpenStack databases and users.

Note the above does not set up any fencing configuration. In a production environment fencing is critical: you can either use pacemaker commands to setup fencing, or update the default HA mysql puppet manifests.

**HA Mysql Resources**

The HA Mysql Host Group is responsible for starting Pacemaker and configuring the following resources within a resource group: the floating IP, shared storage for the Mysql server, and the mysql server process. E.g.:

      # pcs status
      ...
      Resource Group: mysqlgrp
          ip-192.168.200.10  (ocf::heartbeat:IPaddr2):       Started 192.168.202.11
          fs-varlibmysql     (ocf::heartbeat:Filesystem):    Started 192.168.202.11
          mysql-ostk-mysql   (ocf::heartbeat:mysql): Started 192.168.202.11

**Repository Requirements**

The cluster nodes must be subscribed to the rhel-ha-for-rhel-6-server-rpms repository, or equivalent (before being subscribed to the HA Mysql Host Group).

**HA Mysql Host Group Parameters**

To edit the Host Group Parameters in the Foreman web UI, click More (on the top right), then Configuration, then Host Groups. Click HA Mysql Node. Click the tab on the right, Parameters. For any parameter you want to override (which very well could be all of them), click on the override button and edit the value at the bottom of the page.

A number of the parameters (especially the IP-related parameters) have defaults which must be changed to reflect your environment. Please take care to ensure all the parameters in your Host Group are correct for your setup.

mysql_root_password, cinder_db_password, glance_db_password, keystone_db_password, nova_db_password: the Mysql database passwords. Note that the random values displayed were generated when you installed foreman but you may wish to override them.

mysql_bind_address: the address mysql listens on. Only two values make sense here, 0.0.0.0 (to listen on all address on whichever host mysql is running on) or the same value as mysql_virtual_ip.

mysql_clu_member_addrs: the IP addresses (as a space-separated list) internal to the cluster that pacemaker communicates on. So, if you are going to have a cluster of 3 members, the three IP addresses of the cluster members are listed here. NOTE: these IP's must already be configured and active on the cluster-hosts-to-be before they are added to this Host Group (i.e., this Host Group does not set up these IP's for you).

mysql_resource_group_name: the name of the resource group. This Host Group adds a virtual IP, filesystem and mysql resource to the resource group named here. The default is fine.

mysql_shared_storage_type: e.g., nfs or ext3. The type of filesystem that pacemaker is responsible for mounting to /var/lib/mysql.

mysql_shared_storage_device: the path to the storage device. E.g. if mysql_shared_storage_type, the nfs mount point.

mysql_virtual_ip: the virtual IP address that pacemaker will manage and the IP address that clients will use to connect to Mysql.

mysql_virt_ip_nic: the interface (e.g., eth2) that pacemaker will attempt to bring up the virtual IP on. Note that this may be empty if the host already has an IP address active on the same subnet that the virtual IP will be brought up on.

mysql_virt_ip_cidr_mask: the subnet mask mysql_virtual_ip lives on (e.g., 16 or 24).
