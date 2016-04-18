---
title: MariaDB Galera
authors: rohara
wiki_title: MariaDB Galera
wiki_revision_count: 6
wiki_last_updated: 2014-02-20
---

# MariaDB Galera

{:.no_toc}

## Using MariDB+Galera Cluster with RDO Havana

OpenStack services store information in an SQL database. Typically this is MySQL running on a single node, which presents a single point of failover. This guide will show how to deploy a highly available database using MariaDB and Galera, as well as how to integrate this cluster with HAProxy and RDO.

This guide will assume that RDO has been installed on a single node via packstack on 'node-01' with address 10.15.85.141.

    % packstack --allinone

This will deploy OpenStack on a single node, including the MySQL server. In order to replace this database with a highly-available MariaDB+Galera cluster, all OpenStack services should first be stopped.

    % openstack-service stop

Note that the MySQL service is still running. Before stopping the MySQL service, backup all databases. This backup will later be imported into the MariaDB database.

    % mysqldump --opt --events --all-databases > openstack.sql

Now that the databases have been dumped, stop and disable the MySQL service.

    % service mysqld stop
    % chkconfig mysqld off

Now deploy the MariaDB+Galera cluster. It is recommended to use at least 3 nodes for this cluster. In this example, the MariaDB+Galera cluster will be deployed on three additional nodes that will be referred to as 'node-02', 'node-03'. and 'node-04' with addresses 10.15.85.142, 10.15.85.143, and 10.15.85.144 respectively.

On each of the MariaDB+Galera cluster nodes, configure the yum repo from which the packages will be retrieved. In this example, each machine is running RHEL6, x86_64. Appropriate yum repositories for other operating systems and/or architectures can be found using the MariaDB [repository configuration tool](http://downloads.mariadb.org/mariadb/repositories/).

    # cat /etc/yum.repos.d/mariadb.repo 
    [mariadb]
    name=MariaDB
    baseurl=http://yum.mariadb.org/5.5/rhel6-amd64
    gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
    gpgcheck=1

Now install the MariaDB and Galera packages on each of the cluster nodes.

    yum install MariaDB-Galera-server MariaDB-client galera

At this time, MariaDB+Galera cluster does not work with SELinux is enabled. Set SELinux to permissive mode on all cluster nodes before attempting to start the service.

    # setenforce 0

Open required ports for MariaDB+Galera cluster.

    # iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
    # iptables -A INPUT -p tcp --dport 4567 -j ACCEPT

With the packages now installed on all three cluster nodes, login to one of the cluster nodes and bootstrap the cluster. In this example, the first node to be started will be 'node-02'. For now, all relevant parameters will be passed on the command line.

    # service mysql start --user=mysql \
      --wsrep_cluster_address=gcomm:// \
      --wsrep_provider=/usr/lib64/galera/libgalera_smm.so \
      --wsrep_sst_method=rsync

Note that when bootstrapping a new cluster the wsrep_cluster_address should use an empty "gcomm://" parameter. This will create a new cluster and therefore should not be use when adding a node to an existing cluster. Adding nodes to an existing cluster will be covered later in this guide. For more information, please refer to [Getting Started With MariaDB Galera Cluster](http://mariadb.com/kb/en/getting-started-with-mariadb-galera-cluster/).

With a single-node MariaDB+Galera cluster up and running, the next steps are to add more nodes to the cluster and to import the OpenStack database previously dumped. These can be done in any order. In this example the database will be imported, followed by adding two more cluster nodes.

Copy the dumped databases from the all-in-one OpenStack node (node-01) to our single-node MariDB+Galera cluster (node-02).

    # scp openstack.sql root@10.15.85.142:~/

Before importing the OpenStack database backup, be aware that the import will include all users, password and privileges from the original database. This is convenient since it included the users, passwords and privileges that each OpenStack service uses to store and retrieve information from the database. However, the MySQL root user and password will also be imported. If you have previously set the password for the root user of MariaDB, it will be overwritten by the MySQL root password.

On the MariDB+Galera cluster node, import the OpenStack database.

    mysql < openstack.sql

Now login to MariaDB as the root user. The password that was imported in the previous step won't be used until the privileges are flushed, so use the original password (if any) for the MariaDB root user.

    # mysql -u root

Check that the OpenStack users were correctly imported.

    MariaDB [(none)]> SELECT user,host FROM mysql.user;
    +----------------+-----------+
    | user           | host      |
    +----------------+-----------+
    | cinder         | %         |
    | glance         | %         |
    | keystone_admin | %         |
    | neutron        | %         |
    | nova           | %         |
    | cinder         | 127.0.0.1 |
    | glance         | 127.0.0.1 |
    | keystone_admin | 127.0.0.1 |
    | neutron        | 127.0.0.1 |
    | nova           | 127.0.0.1 |
    | root           | localhost |
    +----------------+-----------+
    11 rows in set (0.00 sec)

Finally, flush the privileges and logout of MariaDB.

    MariaDB [(none)]> FLUSH PRIVILEGES;
    Query OK, 0 rows affected (0.00 sec)

    MariaDB [(none)]> EXIT;
    Bye

Now add our two additional nodes to the MariaDB+Galera cluster. To do this, login to both node and run the following command.

    # service mysql start --user=mysql \
      --wsrep_cluster_address=gcomm://10.15.85.142,10.15.85.143,10.15.85.144 \
      --wsrep_provider=/usr/lib64/galera/libgalera_smm.so \
      --wsrep_sst_method=rsync

This command will cause the node to join the existing cluster by first contacting one of three possible nodes. At this point only 'node-02' (10.15.85.142) is part of the cluster, so using "gcomm://10.15.85.142" would be sufficient.

When a node joins the MariaDB+Galera cluster, it must be synchronized. This is accomplished with a State Snapshot Transfer, or SST. The SST works by having an node that is an active member of the cluster copy data to the new node. The node that is responsible for transferring data to the new node is referred to as the donor. The means by which a donor will synchronize a new node is called the SST method. In the example shown above, the rsync method is used. One alternative to the rsync method is the mysqldump method. This guide uses rsync because it is faster than the mysqldump method and does not require a username/password passed in via the wsrep_sst_auth parameter.

When using either rsync or mysqldump SST methods, it is important to node that the donor node will be read-only for the duration of the SST.

Once the two additional nodes have joined the MariaDB+Galera cluster, login to MariaDB on any of the cluster nodes to examine the cluster's current state.

    # mysql -u root -p -e "SHOW STATUS LIKE 'wsrep%';
    Enter password: 
    +------------------------------+-------------------------------------------------------+
    | Variable_name                | Value                                                 |
    +------------------------------+-------------------------------------------------------+
    | wsrep_local_state_uuid       | a3cbd3a8-9a4c-11e3-b1d8-1b4927b57450                  |
    | wsrep_protocol_version       | 5                                                     |
    | wsrep_last_committed         | 17187                                                 |
    | wsrep_replicated             | 9519                                                  |
    | wsrep_replicated_bytes       | 4406528                                               |
    | wsrep_repl_keys              | 33384                                                 |
    | wsrep_repl_keys_bytes        | 486009                                                |
    | wsrep_repl_data_bytes        | 3311303                                               |
    | wsrep_repl_other_bytes       | 0                                                     |
    | wsrep_received               | 6933                                                  |
    | wsrep_received_bytes         | 3873758                                               |
    | wsrep_local_commits          | 9519                                                  |
    | wsrep_local_cert_failures    | 0                                                     |
    | wsrep_local_replays          | 0                                                     |
    | wsrep_local_send_queue       | 0                                                     |
    | wsrep_local_send_queue_avg   | 0.000311                                              |
    | wsrep_local_recv_queue       | 0                                                     |
    | wsrep_local_recv_queue_avg   | 0.002164                                              |
    | wsrep_local_cached_downto    | 876                                                   |
    | wsrep_flow_control_paused_ns | 0                                                     |
    | wsrep_flow_control_paused    | 0.000000                                              |
    | wsrep_flow_control_sent      | 0                                                     |
    | wsrep_flow_control_recv      | 0                                                     |
    | wsrep_cert_deps_distance     | 1.000000                                              |
    | wsrep_apply_oooe             | 0.048369                                              |
    | wsrep_apply_oool             | 0.000000                                              |
    | wsrep_apply_window           | 1.050760                                              |
    | wsrep_commit_oooe            | 0.000000                                              |
    | wsrep_commit_oool            | 0.000000                                              |
    | wsrep_commit_window          | 1.003188                                              |
    | wsrep_local_state            | 4                                                     |
    | wsrep_local_state_comment    | Synced                                                |
    | wsrep_cert_index_size        | 33                                                    |
    | wsrep_causal_reads           | 0                                                     |
    | wsrep_incoming_addresses     | 10.15.85.142:3306,10.15.85.143:3306,10.15.85.144:3306 |
    | wsrep_cluster_conf_id        | 3                                                     |
    | wsrep_cluster_size           | 3                                                     |
    | wsrep_cluster_state_uuid     | a3cbd3a8-9a4c-11e3-b1d8-1b4927b57450                  |
    | wsrep_cluster_status         | Primary                                               |
    | wsrep_connected              | ON                                                    |
    | wsrep_local_bf_aborts        | 0                                                     |
    | wsrep_local_index            | 1                                                     |
    | wsrep_provider_name          | Galera                                                |
    | wsrep_provider_vendor        | Codership Oy <info@codership.com>                     |
    | wsrep_provider_version       | 25.3.2(r170)                                          |
    | wsrep_ready                  | ON                                                    |
    +------------------------------+-------------------------------------------------------+

With an active/active, multi-master MariaDB cluster up and running, deploy HAProxy to serve as a load balancer for our database cluster. In this example, a single instance of HAProxy will be deployed on the OpenStack node with address 10.15.84.141. This is normally not recommended since it creates a single point of failure, but the focus of this guide is deploying MariaDB+Galera.

Login to the OpenStack node (node-01) and install HAProxy:

    # yum install haproxy

Edit the HAProxy configuration file (/etc/haproxy/haproxy.cfg).

    global
        daemon

    defaults
        mode tcp
        maxconn 10000
        timeout connect 5s
        timeout client 60s
        timeout server 60s

    listen galera 10.15.85.141:3306
        mode tcp
        balance roundrobin
        server node-02 10.15.85.142:3306 check inter 5s rise 2 fall 3
        server node-03 10.15.85.143:3306 check inter 5s rise 2 fall 3
        server node-04 10.15.85.144:3306 check inter 5s rise 2 fall 3

The example shown above creates a proxy that listen on 10.15.85.141, port 3306. Note that this is the same address and port that the original MySQL server was listening on and thus the same address and port that the OpenStack services will attempt to connect to. For example, check the SQL connection paramater for the Nova service.

    # openstack-config --get /etc/nova/nova.conf DEFAULT sql_connection
    mysql://nova:f45a5245043d4973@10.15.85.141/nova

The above command shows the user (nova), password (f45a5245043d4973), host (10.15.85.141) and database (nova) that the Nova service will use for its database connection. The port is not specified, so the default (3306) is used. If our database proxy configuration was using a virtual IP address, each OpenStack service's database connection parameter would need to be changed accordingly.

Start the HAProxy service on the OpenStack node.

    # service haproxy start

As this point, an SQL connection to the proxy (10.15.85.141, port 3306) should be directed to one of the node in the MariaDB+Galera cluster. In addition, the database users for each OpenStack server should be able to connect using the appropriate username and password. From the OpenStack node, use the mysql client to connect to the proxy as user 'nova'.

    # mysql -h 10.15.85.141 -P 3306 -u nova -p

Start all OpenStack services on 'node-01'.

    # openstack-services start
