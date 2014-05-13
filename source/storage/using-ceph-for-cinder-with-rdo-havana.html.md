---
title: Using Ceph for Cinder with RDO Havana
category: storage
authors: dneary, gfidente, johnwilkins, rbowen, rossturk, tshefi, vaneldik
wiki_category: Storage
wiki_title: Using Ceph for Cinder with RDO Havana
wiki_revision_count: 15
wiki_last_updated: 2015-03-13
---

# Using Ceph for Cinder with RDO Havana

__NOTOC__

Ceph® is an open-source project capable of providing both object and block storage to RDO Havana. See [Block Devices and Open Stack](http://ceph.com/docs/master/rbd/rbd-openstack/) for additional details.

## Configure an OS and Host

Configure a system with Red Hat Enterprise Linux (RHEL) 6.4, or the equivalent version of one of the RHEL-based Linux distributions such as CentOS 6.4. Ensure the host has network connectivity with a static IP address.

## Set Up a Ceph Storage Cluster

To provide RDO Havana with object and block storage, you must first install and configure a Ceph cluster.

1. From an Admin Node, ensure that you perform the steps in the [Ceph Preflight Checklist](http://ceph.com/docs/master/start/quick-start-preflight/) for each Ceph Node.

2. From the Admin Node, follow the [Storage Cluster Quick Start](http://ceph.com/docs/master/start/quick-ceph-deploy/). To install a particular release of Ceph, see See [Package Management](http://ceph.com/docs/master/rados/deployment/ceph-deploy-install/) for additional details.

3. Ensure that the Admin Node has administrator privileges (*i.e.*, step 6 of the Storage Cluster Quick Start).

4. Ensure your storage cluster is running and healthy (*i.e.*, step 8 of the Storage Cluster Quick Start).

## Install Virtualization for Ceph Block Devices

Once you have a Ceph Storage Cluster up and running, you can begin installing virtualization software.

1. From an Admin Node, ensure that you perform the steps in the [Ceph Preflight Checklist](http://ceph.com/docs/master/start/quick-start-preflight/) on the RDO node.

2. From the Admin Node, install Ceph on the RDO node (*i.e.*, step 3 of the Storage Cluster Quick Start). Use the same version of Ceph on the RDO node that you used for the Ceph Storage Cluster. See [Package Management](http://ceph.com/docs/master/rados/deployment/ceph-deploy-install/) for additional details.

3. Ensure that the RDO node has administrator privileges (*i.e.*, step 6 of the Storage Cluster Quick Start) to simplify the installation procedure. Once you have RDO up and running, consider removing administrator privileges from the RDO node for added security.

4. From the RDO node, install QEMU KVM and ensure that it is working properly with Ceph. Older releases of RHEL and CentOS don't provide the `rbd` format required for use with Ceph. You can install Ceph Block Device-enabled versions of QEMU KVM to ensure that it has `rbd` format. See [Install QEMU](http://ceph.com/docs/master/install/install-vm-cloud/#rpm-packages) for additional details. Ensure that QEMU KVM has `rbd` format (*e.g.*, `qemu-img -f`). See [QEMU and Block Devices](http://ceph.com/docs/master/rbd/qemu-rbd/) for additional details.

5. From the RDO node, install `libvirt`. See [Install libvirt](http://ceph.com/docs/master/install/install-vm-cloud/#id2) for additional details.

6. From the RDO node, start the `libvirt` daemon.

         sudo /etc/init.d/libvirtd start

7. Verify `libvirt` is working properly (optional). See [Using `libvirt` with Ceph Block Device](http://ceph.com/docs/master/rbd/libvirt/) for details. Note: Once `libvirt` is working properly, you can integrate RDO and other software too via `libvirt` (*e.g.*, CloudStack, XenServer, etc.) to use a Ceph Block Device.

## Install RDO

From the RDO node, install RDO. See [Quick Start page](//openstack.redhat.com/Quickstart) for details.

## Configure Ceph Pools and Users

1. On the RDO node, create pools (can on RDO node with admin permissions).

         ceph osd pool create volumes 128
         ceph osd pool create images 128
         ceph osd pool create backups 128

2. Create a keyring and user for images.

         sudo ceph-authtool --create-keyring /etc/ceph/ceph.client.images.keyring
         sudo chmod +r /etc/ceph/ceph.client.images.keyring
         sudo ceph-authtool /etc/ceph/ceph.client.images.keyring -n client.images --gen-key
         sudo ceph-authtool -n client.images --cap mon 'allow r' --cap osd 'allow class-read object_prefix rbd_children, allow rwx pool=images' /etc/ceph/ceph.client.images.keyring
         ceph auth add client.images -i /etc/ceph/ceph.client.images.keyring

3. Create a keyring and user for volumes.

         sudo ceph-authtool --create-keyring /etc/ceph/ceph.client.volumes.keyring
         sudo chmod +r /etc/ceph/ceph.client.volumes.keyring
         sudo ceph-authtool /etc/ceph/ceph.client.volumes.keyring -n client.volumes --gen-key
         sudo ceph-authtool -n client.volumes --cap mon 'allow r' --cap osd 'allow class-read object_prefix rbd_children, allow rwx pool=volumes, allow rx pool=images' /etc/ceph/ceph.client.volumes.keyring
         ceph auth add client.volumes -i /etc/ceph/ceph.client.volumes.keyring

4. Create a keyring and user for backups.

         sudo ceph-authtool --create-keyring /etc/ceph/ceph.client.backups.keyring
         sudo chmod +r /etc/ceph/ceph.client.backups.keyring
         sudo ceph-authtool /etc/ceph/ceph.client.backups.keyring -n client.backups --gen-key
         sudo ceph-authtool -n client.backups --cap mon 'allow r' --cap osd 'allow class-read object_prefix rbd_children, allow rwx pool=backups' /etc/ceph/ceph.client.backups.keyring
         ceph auth add client.backups -i /etc/ceph/ceph.client.backups.keyring

5. From the Admin node, add entries into the Ceph configuration file for the `client.images`, `client.volumes` and `client.backups` users and specify the path to their respective keyrings.

        [client.images]
        keyring = /etc/ceph/ceph.client.images.keyring
       
        [client.volumes]
        keyring = /etc/ceph/ceph.client.volumes.keyring
        
        [client.backups]
        keyring = /etc/ceph/ceph.client.backups.keyring

6. Push an update to the RDO node with `ceph-deploy<tt>.

    ceph-deploy --overwrite-conf config push {rdo-node-name}

=Configure Libvirt=

Hosts running <tt>nova-compute` store the volume key in `libvirt` rather than retrieving a Ceph keyring. So you must configure `libvirt` with a key.

1. From the RDO node, get the `client.volumes` key and save it to a file::

         ceph auth get-key client.volumes | sudo tee client.volumes.key

2. Create a `secret.xml` file on the RDO node with the following contents.

`   `<secret ephemeral='no' private='no'>
`      `<usage type='ceph'>
`         `<name>`client.volumes secret`</name>
`      `</usage>
`   `</secret>

3. Define the secret with the `secret.xml` file.

         sudo virsh secret-define --file secret.xml

Save the uuid of the secret for the next step.

4. Set the UUID from the preceding step as the secret value, and delete the `client.volumes.key` file and `secret.xml` file.

        sudo virsh secret-set-value --secret {replace-with-uuid-of-secret} --base64 $(cat client.volumes.key) && rm client.volumes.key secret.xml

Configure OpenStack to use Block Device

See [Configure OpenStack to Use Ceph](http://ceph.com/docs/master/rbd/rbd-openstack/#configure-openstack-to-use-ceph) for details.

## Configuring Glance

On the RDO node, configure the Glance API configuration file.

1. As root, edit the `/etc/glance/glance-api.conf` file.

2. Change `default_store=file` to `default_store=rbd`.

3. Enable `rbd_store_user` and set the user name to `images` (corresponds to user `client.images`).

4. Enable `rbd_store_pool` and set the pool name to `images` (corresponds to the pool `images`).

5. Enable `show_image_direct_url` and set the value to `True`.

6. Enable `rbd_store_ceph_conf` and leave the default Ceph configuration file path unchanged.

7. Enable `rbd_store_chunk_size` and set the value to `8`.

8. Restart glance.

## Configuring Cinder

On the RDO node, configure the Cinder configuration file.

1. As root, edit the `/etc/cinder/cinder.conf` file.

2. Add the volume driver.

        volume_driver=cinder.volume.drivers.rbd.RBDDriver

3. Enable `rbd_user` and set the user to `volumes` ( corresponds to the user `client.volumes` ).

4. Enable `rbd_secret_uuid` and set the value to the UUID you used with `libvirt` and the `client.volumes` user.

5. Enable `rbd_pool` and set the pool to `volumes` ( corresponds to the pool `volumes` ).

6. Enable `rbd_ceph_conf` and leave the default Ceph configuration file path unchanged.

7. Enable `rbd_flatten_volume_from_snapshots` and set the value to `false`.

8. Enable `rbd_max_clone_depth` and set the value to `5`.

9. Enable `glance_api_version` and set it to `2`.

<Category:Storage>
