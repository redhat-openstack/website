---
title: Upgrading RDO To Icehouse
authors: dansmith
wiki_title: Upgrading RDO To Icehouse
wiki_revision_count: 4
wiki_last_updated: 2014-04-24
---

# Upgrading RDO To Icehouse

The Icehouse release of OpenStack brings new options for upgrades, as well as a few additional inter-service dependencies that must be managed.

## Nova/Neutron Upgrade Interaction

In Icehouse, Nova and Neutron collaborate on instance booting when using the libvirt hypervisor driver. This means that each service depends on a new feature of the other, which in turn means that care must be taken when crossing this upgrade boundary. The recommended method is:

1.  Upgrade the Nova controller infrastructure
2.  Upgrade Neutron and configure it to send events to Nova
3.  Upgrade Nova compute nodes

This will ensure that a suitably new Nova API will support the event delivery from Neutron prior to Neutron actually sending them. When compute nodes are upgraded from Havana to Icehouse code, events will be sent properly to the new compute nodes as they begin requiring them. If you decide not to pursue the "live" upgrade option in Nova which separates the upgrade of controller and compute nodes, you can disable the delivery of the events from the Neutron side, or disable the requirement on the Nova side.

## Upgrade Methods: Offline or Live Upgrade?

Icehouse brings the ability to perform a limited live upgrade of a Havana Nova deployment. This means that controller infrastructure can be upgraded independently from the compute nodes, minimizing service disruption. Consider the following to determine which is right for you:

<table border="1">
<tr>
<td>
 

</td>
<td>
<b>Offline</b>

</td>
<td>
<b>Live</b>

</td>
</tr>
<tr>
<td>
<b>Pro</b>

</td>
<td>
Potentially less-risky, well-tested, fewer moving parts

</td>
<td>
Minimal service disruption,
Upgrade of base OS is easier

</td>
</tr>
<tr>
<td>
<b>Con</b>

</td>
<td>
Requires varying levels of service disruption,
Requires all hosts to be on the same version of the base OS and OpenStack Release

</td>
<td>
New technology, less-tested

</td>
</tr>
</table>
### Offline Upgrade Options

With the caveat above about the Nova/Neutron interaction in mind, the [same offline upgrade options](Upgrading_RDO) exist for Icehouse as Havana.

### Live Upgrade Option

To do a Live Upgrade of Nova, first upgrade all the services except for Nova and Neutron per [these instructions](Upgrading_RDO#Option_2:_Service-by-Service_Upgrade) from Havana.

#### Upgrade Nova Controller Services

The next step is to upgrade the Nova controller services. On each controller node, disable all the services (note: don't do this on any nodes running nova-compute!):

      cd /etc/init.d
      for service in openstack-nova-*; do service $service stop; done

Next, upgrade Nova to the Icehouse release:

      # Make sure you have upgraded the RDO release to icehouse
`yum install `[`http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm`](http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm)
      yum -y update *nova*

From one node, upgrade the database schema:

      nova-manage db sync

Before starting the controller services, we need to cap the compute RPC API version at a level that will still be understood by the older Havana compute nodes. Find the following section and key in /etc/nova/nova.conf and make sure the version is set to "icehouse-compat":

      [upgrade_levels]
      # Set a version cap for messages sent to compute services. If
      # you plan to do a live upgrade from havana to icehouse, you
      # should set this option to "icehouse-compat" before beginning
      # the live upgrade procedure. (string value)
      compute=icehouse-compat

**Note** that if you plan to do any instance migrations between compute nodes during your upgrades, you must make this configuration change on each of your Havana compute nodes as well (don't forget to restart openstack-nova-compute afterwards!).

At this point, you can restart the controller services:

      cd /etc/init.d
      for service in openstack-nova-*; do service $service start; done

#### Upgrade Neutron

If you are not running Neutron, you can skip this step.

To upgrade Neutron, disable all neutron services (including your compute nodes, which are running agents):

      cd /etc/init.d
      for service in openstack-neutron-*; do service $service stop; done

Upgrade the packages:

      yum -y update *neutron*

From one of your Neutron nodes, upgrade the database schema:

      neutron-manage db_sync

On the Neutron server, configure Neutron to send events to Nova. In /etc/neutron/neutron.conf:

      [DEFAULT]
      notify_nova_port_status_change=true
      notify_nova_on_port_data_changes=true
`nova_url=`[`http://mynova:myport/v2`](http://mynova:myport/v2)
      nova_admin_username=myserviceuser
      nova_admin_password=myservicepass
      nova_admin_tenant_id=myservicetenant
`nova_admin_auth_url=`[`http://mykeystone:myport/v2.0`](http://mykeystone:myport/v2.0)
