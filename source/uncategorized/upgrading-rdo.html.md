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
      for service in openstack-nova*; do service $service stop; done

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
      for service in openstack-nova*; do service $service stop; done

## Option 2: Service-by-Service Upgrade

This method involves more work, but has the potential to impact a working cluster for smaller periods of time. In general, the compute upgrade will require the longest period of downtime, but there are ways to mitigate that impact in exchange for more complexity and resource consumption. The explanation of each step is abbreviated, assuming that it can be inferred from reading the description of Option 1 above.

The high-level task of upgrading services looks like this:

For each service:

1.  Take down that service
2.  Upgrade the packages
3.  Upgrade the database
4.  Start up the service

The above pattern can be applied to keystone, glance, cinder, and nova in that order. This eliminates having everything down for the duration required to complete all of the upgrades at once. Further, it provides the opportunity to parallelize the nova upgrade.

## Option 2.5: Service-by-Service Upgrade with Parallel Computes

This is just a small variation of the above, but with a change in how nova is upgraded. Once keystone, glance, and cinder are upgraded, a new nova deployment based on the current release can be created, utilizing the already-upgraded smaller services that are also in use by the old un-upgraded nova deployment. This allows you to slowly migrate workloads to the new compute deployment, moving/upgrading physical hosts over to the new release as they become vacated.

With this model, far less downtime of the overall cluster is required, with only a few minutes for the smaller services, and a longer migration interval for the workloads moving to newly-upgraded compute hosts.
