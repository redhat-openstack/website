---
title: TryStack
authors: radez
wiki_title: TryStack
wiki_revision_count: 7
wiki_last_updated: 2014-11-04
---

# Try Stack

## Trystack.org Runs OpenStack RDO

To get started watch this video: [<http://youtu.be/EPZPzXSypl4>](http://youtu.be/EPZPzXSypl4)
This video references RDO Hanava but is still valid for RDO Icehouse currently running on TryStack.

FAQs: <http://openstack.redhat.com/TryStackFAQ>
Information on RDO: <http://openstack.redhat.com>
TryStack Launchpad <http://launchpad.net/trystack>
 How to import a docker image into trystack [TryStackDocker](TryStackDocker)

## TryStack Restrictions

To keep TryStack as a testing only platform we have a few restrictions set in place.
These help to make sure that resources are shared fairly as best as possible.

*   Instances are deleted after 24 hours
*   External gateways on routers are cleared daily
*   Cinder volumes are deleted after 48 hours
*   Other resource usage is monitored for other restrictions that need to be enforced

## Architecture Details

TryStack's Architecture includes the following components

*   Forman/Puppet base config managment
*   Nagios monitoring
*   MySQL database
*   RabbitMQ Messaging
*   GlusterFS Storage (Glance, MySQL & Mongo)
*   11 QEMU and 1 Docker Compute nodes

## Available Services

TryStack runs the following OpenStack components

*   Nova
*   Neutron
*   Glance
*   Keystone
*   Cinder
*   Ceilometer
*   Heat
*   Swift
