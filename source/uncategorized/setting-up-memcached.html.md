---
title: Setting-up-memcached
authors: kashyap
wiki_title: Setting-up-memcached
wiki_revision_count: 2
wiki_last_updated: 2014-04-23
---

## Setting up memcached for HA

Install memcached on both nodes (rdo-memcache1|rdo-memcache2):

    yum install -y memcached

Configure `pacemaker`:

    chkconfig pacemaker on
    pcs cluster setup --name rdo-memcache rdo-memcache1 rdo-memcache2
    pcs cluster start

    sleep 30

    pcs stonith create memcache1-fence fence_xvm multicast_address=225.0.0.7 pcmk_host_list=rdo-memcache1

    pcs stonith create memcache2-fence fence_xvm multicast_address=225.0.0.8 pcmk_host_list=rdo-memcache2

    pcs resource create memcached lsb:memcached --clone
