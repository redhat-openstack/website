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

You use Ceph as a storage back end for RDO. The process is nearly identical to the process for configuring OpenStack to use Ceph on Ubuntu. See [Ceph Block Devices and OpenStack](http://ceph.com/docs/master/rbd/rbd-openstack/) for details. Using RDO with Ceph requires you to install Ceph, QEMU, and libvirt. Once you configure QEMU and libvirt for Ceph, you can configure RDO to use Ceph via libvirt and QEMU.

The main difference is that the current release of QEMU on RHEL doesn't support Ceph Block Devices, so you need to install QEMU packages from the Ceph repository.

## Configure an OS and Host

Configure a system with Red Hat Enterprise Linux (RHEL) 6.4, or the equivalent version of one of the RHEL-based Linux distributions such as CentOS 6.4. Ensure the host has network connectivity with a static IP address.

## Install Ceph Packages

Follow the procedure for installing [RPM Packages](http://ceph.com/docs/master/install/rpm/). The user must have sudo privileges and you must install all prerequisites.

Install ceph-deploy.

         sudo yum install ceph-deploy python-pushy

You may install Ceph on the localhost or another host. If you use the localhost, make sure the \`hosts\` file maps the hostname to the actual IP address so that ceph-deploy can install Ceph locally. Also, make sure that your host is configured to boot with networking turned on.

Finally, install Ceph using ceph-deploy. See [Ceph Deployment](http://ceph.com/docs/master/rados/deployment/) for details.

## Install QEMU for Ceph

The Ceph community builds QEMU packages for Red Hat Enterprise Linux (RHEL) or the equivalent version of one of the RHEL-based Linux distributions such as CentOS. You must install a Ceph-enabled version of QEMU. For RDO, you must install the QEMU version that corresponds to your distribution (e.g., RHEL, CentOS, etc.).

**NOTE:** The Ceph Community is actively making improvements to Ceph Extras repository to simplify the installation procedures.

### Manual Installation

1. Install QEMU IMG package for Ceph.

         sudo yum install usbredir
         su -c 'rpm -Uvh `[`http://www.ceph.com/packages/ceph-extras/rhel6/x86_64/qemu-img-0.12.1.2-2.355.el6.2.x86_64.rpm`](http://www.ceph.com/packages/ceph-extras/rhel6/x86_64/qemu-img-0.12.1.2-2.355.el6.2.x86_64.rpm)`'

2. Install the QEMU KVM package for Ceph.

         sudo yum install vgabios seabios sgabios spice-server gpxe-roms-qemu
         su -c 'rpm -Uvh `[`http://www.ceph.com/packages/ceph-extras/rhel6/x86_64/qemu-kvm-0.12.1.2-2.355.el6.2.x86_64.rpm`](http://www.ceph.com/packages/ceph-extras/rhel6/x86_64/qemu-kvm-0.12.1.2-2.355.el6.2.x86_64.rpm)`'

3. Install the QEMU Guest Agent repositories for QEMU guest agents.

         su -c 'rpm -Uvh `[`http://www.ceph.com/packages/ceph-extras/rhel6/x86_64/qemu-guest-agent-0.12.1.2-2.355.el6.2.x86_64.rpm`](http://www.ceph.com/packages/ceph-extras/rhel6/x86_64/qemu-guest-agent-0.12.1.2-2.355.el6.2.x86_64.rpm)`'
         su -c 'rpm -Uvh `[`http://www.ceph.com/packages/ceph-extras/rhel6/x86_64/qemu-guest-agent-win32-0.12.1.2-2.355.el6.2.x86_64.rpm`](http://www.ceph.com/packages/ceph-extras/rhel6/x86_64/qemu-guest-agent-win32-0.12.1.2-2.355.el6.2.x86_64.rpm)`'

4. Install the QEMU Tools package.

         su -c 'rpm -Uvh `[`http://www.ceph.com/packages/ceph-extras/rhel6/x86_64/qemu-kvm-tools-0.12.1.2-2.355.el6.2.x86_64.rpm`](http://www.ceph.com/packages/ceph-extras/rhel6/x86_64/qemu-kvm-tools-0.12.1.2-2.355.el6.2.x86_64.rpm)`'
         

5. Use \`ceph-deploy\` to make the QEMU host an admin host.

         ceph-deploy admin {qemu-hostname}

6. Ensure that QEMU has permissions to read the \`ceph.client.admin.keyring\` file. You may need to change ownership to an RDO user too.

         sudo chmod 644 /etc/ceph/ceph.client.admin.keyring

### Package Installation

To install QEMU for Ceph using "sudo yum install", you must add the appropriate Ceph repository to a file under "/etc/yum.repos.d" and name it accordingly (e.g., ceph-extras.repo, ceph-extras-noarch.repo, etc.).

        [ceph-extras]
        name=Ceph Extra Packages and Backports $basearch
`  baseurl=`[`http://ceph.com/packages/ceph-extras/rpm/centos6/$basearch`](http://ceph.com/packages/ceph-extras/rpm/centos6/$basearch)
        enabled=1
        gpgcheck=1
        type=rpm-md
`  gpgkey=`[`https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc`](https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc)

        [ceph-extras-noarch]
        name=Ceph Extra Packages and Backports noarch
`  baseurl=`[`http://ceph.com/packages/ceph-extras/rpm/centos6/noarch`](http://ceph.com/packages/ceph-extras/rpm/centos6/noarch)
        enabled=1
        gpgcheck=1
        type=rpm-md
`  gpgkey=`[`https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc`](https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc)

       [ceph-extras-source]
       name=Ceph Extra Packages and Backports Sources
` baseurl=`[`http://ceph.com/packages/ceph-extras/rpm/centos6/SRPMS`](http://ceph.com/packages/ceph-extras/rpm/centos6/SRPMS)
       enabled=1
       gpgcheck=1
       type=rpm-md
` gpgkey=`[`https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc`](https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc)
       centos-extras

Ensure that you specify the appropriate base URL for your distribution. Then, execute \`sudo yum update\` before installing QEMU.

### Verify QEMU Installation

Before proceeding with a libvirt installation, ensure that you have QEMU installed and that it is running. See [QEMU and Ceph Block Devices](http://ceph.com/docs/master/rbd/qemu-rbd/) for additional details.

## Install libvirt

1. Install libvirt.

         sudo yum install libvirt
         

2. Start the \`libvirtd\` daemon.

         sudo /etc/init.d/libvirtd start 

3. Configure \`libvirt\`. See [Using libvirt with Ceph Block Devices](http://ceph.com/docs/master/rbd/libvirt/)

## Install RDO

See [Quick Start page](//openstack.redhat.com/Quickstart) for details.

## Configure RDO for use with Ceph

1. Create pools.

         ceph osd pool create volumes 128
         ceph osd pool create images 128

2. Use \`ceph-deploy\` to make the RDO host is an admin host.

         ceph-deploy admin {rdo-hostname}

3. Ensure that RDO has permissions to read the ceph.client.admin.keyring file on the RDO host. You may also need to change its ownership and group to an RDO user.

         sudo chmod 644 /etc/ceph/ceph.client.admin.keyring

4. Use ceph-deploy to install Ceph packages onto the RDO host.

         ceph-deploy install {rdo-hostname}

5. For the glance-api host, you'll need the Python bindings for librbd.

         sudo yum install python-ceph

6. Create a new user for Nova/Cinder and Glance.

         ceph auth get-or-create client.volumes mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=volumes, allow rx pool=images'
         ceph auth get-or-create client.images mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=images'

7. Add the keyrings for client.volumes and client.images to the appropriate hosts and change their ownership:

         ceph auth get-or-create client.images | ssh {your-glance-api-server} sudo tee /etc/ceph/ceph.client.images.keyring
         ssh {your-glance-api-server} sudo chown glance:glance /etc/ceph/ceph.client.images.keyring
         ceph auth get-or-create client.volumes | ssh {your-volume-server} sudo tee /etc/ceph/ceph.client.volumes.keyring
         ssh {your-volume-server} sudo chown cinder:cinder /etc/ceph/ceph.client.volumes.keyring

Hosts running nova-compute do not need the keyring. Instead, they store the secret key in libvirt.

8. Create a temporary copy of the secret key on the hosts running nova-compute.

      `    ssh {your-compute-host} client.volumes.key < `ceph auth get-key client.volumes` `

9. Create a secret file.

`   cat > secret.xml <`<EOF
        <secret ephemeral='no' private='no'>
`           `<usage type='ceph'>
`               `<name>`client.volumes secret`</name>
`            `</usage>
`       `</secret>
             EOF

10. Define the secret with the secret file.

         sudo virsh secret-define --file secret.xml
`   `<uuid of secret is output here>

Save the uuid of the secret for configuring nova-compute later.

11. Set the UUID from the preceding step as the secret value, and delete the secret.xml file.

         sudo virsh secret-set-value --secret {uuid of secret} --base64 $(cat client.volumes.key) && rm client.volumes.key secret.xml
