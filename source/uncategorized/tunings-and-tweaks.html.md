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

       You will hit OS system limits as you scale (this is a big hammer, will need some tightening for security)
         Increase number of open files
         edit    /etc/security/limits.conf 
         *    soft nofile 64000
         *    hard nofile 64000
         Increase number of procs
         /etc/security/limits.d/90-nproc.conf
         *          soft    nproc     10240
         root       soft    nproc     unlimited

         opentstack-service restart
         service httpd restart (on controller)

         By default lots of stuff seems to go to /var, if possible put /var on a bigger, faster drive

         Try using SSD if available

**Neutron**

          to increase the number of networks and similar components you can run this from the command line

         where tenant-id is the uuid of the openstack tenant running the test

         neutron quota-update  --tenant-id  $admin  --network 1000 --subnet  1000 --port  5000 --router 1000 --floatingip 1000

         Use jumbo frames for interfaces carrying GRE/VXLAN traffic:
         Compute node(s):
`      echo MTU=`<MTU>` >> /etc/sysconfig/network-scripts/ifcfg-`<interface>
            nova_device_mtu=`<Guest MTU>` (50b less than tunnel interface) in the nova.conf file 
         Network node(s):
`      echo MTU=`<MTU>` >> /etc/sysconfig/network-scripts/ifcfg-`<interface>
            echo dnsmasq_config_file=/etc/neutron/dnsmasq-neutron.conf >> /etc/neutron/dhcp_agent.ini
            echo dhcp-option-force=26,`<MTU>` >> /etc/neutron/dnsmasq-neutron.conf

**Compute node**

         Ensure tuned is in place 

         tuned-adm list

**\1**

         There is a limit to how many rows get returned from queries

         /etc/nova/nova.conf

         osapi_max_limit=10000

         Increase defaults for mysql

            increase number of connections -

         in /etc/my.cnf
         innodb_buffer_pool_size = 10G
         innodb_flush_method = O_DIRECT
         innodb_file_per_table
         innodb_flush_log_at_trx_commit = 0

**Keystone**

         Reduce default token duration on Keystone from 1 day  (86400) to 1 hour (3600)

         Set expiration to 3600 in [token]  section in keystone.conf file on controller. 

         Update revocation_cache_time from 1 to 300 with auth_token middleware. Till this is not changed in the code one need to update the each service specific file like glance-api.conf and add revocation_cache_time=300  in [keystone_authtoken] section.

**Swift**

         swift parameters missing in quickstack params.pp.  As such a foreman based packstack + quickstack deployment initial puppet runs fail to setup a cluster appropriately without adding to /usr/share/openstack-foreman-installer/puppet/modules/quickstack/manifests/params.pp:

         $swift_admin_password

         $swift_shared_secret
