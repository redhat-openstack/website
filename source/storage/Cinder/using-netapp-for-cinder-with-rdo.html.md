---
title: Using NetApp for Cinder with RDO
authors: rhefner, snecklifter
---

# Using NetApp for Cinder with RDO

It is possible to have Packstack configure Cinder to use NetApp storage devices as backends for providing block storage capabilities to OpenStack users. The NetApp driver for Cinder supports:

*   NetApp Clustered Data ONTAP (NFS/iSCSI)
*   NetApp Data ONTAP in 7-Mode (NFS/iSCSI)
*   NetApp E-Series (iSCSI)

If Packstack is not already installed, follow steps 1 & 2 in the [All-In-One Quickstart](https://www.rdoproject.org/install/packstack/) guide to get it installed.

**Important:** For information regarding best practices using NetApp storage with Cinder and other OpenStack services, see the [NetApp Deployment and Operations Guide](http://netapp.github.io/openstack-deploy-ops-guide/). If you have any questions, you can get in touch with us on the [NetApp OpenStack Community](http://community.netapp.com/t5/OpenStack-Discussions/bd-p/openstack-discussions) page or join us on IRC in the #openstack-netapp channel on Freenode!

## Configure via answer file

Generate a Packstack answer file:

    packstack --gen-answer-file=~/answers.txt

Help text is provided above each parameter to whether it’s required for a given NetApp configuration. For more information about the specific parameters and examples of their use, see the [NetApp unified driver docs](http://docs.openstack.org/liberty/config-reference/content/netapp-volume-driver.html) and choose the page detailing your storage family and protocol.

The Packstack parameters are the same as those found in the docs, but in all caps and with `CONFIG_CINDER_` prepended. For example, entering the following into the answer file:

    ...
    CONFIG_CINDER_BACKEND=netapp
    CONFIG_CINDER_NETAPP_STORAGE_FAMILY=ontap_cluster
    CONFIG_CINDER_NETAPP_STORAGE_PROTOCOL=nfs
    CONFIG_CINDER_NETAPP_VSERVER=openstack-vserver
    CONFIG_CINDER_NETAPP_HOSTNAME=myhostname
    CONFIG_CINDER_NETAPP_SERVER_PORT=80
    CONFIG_CINDER_NETAPP_LOGIN=username
    CONFIG_CINDER_NETAPP_PASSWORD=password
    CONFIG_CINDER_NETAPP_NFS_SHARES=192.168.1.1:/cinder1,192.168.1.2:/cinder2
    CONFIG_CINDER_NETAPP_NFS_SHARES_CONFIG=/etc/cinder/nfs_shares
    ...

generates the following in `cinder.conf`:

    volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
    ... other parameters ...
    [netapp]
    netapp_storage_family=ontap_cluster
    netapp_storage_protocol=nfs
    netapp_vserver=openstack-vserver
    netapp_server_hostname=myhostname
    netapp_server_port=80
    netapp_login=username
    netapp_password=password
    nfs_shares_config=/etc/cinder/nfs_shares

**Note:** The NFS shares in the `nfs_shares` parameter are written to the file in the location specified by `nfs_shares_config`.

When the answer file has been edited with your specific environment variables, run Packstack with:

    packstack --answer-file=~/packstack-answer.txt

Packstack will alert you if any required parameters are missing or have incorrect values and then start the install.

If you have any trouble creating Cinder volumes after the installation has finished, the log file found at `/var/log/cinder/volume.log` is a good place to begin troubleshooting. If you have any questions, drop us a line!

## Configure via command line arguments

Add NetApp arguments when installing:

    packstack --arg1=... --argN=... --cinder-netapp-storage-family=ontap_cluster

Again, refer to the [NetApp unified driver docs](http://docs.openstack.org/liberty/config-reference/content/netapp-volume-driver.html) for details about specific parameters.

The Packstack parameters are the same as those found in the docs, but with `cinder-` prepended and all underscores turned into hyphens. For example, running Packstack with these arguments:

    packstack --cinder-backend=netapp --cinder-netapp-storage-family=ontap_cluster --cinder-netapp-storage-protocol=nfs --cinder-netapp-vserver=openstack-vserver --cinder-netapp-hostname=myhostname --cinder-netapp-server-port=80 --cinder-netapp-login=username --cinder-netapp-password=password --cinder-netapp-nfs-shares-config=/etc/cinder/nfs_shares

is functionally equivalent to the answer file in the previous section.
