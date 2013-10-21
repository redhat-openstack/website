---
title: Upgrading RDO
authors: carltm, dansmith, pranavs
wiki_title: Upgrading RDO
wiki_revision_count: 6
wiki_last_updated: 2014-06-02
---

# Upgrading RDO

There are basically two methods for upgrading RDO. Which you use depends on your tolerance for downtime and complexity. Note that all of the below assumes a nova-network installation. If you are moving from quantum to neutron, there may be other steps involved.

## Option 1: In-place Upgrade

The high level task of upgrading everything in place looks like this:

1.  Take down all the services on all the nodes
2.  Upgrade the packages
3.  Upgrade the databases
4.  Start up all the services on all the nodes

The first step depends on how your services are distributed among your nodes, but something like this should work for a nova node, which can be extended for the other services:

      cd /etc/init.d
      for service in openstack-nova*; do service $i stop; done

Upgrading the packages means installing the new version of rdo-release and running "yum update":

`yum install `[`http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm`](http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm)
      yum -y update

Once you get to this point, you need to upgrade the database schema for every service before you start them up running new code. This only needs to be done once per service. Most of the services use a similar command, but there are some unfortunate variations that make this difficult. The commands to do this are:

      nova-manage db sync
      cinder-manage db sync
      glance-manage upgrade
      keystone-manage db_sync

Now that the code and the databases have been upgraded, you can restart the services. Like above, this depends on how you have your services distributed, but this should work for a nova node:

      cd /etc/init.d
      for service in openstack-nova*; do service $i stop; done
