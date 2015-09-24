---
title: Setting-up-HA-of-Neutron
authors: kashyap
wiki_title: Setting-up-HA-of-Neutron
wiki_revision_count: 1
wiki_last_updated: 2014-04-18
---

## Setting-up-HA-of-Neutron

This document outlines configuration details for setting up HA of Neutron.

On both nodes of Neutron (rdo-neutron1|rdo-neutron2), install the relevant RPMs:

    $ yum install -y openstack-neutron openstack-neutron-openvswitch openstack-utils openstack-selinux

Configure Neutron `api-paste.ini`:

    openstack-config --set /etc/neutron/api-paste.ini filter:authtoken auth_host vip-keystone
    openstack-config --set /etc/neutron/api-paste.ini filter:authtoken admin_tenant_name services
    openstack-config --set /etc/neutron/api-paste.ini filter:authtoken admin_user neutron
    openstack-config --set /etc/neutron/api-paste.ini filter:authtoken admin_password neutrontest

Configure `neutron.conf`:

    openstack-config --set /etc/neutron/neutron.conf DEFAULT auth_strategy keystone
    openstack-config --set /etc/neutron/neutron.conf keystone_authtoken auth_host vip-keystone
    openstack-config --set /etc/neutron/neutron.conf keystone_authtoken admin_tenant_name services
    openstack-config --set /etc/neutron/neutron.conf keystone_authtoken admin_user neutron
    openstack-config --set /etc/neutron/neutron.conf keystone_authtoken admin_password neutrontest
    openstack-config --set /etc/neutron/neutron.conf DEFAULT rpc_backend neutron.openstack.common.rpc.impl_qpid
    openstack-config --set /etc/neutron/neutron.conf DEFAULT qpid_hostname vip-qpid
    openstack-config --set /etc/neutron/neutron.conf DEFAULT qpid_heartbeat 2
    openstack-config --set /etc/neutron/neutron.conf database connection mysql://neutron:neutrontest@vip-mysql:3306/ovs_neutron
    openstack-config --set /etc/neutron/neutron.conf DEFAULT core_plugin neutron.plugins.openvswitch.ovs_neutron_plugin.OVSNeutronPluginV2

Add a symlink:

    ln -s /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini /etc/neutron/plugin.ini

Configure Neutron `plugin.ini`:

    openstack-config --set /etc/neutron/plugin.ini DATABASE sql_connection mysql://neutron:neutrontest@vip-mysql/ovs_neutron
    openstack-config --set /etc/neutron/plugin.ini OVS enable_tunneling True
    openstack-config --set /etc/neutron/plugin.ini OVS tunnel_id_ranges 1:1000
    openstack-config --set /etc/neutron/plugin.ini OVS tenant_network_type gre

Setup Ceilometer:

    openstack-config --set /etc/neutron/neutron.conf DEFAULT notification_driver neutron.openstack.common.notifier.rpc_notifier

On the first node of Neutron (rdo-neutron1):

    . /srv/rdo/configs/keystonerc_admin
    keystone user-create --name neutron --pass neutrontest
    keystone user-role-add --user neutron --role admin --tenant services
    keystone service-create --name neutron --type network --description &quot;OpenStack Networking Service&quot;
    keystone endpoint-create --service neutron --publicurl &quot;http://vip-neutron:9696&quot; --adminurl &quot;http://vip-neutron:9696&quot; --internalurl &quot;http://vip-neutron:9696&quot;

    mysql --user=root --password=mysqltest --host=vip-mysql

    CREATE DATABASE ovs_neutron;
    GRANT ALL ON ovs_neutron.* TO 'neutron'@'%' IDENTIFIED BY 'neutrontest';
    FLUSH PRIVILEGES;
    quit

Update Neutron database with `neutron-db-manage` (required when installing the DB manually):

    neutron-db-manage  --config-file /usr/share/neutron/neutron-dist.conf --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini stamp  havana

Configure `pacemaker` on both the nodes (rdo-neutron1|rdo-neutron2):

    chkconfig pacemaker on
    pcs cluster setup --name rdo-neutron rdo-neutron1 rdo-neutron2
    pcs cluster start

    sleep 30

    pcs stonith create neutron1-fence fence_xvm multicast_address=225.0.0.7 pcmk_host_list=rdo-neutron1

    pcs stonith create neutron2-fence fence_xvm multicast_address=225.0.0.8 pcmk_host_list=rdo-neutron2

    pcs property set start-failure-is-fatal=false

    pcs resource create neutron-db-check lsb:neutron-db-check meta failure-timeout=5 --clone
    pcs resource create neutron-server lsb:neutron-server

    pcs constraint order start neutron-db-check then neutron-server
    pcs constraint colocation add neutron-server with neutron-db-check

As a test, create your first network.

Source the Keystone RC credentials:

    . /srv/rdo/configs/keystonerc_admin

Create a private network, a subnet, an external network, router, set the gateway interface, set the router interface:

    neutron net-create internal_lan
    neutron subnet-create --ip_version 4 --gateway 192.168.100.1 --name &quot;internal_subnet&quot; internal_lan 192.168.100.0/24
    neutron net-create public_lan --router:external=True
    neutron  subnet-create --gateway 10.16.151.254 --allocation-pool  start=10.16.144.76,end=10.16.144.83 --disable-dhcp --name public_subnet  public_lan 10.16.144.0/21
    neutron router-create router
    neutron router-gateway-set router public_lan
    neutron router-interface-add router internal_subnet
