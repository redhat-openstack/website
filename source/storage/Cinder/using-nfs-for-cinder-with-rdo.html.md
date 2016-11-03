---
title: Using NFS for Cinder with RDO
authors: yrabl
wiki_title: Using NFS for Cinder with RDO
wiki_revision_count: 2
wiki_last_updated: 2014-01-06
---

# Using NFS for Cinder with RDO

*   Set the NFS share in Packstack:

        # packstack --cinder-backend=nfs --cinder-nfs-mounts=<IP/hostname>:/<shared directory>

*   Create the directory on which the shares will be mounted:

        # mkdir -p /var/lib/cinder/mnt

*   Make the Cinder user the owner of the directory:

        # chown -v cinder.cinder /var/lib/cinder/mnt

*   Configure the SELINUX on the compute nodes to allow access from the instances to the shares:

        # /usr/sbin/setsebool -P virt_use_nfs on

*   Restart all the Cinder related services:

        # for i in $(systemctl list-unit-files | awk ' /cinder/ { print $1 } ' ); do systemctl restart $i; done
