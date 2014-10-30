---
title: Deploying RDO to a Virtual Machine Environment using RDO via Instack
authors: bnemec, ccrouch, gfidente, jomara, rbrady, slagle, sradvan
wiki_title: Deploying RDO to a Virtual Machine Environment using RDO via Instack
wiki_revision_count: 85
wiki_last_updated: 2014-10-31
---

# Deploying RDO to a Virtual Machine Environment using RDO via Instack

[ ← Deploying RDO using Instack](Deploying RDO using Instack)

If you are connecting to the virtual host remotely using ssh, you will need to use the -t flag to force pseudo-tty allocation or enable notty via a $USER.notty file.

Do not use the root user for executing any instack-undercloud scripts. Some programs of libguestfs-tools are not designed to work with the root user. All of the instack-undercloud scripts were developed and tested by using a normal user with sudo privileges.

## Minimum System Requirements

This setup creates three (3) to five (5) virtual machines (depending on if you choose to deploy block and object storage nodes) consisting of 4GB of memory and 40GB of disk space on each. The virtual machine disk files are thinly provisioned and will not take up the full 40GB initially.

The minimum system requirements for the virtual host machine to follow this tutorial are:

*   Be running Fedora 20 x86_64
*   At least (1) quad core CPU
*   12GB free memory
*   120GB disk space [1]

If you want to deviate from the tutorial or increase the scaling of one or more overcloud nodes, you will need to ensure you have enough memory and disk space.

[1]: Note that the default Fedora partitioning scheme will most likely not provide enough space to the partition containing the default path for libvirt image storage (/var/lib/libvirt/images). The easiest fix is to customize the partition layout at the time of install to provide at least 200 GB of space for that path.

## Preparing the Host Machine

1. Make sure sshd service is installed and running.

2. The user performing all of the installation steps on the virt host needs to have sudo enabled. You can use an existing user or use the following commands to create a new user called **stack** with password-less sudo enabled. **Do not run the rest of the steps in this guide as root.**

       sudo useradd stack
       sudo passwd stack  # specify a password
       echo "stack ALL=(root) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/stack
       sudo chmod 0440 /etc/sudoers.d/stack

If you have previously used the host machine to run TripleO's devtest setup, then that could potentially conflict with the scripts installed from RDO packages. It is recommended to clean up from any previous devtest runs by deleting ~/.cache/tripleo and making sure there is no $TRIPLEO_ROOT defined in your environment.

### Virtual Host Setup

These steps will setup your virtual host for a virtual environment for testing the Overcloud deployment. For more information about the changes performed, See the [FAQ](https://openstack.redhat.com/Instack_FAQ#What_configuration_changes_does_instack-virt-setup_make_to_the_virt_host.3F).

1. Make sure you are logged in as the user you created above.

2. Add export of LIBVIRT_DEFAULT_URI to your bashrc file.

        echo 'export LIBVIRT_DEFAULT_URI="qemu:///system"' >> ~/.bashrc

3. Enable the RDO juno repository

`  sudo yum install -y `[`http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm`](http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm)

3.1.For now, we must also enable the copr and stage repositories.

       # Enable the copr repository
` sudo curl -o /etc/yum.repos.d/slagle-openstack-m.repo `[`https://copr.fedoraproject.org/coprs/slagle/openstack-m/repo/fedora-20/slagle-openstack-m-fedora-20.repo`](https://copr.fedoraproject.org/coprs/slagle/openstack-m/repo/fedora-20/slagle-openstack-m-fedora-20.repo)
       # Enable the stage RDO repo
       sudo sed -i 's#^baseurl.*#baseurl=`[`http://team.virt.bos.redhat.com/openstack/openstack-juno/fedora`](http://team.virt.bos.redhat.com/openstack/openstack-juno/fedora)`-$releasever/#' /etc/yum.repos.d/rdo-release.repo

4 . Install the instack-undercloud package.

       sudo yum install -y instack-undercloud

5. Run script to install required dependencies

       export NODE_DIST="fedora"
       source /usr/libexec/openstack-tripleo/devtest_variables.sh
       tripleo install-dependencies
       tripleo set-usergroup-membership
       # The previous command has added the user to the libvirtd group, so we need to login to the new group
       newgrp libvirtd
       newgrp

### Virtual Machine Creation

1. Verify again that your user has been added to the libvirtd group. The command shown below should show the libvirtd group listed in the output.

      id | grep libvirtd

2. Run the script to setup your virtual environment.

       instack-virt-setup

When the script has completed successfully it will output the IP address of the instack vm.

Running `virsh list --all` will show you now have one virtual machine called instack" and four called "baremetal[0-4]", all shut off. The "instack" vm runs a minimal install of Fedora 20 x86_64 and will be used to install the undercloud on. The vm contains a user "stack" that uses the password "stack" and is granted password-less sudo privileges. The other vm's don't have an operating system yet installed but will eventually become part of the "overcloud".

You may also with to install `virt-manager` on the virt host as it can be very helpful if monitoring when the vm's for the Overcloud nodes are powered on and off. You can also use virt-manager to login to the console on the Overcloud nodes.

Next steps: [ Deploying an RDO Undercloud with Instack ](Deploying an RDO Undercloud with Instack)
