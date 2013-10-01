---
title: Deploying Heat on Havana
authors: dneary, rbowen, shardy
wiki_title: Deploying Heat on Havana
wiki_revision_count: 12
wiki_last_updated: 2013-11-19
---

# Deploying Heat on Havana

## Deploy OpenStack Heat

[Heat](http://wiki.openstack.org/wiki/Heat) provides orchestration of composite cloud applications. Heat is an officially integrated OpenStack project from the Havana release.

> Heat is a service to orchestrate multiple composite cloud applications using either native "HOT" templates, or AWS CloudFormation template format. Heat provides both an OpenStack-native ReST API and a CloudFormation-compatible Query API.

This guide deploys a composite application (made up of more than a single instance) on the cloud infrastructure. This also involves launch-time customization of the VMs. This guide makes some assumptions:

*   OpenStack has not yet been configured
*   OpenStack is deployed on RHEL 6.4 or Fedora 19

### Installation

Start by installing OpenStack, and Heat via packstack

      $ sudo packstack --allinone --os-neutron-install=n --os-heat-install=y --os-heat-cfn-install=y

You'll get three new services installed: an engine, a native api, and a cloudformation compatible api. You don't have to deploy them all on a single host but for the purpose of this guide it will be fine to do so.

Note that the cloudformation-compatible API is required for some Heat functionality (in particular WaitConditions and metadata update) so you should install it even if you do not care about cloudformation compatibility.

python-heatclient will be installed, which provides python CLI tool "heat", which is used to interact with the heat native API

**Note**: There is currently [A packstack bug](https://bugzilla.redhat.com/show_bug.cgi?id=1007497) which requires the following additional steps, until the fix is released

      $ sudo heat-manage db_sync
      $ sudo systemctl start openstack-heat-engine.service

### Configuration

The application templates can use wait conditions and signaling for the orchestration, Heat needs to create special users to receive the progress data and these users are, by default, given the role of `heat_stack_user`. You can configure the role name in `/etc/heat/heat.conf` or just create a so called role::

      $ keystone role-create --name heat_stack_user

The configuration should now be complete and you can [deploy an application with Heat](deploy an application with Heat)::
