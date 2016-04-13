---
title: Using GlusterFS for Glance with RDO Liberty
authors: coolsvap
wiki_title: Using GlusterFS for Glance with RDO Liberty
wiki_revision_count: 1
wiki_last_updated: 2015-10-15
---

# Using GlusterFS for Glance with RDO

To use GlusterFS with Glance one needs to go trough a few manual steps after RDO is installed. This also assumes you have a GlusterFS share already available for the purpose; if you don't, just go trough the [GlusterFS QuickStart](http://www.gluster.org/community/documentation/index.php/QuickStart) guide to set that up.

Stop the Glance services:

       # service openstack-glance-registry stop
       # service openstack-glance-api stop

Install the required packages (on the Glance node):

       # yum install glusterfs-fuse glusterfs 

Mount the GlusterFS share in the proper location and restart the services:

       # chown -R glance:glance /var/lib/glance/images
       # service openstack-glance-registry start
       # service openstack-glance-api start
