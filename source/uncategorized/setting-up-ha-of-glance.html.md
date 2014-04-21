---
title: Setting-up-HA-of-Glance
authors: kashyap
wiki_title: Setting-up-HA-of-Glance
wiki_revision_count: 3
wiki_last_updated: 2014-04-22
---

## Setting up HA of Glance

This document outlines configuration details of setting up HA of Glance.

On both nodes of Neutron (rdo-glance1|rdo-glance2), install the relevant RPMs:

    $ yum install -y openstack-glance openstack-utils openstack-selinux

Setup `glance-api.conf`:

    openstack-config --set /etc/glance/glance-api.conf DEFAULT sql_connection mysql://glance:glancetest@vip-mysql/glance

    openstack-config --set /etc/glance/glance-api.conf paste_deploy flavor keystone
    openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_host vip-keystone
    openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_port 35357
    openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_protocol http
    openstack-config --set /etc/glance/glance-api.conf keystone_authtoken admin_tenant_name services
    openstack-config --set /etc/glance/glance-api.conf keystone_authtoken admin_user glance
    openstack-config --set /etc/glance/glance-api.conf keystone_authtoken admin_password glancetest
    openstack-config --set /etc/glance/glance-api.conf DEFAULT qpid_hostname vip-qpid
    openstack-config --set /etc/glance/glance-api.conf DEFAULT qpid_heartbeat 2
    openstack-config --set /etc/glance/glance-api.conf DEFAULT registry_host vip-glance

Setup `glance-registry.conf`:

    openstack-config --set /etc/glance/glance-registry.conf DEFAULT sql_connection mysql://glance:glancetest@vip-mysql/glance
    openstack-config --set /etc/glance/glance-registry.conf paste_deploy flavor keystone
    openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_host vip-keystone
    openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_port 35357
    openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_protocol http
    openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken admin_tenant_name services
    openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken admin_user glance
    openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken admin_password glancetest

Set a Ceilometer hook:

    openstack-config --set /etc/glance/glance-api.conf DEFAULT notifier_strategy qpid

On the first node of Glance (rdo-glance1), source the Keystone credentials and create a Keystone user, associate a role, and crea

    . /srv/rhos/configs/keystonerc_admin

    keystone user-create --name glance --pass glancetest
    keystone  user-role-add --user glance --role admin --tenant services
    keystone service-create --name glance --type image --description &quot;Glance Image Service&quot;

    keystone endpoint-create --service glance --publicurl &quot;http://vip-glance:9292&quot; --adminurl &quot;http://vip-glance:9292&quot; --internalurl &quot;http://vip-glance:9292&quot;

Configure mysql:

    mysql --user=root --password=mysqltest --host=vip-mysql

    CREATE DATABASE glance;
    GRANT ALL ON glance.* TO 'glance'@'%' IDENTIFIED BY 'glancetest';
    quit

Perform Glance db_sync:

    su glance -s /bin/sh -c &quot;glance-manage db_sync&quot;

On both nodes of Glance (rdo-glance1|rdo-glance2), configure `pacemaker`:

    chkconfig pacemaker on
    pcs cluster setup --name rdo-glance rdo-glance1 rdo-glance2
    pcs cluster start

    sleep 30

    pcs stonith create glance1-fence fence_xvm multicast_address=225.0.0.7 pcmk_host_list=rdo-glance1

    pcs stonith create glance2-fence fence_xvm multicast_address=225.0.0.8 pcmk_host_list=rdo-glance2

    mkdir -p /srv/rhos/glance

    pcs  resource create glance-fs Filesystem device=&quot;mrg-01:/srv/rhos/glance&quot;  directory=&quot;/var/lib/glance&quot; fstype=&quot;nfs&quot; options=&quot;v3&quot; --clone

    chown glance:nobody /var/lib/glance
    pcs resource create glance-registry lsb:openstack-glance-registry --clone
    pcs resource create glance-api lsb:openstack-glance-api --clone

    pcs constraint order start glance-fs-clone then glance-registry-clone
    pcs constraint colocation add glance-registry with glance-fs
    pcs constraint order start glance-registry-clone then glance-api-clone
    pcs constraint colocation add glance-api with glance-registry

Do a test by importing an image into Glance:

    wget -c \
    http://cloud.fedoraproject.org/fedora-latest.x86_64.qcow2

    . /srv/rhos/configs/keystonerc_admin

    glance image-create --name fedora20 --is-public true \
    --disk-format qcow2 --container-format bare \
    &lt; Fedora-20.qcow2
