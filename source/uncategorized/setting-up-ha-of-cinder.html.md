---
title: Setting-up-HA-of-Cinder
authors: kashyap
wiki_title: Setting-up-HA-of-Cinder
wiki_revision_count: 2
wiki_last_updated: 2014-04-22
---

## Setting up HA of Cinder

This document outlines configuration details for setting up HA of Cinder.

Install the RPMs:

    yum install -y openstack-cinder openstack-utils openstack-selinux python-memcached

Setup `cinder.conf`:

    openstack-config --set /etc/cinder/cinder.conf DEFAULT auth_strategy keystone
    openstack-config --set /etc/cinder/cinder.conf keystone_authtoken auth_host vip-keystone
    openstack-config --set /etc/cinder/cinder.conf keystone_authtoken admin_tenant_name services
    openstack-config --set /etc/cinder/cinder.conf keystone_authtoken admin_user cinder
    openstack-config --set /etc/cinder/cinder.conf keystone_authtoken admin_password cindertest
    openstack-config --set /etc/cinder/cinder.conf DEFAULT rpc_backend cinder.openstack.common.rpc.impl_qpid
    openstack-config --set /etc/cinder/cinder.conf DEFAULT qpid_hostname vip-qpid
    openstack-config --set /etc/cinder/cinder.conf DEFAULT qpid_heartbeat 2
    openstack-config --set /etc/cinder/cinder.conf DEFAULT sql_connection mysql://cinder:cindertest@vip-mysql/cinder
    openstack-config --set /etc/cinder/cinder.conf DEFAULT max_retries -1
    openstack-config --set /etc/cinder/cinder.conf DEFAULT retry_interval 1
    openstack-config --set /etc/cinder/cinder.conf DEFAULT glance_host vip-glance
    openstack-config --set /etc/cinder/cinder.conf keystone_authtoken memcached_servers rdo4-memcache1:11211,rdo4-memcache2:11211

Create a Cinder NFS export:

    mkdir -p /srv/rdo/cinder
    cat &gt; /etc/cinder/nfs_exports &lt;&lt; EOF
    mrg-01:/srv/rdo/cinder
    EOF

    chown root:cinder /etc/cinder/nfs_exports
    chmod 0640 /etc/cinder/nfs_exports

Add the NFS export

    openstack-config --set /etc/cinder/cinder.conf DEFAULT nfs_shares_config /etc/cinder/nfs_exports
    openstack-config --set /etc/cinder/cinder.conf DEFAULT nfs_sparsed_volumes true
    openstack-config --set /etc/cinder/cinder.conf DEFAULT nfs_mount_options v3
    openstack-config --set /etc/cinder/cinder.conf DEFAULT volume_driver cinder.volume.drivers.nfs.NfsDriver

Add Ceilometer hooks in `cinder.conf`:

    openstack-config --set /etc/cinder/cinder.conf DEFAULT notification_driver cinder.openstack.common.notifier.rpc_notifier
    openstack-config --set /etc/cinder/cinder.conf DEFAULT rpc_backend cinder.openstack.common.rpc.impl_qpid
    openstack-config --set /etc/cinder/cinder.conf DEFAULT control_exchange cinder

On first node of Cinder (rdo-cinder1) set Keystone cre:

    . /srv/rdo/configs/keystonerc_admin
    keystone user-create --name cinder --pass cindertest
    keystone user-role-add --user cinder --role admin --tenant services
    keystone service-create --name cinder --type volume --description &quot;Cinder Volume Service&quot;
    keystone endpoint-create --service cinder --publicurl &quot;http://vip-cinder:8776/v1/$(tenant_id)s&quot; --adminurl &quot;http://vip-cinder:8776/v1/$(tenant_id)s&quot; --internalurl &quot;http://vip-cinder:8776/v1/$(tenant_id)s&quot;

Configure mysql

    mysql --user=root --password=mysqltest --host=vip-mysql
    CREATE DATABASE cinder;
    GRANT ALL ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'cindertest';
    FLUSH PRIVILEGES;
    quit

Sync Cinder database:

    su cinder -s /bin/sh -c &quot;cinder-manage db sync&quot;

Configure `pacemaker` on both nodes of Cinder (rdo-cinder1|rdo-cinder2):

    chkconfig pacemaker on
    pcs cluster setup --name rdo4-cinder rdo4-cinder1 rdo4-cinder2
    pcs cluster start

    sleep 30

    pcs stonith create cinder1-fence fence_xvm multicast_address=225.0.0.7 pcmk_host_list=rdo4-cinder1

    pcs stonith create cinder2-fence fence_xvm multicast_address=225.0.0.8 pcmk_host_list=rdo4-cinder2

    pcs resource create cinder-api lsb:openstack-cinder-api --clone
    pcs resource create cinder-scheduler lsb:openstack-cinder-scheduler --clone
    pcs resource create cinder-volume lsb:openstack-cinder-volume --clone

    pcs constraint order start cinder-api-clone then cinder-scheduler-clone
    pcs constraint colocation add cinder-scheduler with cinder-api
    pcs constraint order start cinder-scheduler-clone then cinder-volume-clone
    pcs constraint colocation add cinder-volume with cinder-scheduler

Do a simple Cinder test:

    . /srv/rdo/configs/keystonerc_admin

    cinder list
    cinder create 10
    cinder list
    cinder delete $(cinder list | grep available | awk '{print $2}')
    cinder list
