---
title: Using GlusterFS for Cinder with RDO Havana
authors: gfidente, yrabl
wiki_title: Using GlusterFS for Cinder with RDO Havana
wiki_revision_count: 4
wiki_last_updated: 2014-01-13
---

# Using GlusterFS for Cinder with RDO Havana

With the RDO Havana release it is now possible to have Packstack configure Cinder to use GlusterFS as its backend. This assumes you have a GlusterFS share already available for the purpose; if you don't, just go trough the [GlusterFS QuickStart](http://www.gluster.org/community/documentation/index.php/QuickStart) guide to set that up.

*   Install the GlusterFS client

        # yum install glusterfs-fuse

*   Allow the SELinux value:

        # setsebool -P virt_use_fusefs on

*   With Packstack add the following two arguments:

       # packstack --arg1 --argX ... --cinder-backend=gluster --cinder-gluster-mounts=$GLUSTERFS_IP:$GLUSTERFS_SHARE_PATH

*   Without Packstack, create a file that contains a list of the GlusterFS shares. The file's path should be

        /etc/cinder/`<filename>`.conf 

*   Set the permissions of the file so that the Cinder group will be able to read from it.

       # chmod 0640 /etc/cinder/`<filename>`.conf

*   Configure the path of the file that has all the shares:

        # openstack-config --set /etc/cinder/cinder.conf DEFAULT glusterfs_shares_config /etc/cinder/`<filename>`.conf 

*   Set the glusterfs_sparsed_volumes value to true for better performances:

       # openstack-config --set /etc/cinder/cinder.conf DEFAULT glusterfs_sparsed_volumes true

*   Set the GlusterFS driver as the default.

       # openstack-config --set /etc/cinder/cinder.conf DEFAULT volume_driver cinder.volume.drivers.glusterfs.GlusterfsDriver

*   Restart the Cinder's services.

       # for i in $(chkconfig --list | awk ' /cinder/ { print $1 } ' ); do service $i restart; done
