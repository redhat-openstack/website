---
title: Neutron GBP
authors: rkukura
wiki_title: Neutron GBP
wiki_revision_count: 21
wiki_last_updated: 2015-02-08
---

# Neutron GBP

Group Based Policy (GBP) is an optional service plugin for Neutron that provides declarative abstractions for achieving scalable intent-based infrastructure automation. GBP complements the OpenStack networking model with the notion of policies that can be applied between groups of network endpoints.

## GBP Status

The Juno release of Group Based Policy has been developed in StackForge as an add-on service plugin for Neutron, along with a supporting client library and integrations with Horizon and Heat. See the [GBP project wiki](https://wiki.openstack.org/wiki/GroupBasedPolicy) for upstream project details. This page describes installation and configuration of GBP for Juno RDO on Fedora 20, Fedora 21, or EL 7 .

Note that this describes use of the GBP's resource_mapping reference policy driver, which should work with any Neutron core plugin, such as ML2. Policy drivers for Cisco ACI, Nuage VSP and One Convergence NVSD are also included, but will be documented separately by those vendors.

## Configuring GBP

Start with a working Packstack installation with Neutron, such as is described in [Quickstart](/install/quickstart/). If you plan to use Heat with GBP, be sure to generate an answer file, edit it to enable Heat, and use that answer file when running packstack. The remaining steps are all executed as root on the controller node(s) where neutron-server runs. No changes are needed on compute or network nodes when using the resource_mapping policy driver.

### Configuring Neutron

Install the server and client RPMs:

      yum install openstack-neutron-gbp
      yum install python-gbpclient

Stop the Neutron server:

      systemctl stop neutron-server

Edit the Neutron configuration to include the GBP service plugin and its reference policy drivers:

      ` crudini --set /etc/neutron/neutron.conf DEFAULT service_plugins "`crudini --get /etc/neutron/neutron.conf DEFAULT service_plugins`,group_policy" `
      crudini --set /etc/neutron/neutron.conf group_policy policy_drivers "implicit_policy,resource_mapping"

Update the Neutron DB schema to include the GBP tables:

      gbp-db-manage --config-file /usr/share/neutron/neutron-dist.conf --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini upgrade head

Start the Neutron server and check its status:

      systemctl start neutron-server
      systemctl status neutron-server

### Configuring Horizon

Install the RPMs:

       yum install openstack-dashboard-gbp

Restart the web server and check its status:

      systemctl restart httpd
      systemctl status httpd

### Configuring Heat

Assuming Heat is enabled in your RDO deployment, install the RPM:

      yum install openstack-heat-gbp

Edit the Heat configuration to include the GBP plugin:

      crudini --set /etc/heat/heat.conf DEFAULT plugin_dirs "/usr/lib64/heat,/usr/lib/heat,/usr/lib/python2.7/site-packages/gbpautomation/heat"

Restart the Heat engine and check its status:

      systemctl restart openstack-heat-engine
      systemctl status openstack-heat-engine

## Using GBP

Once the neutron server is configured with GBP and running, basic operation can be verified using its API. The following commands are run with normal cloud tenant credentials on a system where the python-gbpclient package has been installed.

Create a group:

      gbp group-create test1 --description "first test group"

The response should show the details of the group.

List the groups:

      gbp group-list

You should see the group you just created.

Verify that implicit L2 and L3 policies were created:

      gbp l2policy-list
      gbp l3policy-list

You should see an L2 policy with the same name as the group, and an L3 policy named "default".

Verify that neutron resources were created:

      neutron net-list
      neutron subnet-list

You should see a network and a subnet with names derived from the group name.

If all is well, you can proceed to create policy rule sets controlling connectivity between groups. Then create policy targets, and to use their ports to create nova instances. The [devstack instructions](https://wiki.openstack.org/wiki/GroupBasedPolicy/InstallDevstack) show this in detail.
