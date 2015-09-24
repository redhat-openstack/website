---
title: Using Ceph for Glance with RDO
authors: tshefi
wiki_title: Using Ceph for Glance with RDO
wiki_revision_count: 1
wiki_last_updated: 2014-09-21
---

# Using Ceph for Glance with RDO

## Configuring Glance

On the RDO node, configure the Glance API configuration file. The default configuration file has commented out sections for Ceph, which you can uncomment and configure.

1. As `root`, edit the `/etc/glance/glance-api.conf` file.

2. Change `default_store=file` to `default_store=rbd`.

3. Enable `rbd_store_user` and set the user name to `images` (corresponds to user `client.images`).

4. Enable `rbd_store_pool` and set the pool name to `images` (corresponds to the pool `images`).

5. Enable `show_image_direct_url` and set the value to `True`.

6. Enable `rbd_store_ceph_conf` and leave the default Ceph configuration file path unchanged.

7. Enable `rbd_store_chunk_size` and set the value to `8`.

When you are done, the configuration (without comments) should look something like this:

         default_store=rbd
         rbd_store_user=images
         rbd_store_pool=images
         show_image_direct_url=True
         rbd_store_ceph_conf=/etc/ceph/ceph.conf
         rbd_store_chunk_size=8

Restart glance to ensure that the configuration changes take effect.

         sudo service openstack-glance-api restart
