---
title: Setting-up-HA-of-Nova
authors: kashyap
wiki_title: Setting-up-HA-of-Nova
wiki_revision_count: 2
wiki_last_updated: 2014-04-15
---

## Set up HA of Nova

This document outlines configuration details for setting up HA of Nova.

Install relevant packages:

    $ yum   install -y openstack-nova-console openstack-nova-novncproxy \
      openstack-utils openstack-nova-api openstack-nova-conductor \
      openstack-nova-scheduler python-cinderclient python-memcached

Configure `nova.conf` and `api-paste.ini`:

    $ openstack-config --set /etc/nova/nova.conf DEFAULT memcached_servers rhos4-memcache1:11211,rhos4-memcache2:11211
    $ openstack-config  --set /etc/nova/nova.conf DEFAULT vncserver_proxyclient_address $(ip  addr show dev eth1 scope global | grep inet | sed -e 's#.*inet ##g' -e  's#/.*##g')
    $ openstack-config --set /etc/nova/nova.conf DEFAULT vncserver_listen 0.0.0.0
    $ openstack-config --set /etc/nova/nova.conf DEFAULT novncproxy_base_url http://mrg-01.mpc.lab.eng.bos.redhat.com:6080/vnc_auto.html
    $ openstack-config --set /etc/nova/nova.conf DEFAULT sql_connection mysql://nova:novatest@vip-mysql/nova
    $ openstack-config --set /etc/nova/nova.conf DEFAULT auth_strategy keystone
    $ openstack-config --set /etc/nova/nova.conf DEFAULT rpc_backend nova.openstack.common.rpc.impl_qpid
    $ openstack-config --set /etc/nova/nova.conf DEFAULT qpid_hostname vip-qpid
    $ openstack-config --set /etc/nova/nova.conf DEFAULT qpid_heartbeat 2
    $ openstack-config --set /etc/nova/nova.conf DEFAULT metadata_host vip-nova
    $ openstack-config --set /etc/nova/nova.conf DEFAULT metadata_listen 0.0.0.0
    $ openstack-config --set /etc/nova/nova.conf DEFAULT metadata_listen_port 8775
    $ openstack-config --set /etc/nova/nova.conf DEFAULT service_neutron_metadata_proxy True
    $ openstack-config --set /etc/nova/nova.conf DEFAULT neutron_metadata_proxy_shared_secret metatest
    $ openstack-config --set /etc/nova/nova.conf DEFAULT glance_host vip-glance
    $ openstack-config --set /etc/nova/nova.conf DEFAULT network_api_class nova.network.neutronv2.api.API
    $ openstack-config --set /etc/nova/nova.conf DEFAULT neutron_url http://vip-neutron:9696/
    $ openstack-config --set /etc/nova/nova.conf DEFAULT neutron_admin_tenant_name services
    $ openstack-config --set /etc/nova/nova.conf DEFAULT neutron_admin_username neutron
    $ openstack-config --set /etc/nova/nova.conf DEFAULT neutron_admin_password neutrontest
    $ openstack-config --set /etc/nova/nova.conf DEFAULT neutron_admin_auth_url http://vip-keystone:35357/v2.0
    $ openstack-config --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver
    $ openstack-config --set /etc/nova/nova.conf DEFAULT libvirt_vif_driver nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver

    $ openstack-config --set /etc/nova/api-paste.ini filter:authtoken auth_host vip-keystone
    $ openstack-config --set /etc/nova/api-paste.ini filter:authtoken admin_tenant_name services
    $ openstack-config --set /etc/nova/api-paste.ini filter:authtoken admin_user compute
    $ openstack-config --set /etc/nova/api-paste.ini filter:authtoken admin_password novatest

Configure Keystone:

    $ ./keystonerc_admin
    $ keystone user-create --name compute --pass novatest
    $ keystone user-role-add --user compute --role admin --tenant services
    $ keystone service-create --name compute --type compute --description &quot;OpenStack Compute Service&quot;
    $ keystone endpoint-create  --service compute --publicurl &quot;http://vip-nova:8774/v2/$(tenant_id)s&quot; --adminurl &quot;http://vip-nova:8774/v2/$(tenant_id)s&quot; --internalurl &quot;http://vip-nova:8774/v2/$(tenant_id)s&quot;
