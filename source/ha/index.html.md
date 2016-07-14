---
title: HA
authors: beekhof, radez, rbowen
wiki_title: HA
wiki_revision_count: 19
wiki_last_updated: 2015-03-09
---

# HA

Installing and configuring OpenStack for high availability is described in the [OpenStack High Availability Guide](http://docs.openstack.org/ha-guide/).

The [osp-ha-deploy](https://github.com/beekhof/osp-ha-deploy/) repository on GitHub contains the description of two highly available OpenStack architectures using RDO or Red Hat OpenStack Platform:

   * [An architecture based on Pacemaker](https://github.com/beekhof/osp-ha-deploy/blob/master/ha-openstack.md).
   * [An architecture based on application-native tools and Keepalived](https://github.com/beekhof/osp-ha-deploy/blob/master/HA-keepalived.md).

Each architecture includes a description and implementation instructions. Be sure to understand the constrains and limitations of each architecture, and choose the one that better suits your needs.
