---
title: Tunings and tweaks
authors: afazekas, lpeer, mwagner
wiki_title: Tunings and tweaks
wiki_revision_count: 8
wiki_last_updated: 2015-03-11
---

# Tunings and tweaks

This page has been created to track changes to the underlying systems and the default configurations needed in order to enable greater scalability for OpenStack. The goal here is to share the knowledge until the out of the box defaults can be changed. If that won't happen, then many of the items here should probably get put into end user documentation.

**`General`**

You will hit OS system limits as you scale (this is a big hammer, will need some tightening for security) Increase number of open files on the messing and database services (EL6) edit /etc/security/limits.conf:

         mysql    soft nofile 16384
         mysql   hard nofile 16384
         qpidd   soft nofile 16384
         qpidd   hard nofile 16384
         rabbitmq   soft nofile 16384
         rabbitmq  hard nofile 16384
         postgres soft nofile 16384
         postgres hard nofile 16384
         Increase number of procs
         /etc/security/limits.d/90-nproc.conf
         *          soft    nproc     10240
         root       soft    nproc     unlimited

Systemd (EL7, Fedora) uses per service limits and does not uses /etc/security/limits.conf . One possible way for setting a per service limit is creating a new service target in the /etc/systemd/system/ which will inherit and override from the packaged version of the target.

/etc/systemd/system/rabbitmq-server.service:

       .include /lib/systemd/system/rabbitmq-server.service
       [Service]
        LimitNOFILE=16384

Instead of creating an overlapping service, just extending it is also possible:

      /etc/systemd/system/mariadb.service.d/limits.conf
      [Service]
      LimitNOFILE = 16384

If the service already enabled and the service link points to the packaged version of the script, you need to disable and enable the service:

       systemctl  stop rabbitmq-server
       systemctl disable rabbitmq-server
       systemctl enable rabbitmq-server
       systemctl  start rabbitmq-server

The systemd config files need to be reload after configuration changes:

       systemctl daemon-reload

HAProxy requires to configure the file descriptor limits inside it's config file. <http://cbonte.github.io/haproxy-dconv/configuration-1.5.html#3.2-maxconn>

By default lots of stuff seems to go to /var, if possible put /var on a bigger, faster drive Try using SSD if available

**Neutron**

          to increase the number of networks and similar components you can run this from the command line

         where tenant-id is the uuid of the openstack tenant running the test

         neutron quota-update  --tenant-id  $admin  --network -1 --subnet  -1 --port  -1 --router -1 --floatingip -1 --security_group -1 --security_group_rule -1
         # add --vip -1 --pool -1  if needed
        The -1 means unlimited.

         Use jumbo frames for interfaces carrying GRE/VXLAN traffic:
         Compute node(s):
`      echo MTU=`<MTU>` >> /etc/sysconfig/network-scripts/ifcfg-`<interface>
            network_device_mtu=`<Guest MTU>` (50b less than tunnel interface for vxaln, 28b less for gre ) in the nova.conf file 
         Network node(s):
`      echo MTU=`<MTU>` >> /etc/sysconfig/network-scripts/ifcfg-`<interface>
            echo dnsmasq_config_file=/etc/neutron/dnsmasq-neutron.conf >> /etc/neutron/dhcp_agent.ini
            echo dhcp-option-force=26,`<MTU>` >> /etc/neutron/dnsmasq-neutron.conf
         Disable secure rootwrap:
         Change root_helper in /etc/neutron/neutron.conf and in all used neutron ini file.
             [agent]
             root_helper = sudo
         Edit the sudores file to allow neutron to use sudo without password for the commands required by neutron.
         It makes the command execution faster, but without filtering it is less secure.
         Just by the sudoers files you cannot property filter an evil command patters like this: ip netns exec net-ns evil_command. 

**Compute node**

         Ensure tuned is in place 

         tuned-adm list

**\1**

         There is a limit to how many rows get returned from queries

         /etc/nova/nova.conf

         osapi_max_limit=10000

         Increase defaults for mysql

            increase number of connections -

in /etc/my.cnf

         max_connections = 15360
         innodb_buffer_pool_size = 10G
         innodb_flush_method = O_DIRECT
         innodb_file_per_table
         innodb_flush_log_at_trx_commit = 0
         innodb_log_file_size=1500M
         innodb_log_files_in_group=2 

Consider using [thread_handling=pool-of-threads](https://mariadb.com/kb/en/mariadb/documentation/optimization-and-tuning/buffers-caches-and-threads/thread-pool/threadpool-in-55/) option when mariadb needs to handle large number of not too active connection. Mariadb by default creates a thread for every connection, which consumes a significant amount a memory when it needs to handle thousands of connections.

Avoid defining charset=utf8 without the use_unicode=0 in the mysql connection strings. <http://docs.sqlalchemy.org/en/rel_0_9/dialects/mysql.html#unicode>

        rabbitmq:
        if your erlang version support the hipe compile you can enable it in   /etc/rabbitmq/rabbitmq.config.
`  `[`http://www.fpaste.org/125147/40791409`](http://www.fpaste.org/125147/40791409)

**Keystone**

         Reduce default token duration on Keystone from 1 day  (86400) to 1 hour (3600)

         Set expiration to 3600 in [token]  section in keystone.conf file on controller. 

         Update revocation_cache_time from 1 to 300 with auth_token middleware. Till this is not changed in the code one need to update the each service specific file like glance-api.conf and add revocation_cache_time=300  in [keystone_authtoken] section.

        Make sure you have crontab entry for '/usr/bin/keystone-manage token_flush' and it run on at least on one server at least once in every hour.

**Swift**

         swift parameters missing in quickstack params.pp.  As such a foreman based packstack + quickstack deployment initial puppet runs fail to setup a cluster appropriately without adding to /usr/share/openstack-foreman-installer/puppet/modules/quickstack/manifests/params.pp:

         $swift_admin_password

         $swift_shared_secret
