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

Configure a system with Red Hat Enterprise Linux (RHEL) 6.5, or the equivalent version of one of the RHEL-based Linux distributions such as CentOS 6.5. Ensure the host has network connectivity with a static IP address.

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

## Configuring Cinder

On the RDO node, configure the Cinder configuration file. The default configuration file has commented out sections for Ceph, which you can uncomment and configure.

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

When you are done, the changes to the configuration file (without comments) should look something like this:

         volume_driver=cinder.volume.drivers.rbd.RBDDriver
         rbd_user=volumes
         rbd_secret_uuid=457eb676-33da-42ec-9a8c-9293d545c337
         rbd_pool=volumes
         rbd_ceph_conf=/etc/ceph/ceph.conf
         rbd_flatten_volume_from_snapshot=false
         rbd_max_clone_depth=5
         glance_api_version=2

Restart Cinder to ensure that the configuration changes take effect.

         sudo service openstack-cinder-volume restart

## Configure Cinder Backup

On the RDO node, continue to configure the Cinder configuration file. The default configuration file has commented out sections for Ceph backup, which you can uncomment and configure.

1. As root, edit the `/etc/cinder/cinder.conf` file.

2. Add the backup driver.

         backup_driver=cinder.backup.drivers.ceph

3. Enable `backup_ceph_conf` and use `/etc/ceph/ceph.conf` as the Ceph configuration file.

4. Enable `backup_ceph_user` and specify `backups` as the user.

5. Enable `backup_ceph_pool` and specify `backups` as the pool.

6. Enable `backup_ceph_chunk_size` and leave the default value unchanged.

7. Enable `backup_ceph_stripe_unit` and leave the default value unchanged.

8. Enable `backup_ceph_stripe_count` and leave the default value unchanged.

9. Enable `restore_discard_excess_bytes` and set the value to `true`.

When you are done, the changes to the configuration file (without comments) should look something like this:

         backup_driver=cinder.backup.drivers.ceph
         backup_ceph_conf=/etc/ceph/ceph.conf
         backup_ceph_user=cinder-backup
         backup_ceph_pool=backups
         backup_ceph_chunk_size=134217728
         backup_ceph_stripe_unit=0
         backup_ceph_stripe_count=0
         restore_discard_excess_bytes=true

Restart Cinder Backup to ensure that the configuration changes take effect.

         sudo service openstack-cinder-backup restart

## Configuring Nova

In order to boot all the virtual machines directly into Ceph Nova must be configured. On every Compute nodes, edit `/etc/nova/nova.conf` and add the following under the `[libvirt]` section:

         libvirt_images_type=rbd
         libvirt_images_rbd_pool=volumes
         libvirt_images_rbd_ceph_conf=/etc/ceph/ceph.conf
         libvirt_inject_password=false
         libvirt_inject_key=false
         libvirt_inject_partition=-2

         rbd_user=volumes
         rbd_secret_uuid={uuid-from-libvirt}

Restart Nova to ensure that the configuration changes take effect.

         sudo service openstack-nova-compute restart

## Creating Your First Image

OpenStack provides a default image using CirrOS. To create your own for use with Ceph, follow these steps:

1. Download [CirrOS](http://download.cirros-cloud.net/0.3.2/cirros-0.3.2-x86_64-disk.img)

2. Convert the image from Qcow2 to Raw using `qemu-img` on the CLI.

         qemu-img convert -f qcow2 -O raw cirros-0.3.2-x86_64-disk.img cirros-0.3.2-x86_64-disk.raw

3. Go to the OpenStack Dashboard and login.

4. Go to the **Compute->Images** and select **Create an Instance**. Change **Image Source** to `Image File`. Then, click **Choose File**, navigate to the raw image you just created and select **Open**. Change **Format** to `Raw` and fill out the remaining fields. Then, click **Create Image** in the bottom right of the dialog.

5. Your new image will appear after you upload it.

6. Once the image appears in the UI, it should be stored in the Ceph pool for images. To see if there is data in the `images` pool, execute the following on the command line.

         rados -p images ls

## Creating Your First Volume

Once you have created an image in OpenStack, you can view it under **Compute->Images**. To create a volume:

1. Navigate to the **Actions** column and the row representing your image.

2. Select **More**.

3. Select **Create Volume**.

OpenStack will create a volume using your new image. Once OpenStack and Ceph complete creating your volume, you can see it under **Compute->Volumes**. To see if there is data in the `volumes` pool, execute the following on the command line.

         rados -p volumes ls

<Category:Storage>
