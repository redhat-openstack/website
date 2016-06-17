---
title: RDO MySQL Multi-Master Replication Active-Active HA
authors: yocum137
wiki_title: RDO MySQL Multi-Master Replication Active-Active HA
wiki_revision_count: 22
wiki_last_updated: 2014-05-06
---

# RDO MySQL Multi-Master Replication Active-Active HA

## Overview

MariaDB+Galera, pacemaker, and haproxy are the new hotness, no doubt about it. But, I'm old school and have used MySQL multi-master replication with an LVS (piranha) load balancer in a 200 TPS production environment for nearly 10 years and feel more at ease using tried and true technologies. I'm not saying this is the best way, but I know that it's one way that works (and doesn't require pacemaker and corosync which just makes my eye twitch).

There are 3 tasks to accomplish:

1.  deploy RHEL6x VMs to host the load balancers and sql servers
2.  deploy multi-master replication mysql database system
3.  deploy piranha load balancer using Direct Routing

**Conventions used:**

*   The load balancers and mysql servers must be on the same network segment, have the same netmask and gateway, and be able to receive the

same broadcasts.

*   sql1 and lb1 are the first mysql and load balancer servers, respectively.
*   sql2 and lb2 are the second mysql and load balancer servers, respectively.
*   10.0.0.1 is the IP of the primary load balancer, lb1.example.com.
*   10.0.0.2 is the IP of the secondary load balancer, lb2.example.com.
*   10.0.0.3 is the IP of the VIP for the mysql server, sql.example.com.
*   10.0.0.4 is the IP of the first mysql Real Server, sql1.example.com.
*   10.0.0.5 is the IP of the second mysql Real Server, sql2.example.com.

## 1. VM Deployment

In order to provide high availability and fault tolerance of the MySQL database, a minimum of 2 VMs are required for each mysql server and 2 VMs for the load balancers for a total of 4 VMs. Each pair of VMs should be hosted on separate hardware systems which also should be built with fault tolerance in mind - redundant UPS and/or generator backed electrical circuits and power distribution, redundant system power supplies, RAIDed disk, dual pathed and bonded NICs, dual socket CPUs, and ECC memory.

Typically, these physical hosts should easily be able to host the necessary VMs for all OpenStack control services provided they have enough RAM:

       +---------------------+ +---------------------+
        |   host system 1     | |   host system 2     |
        | +-----------------+ | | +-----------------+ |
        | | load balancer 1 | | | | load balancer 2 | |
        | +-----------------+ | | +-----------------+ |
        | +-----------------+ | | +-----------------+ |
        | | mysql server 1  | | | | mysql server 2  | |
        | +-----------------+ | | +-----------------+ |
        | +-----------------+ | | +-----------------+ |
        | | amqp server 1   | | | | amqp server 2   | |
        | +-----------------+ | | +-----------------+ |
        | +-----------------+ | | +-----------------+ |
        | | controller 1    | | | | controller 2    | |
        | +-----------------+ | | +-----------------+ |
        +---------------------+ +---------------------+

The OpenStack MySQL database is not very large, but requires enough disk space for storing binary logs which are the key for database replication. For a medium sized cloud with 64 compute nodes and support for 4,000 2GB VMs, the following VM parameters are recommended:

*   2 vCPUs
*   2GB RAM
*   4GB swap
*   2GB / partition
*   16GB /var partition
*   RHELv6

The load balancers require significantly less resources. The following specs are more than adequate:

*   1 vCPU
*   1GB RAM
*   1GB swap
*   2GB / partition
*   4GB /var partition
*   RHELv6

Iptables must be configured on all VMs to allow traffic on ports 3306 to the hosts or network segment that requires access to mysql, and 539 on the load balancers for heartbeat communication.

Additionally, stateful connections should not be maintained in iptables on the load balancers in order to allow for transparent connection failover between the primary and secondary load balancers. See the following for more information:

[<http://www.austintek.com/LVS/LVS-HOWTO/HOWTO/LVS-HOWTO.failover.html#stateful_failover> ] "On failover, a director configured with no filter rules can be replaced with an identically configured backup with no interruption of service to the client. There will be a time in the middle of the changeover where no packets are being transmitted (and possibly icmp packets are being generated), but in general once the new director is online, the connection between client and realserver should continue with no break in established tcp connections between the client and the realserver... If stateful filter rules are in place (e.g. only accept packets from ESTABLISHED connections) then after failover, the new director will be presented packets from tcp connections that are ESTABLISHED, but of which it has no record. The new director will REJECT/DROP these packets."

To solve "The Arp Problem" in Direct Routing mode (see [1](http://www.austintek.com/LVS/LVS-HOWTO/HOWTO/LVS-HOWTO.arp_problem.html)), the following steps must be performed on the mysql servers:

1) Add the following lines to /etc/sysctl.conf then run 'sysctl -p':

      net.ipv4.conf.all.arp_announce = 2
      net.ipv4.conf.all.arp_ignore = 1

2) Create the file /etc/sysconfig/network-scripts/ifcfg-lo:3 with the following contents and start the interface by running 'ifup lo:3':

      DEVICE=lo:3
      BOOTPROTO=none
      ONPARENT=yes
      TYPE=Ethernet
      IPADDR=10.0.0.3
      NETMASK=255.255.255.255
      GATEWAY=10.0.0.254
      PEERDNS=no
      NM_CONTROLLED=no

## 2. MySQL Multi-Master Replication Deployment

In this set up, replication is performed at the query level - that is, the binary logs are replayed, query by query, to produce the replication between each system.

The following guide are based on the "Advanced MySQL Replication Techniques" ( [http%3A%2F%2Fwww.onlamp.com%2Fpub%2Fa%2Fonlamp%2F2006%2F04%2F20%2Fadvanced-mysql-replication.html&sa=D&sntz=1&usg=AFQjCNGy-p0Wl41m7DxoLeACYaksXnrupQ] ) OnLamp article written by Giuseppe Maxia, "How To Set Up Database Replication in MySQL" ( [http%3A%2F%2Fwww.howtoforge.com%2Fmysql_database_replication&sa=D&sntz=1&usg=AFQjCNH8Kaa0MY1e6Gb-Z5jgJZ2_bT4z7Q] ) by Falko Timme, and Chapter 16, "Replication of the MySQL 5.1 Reference Manual" ( [2](http://dev.mysql.com/doc/refman/5.1/en/replication.html) ). This guide is only valid for MySQL v5.1 and later.

1) On each system, install the mysql client and server:

      yum -y install mysql mysql-server 

2) Stop the mysql server on each system:

      service mysqld stop 

3) Edit the /etc/my.cnf file on each system (NB: the my.cnf on each system will be slightly different).

On sql1, my.cnf should look like the following:

      ############################################################################
      [client]
      port = 3306
      socket = /var/lib/mysql/mysql.sock
       
      [mysqld_safe]
      socket = /var/lib/mysql/mysql.sock
      nice = 0
      log = /var/log/mysqld.log
      log-error = /var/log/mysqld.log
      err-log = /var/log/mysqld.log
      log-warnings = 2
       
      [mysqld]
      user = mysql
      pid-file = /var/run/mysqld/mysqld.pid
      socket = /var/lib/mysql/mysql.sock
      port = 3306
      basedir = /usr
      datadir = /var/lib/mysql
      tmpdir = /tmp
      skip-external-locking
      bind-address = 0.0.0.0
      key_buffer_size = 512M
      table_cache = 512
      myisam_sort_buffer_size = 100M
      max_connections = 500
      max_connect_errors = 1000
      max_allowed_packet = 16M
      thread_stack = 192K
      thread_cache_size = 8
      myisam-recover = BACKUP
      query_cache_limit = 1M
      query_cache_size = 16M
      log_error = /var/log/mysqld.log
      log-warning = 2
      expire_logs_days = 14
      max_binlog_size = 100M
       
      # If innodb is used
      innodb_flush_log_at_trx_commit = 1
       
      # For replication. **Note** server-id and auto_increment_offset values!
      server_id = 1
      auto_increment_offset = 1
      auto_increment_increment = 10
      master-host = sql2.example.com
      master-user = replication
      master-password = secret_pw
      sync_binlog = 1
      log-bin = mysql-bin
      log-slave-updates
      relay-log = sql1-relay-bin
      slave_exec_mode = IDEMPOTENT
       
      # slave-skip-errors = 1062
      # replicate-ignore-table = test.test
      ############################################################################ 

On sql2, my.cnf should look like the following:

      ############################################################################
      [client]
      port = 3306
      socket = /var/lib/mysql/mysql.sock
       
      [mysqld_safe]
      socket = /var/lib/mysql/mysql.sock
      nice = 0
      log = /var/log/mysqld.log
      log-error = /var/log/mysqld.log
      err-log = /var/log/mysqld.log
      log-warnings = 2
       
      [mysqld]
      user = mysql
      pid-file = /var/run/mysqld/mysqld.pid
      socket = /var/lib/mysql/mysql.sock
      port = 3306
      basedir = /usr
      datadir = /var/lib/mysql
      tmpdir = /tmp
      skip-external-locking
      bind-address = 0.0.0.0
      key_buffer_size = 512M
      table_cache = 512
      myisam_sort_buffer_size = 100M
      max_connections = 500
      max_connect_errors = 1000
      max_allowed_packet = 16M
      thread_stack = 192K
      thread_cache_size = 8
      myisam-recover = BACKUP
      query_cache_limit = 1M
      query_cache_size = 16M
      log_error = /var/log/mysqld.log
      log-warning = 2
      expire_logs_days = 14
      max_binlog_size = 100M
       
      # If innodb is used
      innodb_flush_log_at_trx_commit = 1
       
      # For replication. **Note** server-id and auto_increment_offset values!
      server_id = 2
      auto_increment_offset = 2
      auto_increment_increment = 10
      master-host = sql1.example.com
      master-user = replication
      master-password = secret_pw
      sync_binlog = 1
      log-bin = mysql-bin
      log-slave-updates
      relay-log = sql2-relay-bin
      slave_exec_mode = IDEMPOTENT
       
      # slave-skip-errors = 1062
      # replicate-ignore-table = test.test
      ############################################################################

4) On sql1 start the mysqld service and ignore any errors that may indicate that that the master-host options have been deprecated and will be removed in a future release. These errors are indeed correct, however, on the initialization of the multi-master replication database the options included in the my.cnf file will be used to generate an appropriate /var/lib/mysql/master.info file which then takes precedence over the options in my.cnf and the errors will go away in subsequent restarts.

5) Start the mysql client on sql1 and issue the following commands:

      mysql> grant replication slave, replication client on *.* to 'replication'@'sql2.example.com' identified by 'secret_pw';
      mysql> grant replication slave, replication client on *.* to'replication'@'sql1.example.com' identified by 'secret_pw';
      mysql> flush privileges;

6) Remain logged into the mysql client and issue the following command to obtain the log file name and log position - record these values. (NB: do NOT terminate the mysql client session after you complete these commands - remain logged in to maintain the read lock):

      mysql> slave stop;
      mysql> flush tables with read lock;
      mysql> show master status;

7) Start another login session into sql1 as root and rsync the mysql database directory from sql1 to sql2, excluding and deleting several files that are node specific:

      [root sql1 ]# rsync -av -e ssh --delete --exclude=*relay-bin* --exclude=mysql-bin.* --exclude=*.info /var/lib/mysql/sql2.example.com:/var/lib/mysql 

8) You may now safely log out of the mysql client on sql1.

9) On sql2, start the mysqld:

      service mysqld start 

10) Start a mysql client session on sql2 and perform the following commands using the log file name and position recorded, above. NB: punctuation is very important:

      mysql> slave stop; 
      mysql> change master to master_log_file='<recorded log file name, above>', master_log_pos=<recorded log position, above>; # <- note lack of quotes mysql> start slave;

11) As with sql1, issue the following command to obtain the log file name and log position - record these values. (NB: do NOT terminate the mysql client session after you complete these commands - remain logged in to maintain the read lock):

      mysql> flush tables with read lock;
      mysql> show master status;

12) Log into sql1, start a mysql client session, and issue the following commands:

      mysql> slave stop;
      mysql> change master to master_log_file='<recorded log file name, above>', master_log_pos=<recorded log position, above>; # <- note lack of quotes mysql> start slave;

13) It is now safe to exit any mysql client sessions that may be open to unlock the databases.

14) Each database should now be in sync with each other, but to verify this, start a mysql client session on each system and issue the following command:

      mysql> show slave status\G; 

15) Look at the values of Slave_IO_State, Slave_IO_Running, Slave_SQL_Running, and Seconds_Behind_Master. There should be no errors. If there are errors, then re-start the procedure at step 6.

16) Additionally, create a test table and input some data on both systems. On sql1, run:

      mysql> create table test.tester ( col1 int not null auto_increment, col2 int, primary key (col1) );
      mysql> insert into tester (col2) values ('1'),('3'),('5');
      mysql> select * from test.tester; 

On sql2, run:

      mysql> select * from test.tester;
      mysql> insert into tester (col2) values ('2'),('4'),('6');
      mysql> select * from test.tester; 

The select output should be the same on each system.

17) Proceed with granting access to the appropriate OpenStack users such as nova, keystone, glance, quantum, cinder, etc.

## 3. Piranha Deployment with Direct Routing

1) On lb1 and lb2, install the piranha load balancing packages:

       yum install piranha  

2) Create the file /usr/local/bin/check_tcp_port.sh with the following contents, and make it executable:

      ############################################################################
      #!/bin/sh
       
      if [ -z $1 ] && [ -z $2 ]; then
        echo "Usage: $0 addr port"
        exit 1
      fi
       
      ` TEST=`/usr/bin/nc -zvv $1 $2 2>/dev/null | grep -c succeed` `
       
      if [ $TEST == 1 ]; then
        echo "OK"
      else
        echo "FAIL"
      fi
       
      exit 0
      ############################################################################
        

3) Edit the /etc/sysconfig/ha/lvs.cf file on each load balancer and make it look like the following:

      serial_no = 2013042401
      service = lvs
      primary = 10.0.0.1
      service = lvs
      rsh_command = ssh
      backup_active = 1
      backup = 10.0.0.2
      heartbeat = 1
      heartbeat_port = 539
      keepalive = 6
      deadtime = 18
      debug_level = NONE
      monitor_links = 1
      syncdaemon = 1
      hard_shutdown = 0
      network = direct
       
      virtual openstack_mysql_3306 {
        active = 1
        address = 10.0.0.3 eth0:6
        vip_nmask = 255.255.240.0
        port = 3306
        persistent = 60
        pmask = 255.255.240.0
        use_regex = 0
        send_program = "/usr/local/bin/check_tcp_port.sh %h 3306"
        send = "\n"
        expect = "OK"
        load_monitor = none
        scheduler = wlc
        protocol = tcp
        timeout = 5
        reentry = 10
        quiesce_server = 1
        server sql1.example.com {
        address = 10.0.0.4
        active = 1
        weight = 1
        }
        server sql2.example.com {
        address = 10.0.0.5
        active = 1
        weight = 1
        }
      }
       

4) Shutdown the pulse service on lb2 and restart the pulse service on lb1.

      service pulse restart
        

5) Verify that service is working by running the following command on lb1:

      ipvsadm -Ln
        

The output should look like this:

      IP Virtual Server version 1.2.1 (size=4096)
      Prot LocalAddress:Port Scheduler Flags
        -> RemoteAddress:Port Forward Weight ActiveConn InActConn
      TCP 10.0.0.3:3306 wlc persistent 60 mask 255.255.240.0
        -> 10.0.0.4:3306 Route 1 0 0
        -> 10.0.0.5:3306 Route 1 0 0
        

Also, tail /var/log/messages on the load balancers and look for the following:

      Apr 3 15:02:13 lb1.example.com nanny[29298]: [ active ] making 10.0.0.5:3306 available
        

6) From a client on the network (NB: NOT the load balancer), connect to the service IP of the sql server:

      [root client ]# mysql -u nova -h 10.0.0.3 -p
        

If this is successful, then congratulations, you have a fully functioning load-balanced multi-master mysql replication database system for your Red Hat OpenStack Cloud.
