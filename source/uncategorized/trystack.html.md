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

How to import a docker image into trystack [TryStackDocker](TryStackDocker)

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
