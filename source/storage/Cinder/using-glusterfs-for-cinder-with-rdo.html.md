---
title: Using GlusterFS for Cinder with RDO Liberty
authors: coolsvap
wiki_title: Using GlusterFS for Cinder with RDO Liberty
wiki_revision_count: 1
wiki_last_updated: 2015-10-15
---

# Using GlusterFS for Cinder with RDO

Since the RDO Liberty release, it has been possible to have Packstack configure Cinder to use GlusterFS as its back end. This assumes you have a GlusterFS share already available for the purpose; if you don't, just go trough the [GlusterFS QuickStart](http://www.gluster.org/community/documentation/index.php/QuickStart) guide to set that up.

## Automatic configuration with Packstack

Just add the following two arguments when installing:

       # packstack --arg1 --argX ... --cinder-backend=gluster --cinder-gluster-mounts=$GLUSTERFS_IP:$GLUSTERFS_SHARE_PATH

After the install is finished, if you're using SELinux, enable the following on the Nova node:

       # setsebool -P virt_use_fusefs on

## Manual configuration

To configure Cinder with GlusterFS manually, on an existing deployment:

Install the GlusterFS client (on both Cinder and Nova nodes):

       # yum install glusterfs-fuse

Create a file that contains a list of the GlusterFS shares. The file's path should be

       /etc/cinder/`<filename>`.conf 

Set the permissions of the file so that the Cinder group will be able to read from it.

      # chmod 664 /etc/cinder/`<filename>`.conf

Configure the path of the file that has all the shares:

       # openstack-config --set /etc/cinder/cinder.conf DEFAULT glusterfs_shares_config /etc/cinder/`<filename>`.conf 

Set the glusterfs_sparsed_volumes value to true for better performances:

       # openstack-config --set /etc/cinder/cinder.conf DEFAULT glusterfs_sparsed_volumes true

Set the GlusterFS driver as the default.

       # openstack-config --set /etc/cinder/cinder.conf DEFAULT volume_driver cinder.volume.drivers.glusterfs.GlusterfsDriver

If using SELinux, enable the following on the Nova node:

       # setsebool -P virt_use_fusefs on

Restart the Cinder's services.

       # for i in $(systemctl list-unit-files | awk ' /cinder/ { print $1 } ' ); do systemctl restart $i; done
