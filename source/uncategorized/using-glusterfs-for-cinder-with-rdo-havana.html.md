---
title: Using GlusterFS for Cinder with RDO Havana
authors: gfidente, yrabl
wiki_title: Using GlusterFS for Cinder with RDO Havana
wiki_revision_count: 4
wiki_last_updated: 2014-01-13
---

# Using GlusterFS for Cinder with RDO Havana

With the RDO Havana release it is now possible to have Packstack configure Cinder to use GlusterFS as its backend. This assumes you have a GlusterFS share already available for the purpose; if you don't, just go trough the [GlusterFS QuickStart](http://www.gluster.org/community/documentation/index.php/QuickStart) guide to set that up.

Once the share is ready, install RDO using Packstack as usual and just add the following two arguments:

       # packstack --arg1 --argX ... --cinder-backend=gluster --cinder-gluster-mounts=$GLUSTERFS_IP:$GLUSTERFS_SHARE_PATH
