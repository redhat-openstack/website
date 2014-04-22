---
title: Deploying RDO to a Virtual Machine Environment using RDO via Instack
authors: bnemec, ccrouch, gfidente, jomara, rbrady, slagle, sradvan
wiki_title: Deploying RDO to a Virtual Machine Environment using RDO via Instack
wiki_revision_count: 85
wiki_last_updated: 2014-10-31
---

# Deploying RDO to a Virtual Machine Environment using RDO via Instack

[ ← Deploying RDO using Instack](Deploying RDO using Instack)

If you're connecting to the virt host remotely from ssh, you will need to use the -t flag to force pseudo-tty allocation or enable notty via a $USER.notty file.

Do not use the root user for executing any instack-undercloud scripts. Some programs of libguestfs-tools are not designed to work with the root user. All of the instack-undercloud scripts were developed and tested by using a normal user with sudo privileges.

## Minimum System Requirements

This setup creates (5) virtual machines consisting of 2G of memory and 30G of disk space each. If you do not plan to deploy Block Storage or Swift Storage nodes, you can delete those virtual machines and require less space accordingly. Most of the virtual machine disk files are thinly provisioned and won't take up the full 30G. The undercloud is not thinly provisioned and is completely pre-allocated.

*   At least (1) quad core CPU
*   12GB memory.
*   200GB disk space

These are the minimum system requirements to follow this tutorial. If you want to deviate from the tutorial or increase the scaling of one or more overcloud nodes, you will need to ensure you have enough memory and disk space.

## Preparing the Host Machine

The virtual host machine needs SE Linux set to permissive mode. You can immediately set the mode and also update the configuration file to survive reboots.

        # set selinux to permissive
        sudo setenforce 0
        # update the config file to survive reboots
        sudo sed -i "s/=enforcing/=permissive/" /etc/selinux/config

The user performing all of the installations needs to have passwordless sudo enabled. Create a user and then run the following commands, replacing "stack" with the name of the user you just created.

       sudo echo "stack ALL=(root) NOPASSWD:ALL" >> /etc/sudoers.d/stack
       sudo chmod 0440 /etc/sudoers.d/stack

## Recommended Default Values

These environment variables are used in several places in TripleO. These are the suggested default values and can be changed to suit your specific environment needs. Just export any or all of these before you start the installation process.

         # disk size in GB to set for each virtual machine created
        export NODE_DISK=30
        # memory in MB allocated for each virtual machine created
        export NODE_MEM=2048
        # Operating system distribution to set for each virtual machine created
        export NODE_DIST=fedora
        # CPU count assigned to each virtual machine created
        export NODE_CPU=1
        # 64 bit architecture
        export NODE_ARCH=amd64

## Virtual Host Installation

1. Add export of LIVBIRT_DEFAULT_URI to your bashrc file.

        echo 'export LIBVIRT_DEFAULT_URI="qemu:///system"' >> ~/.bashrc

2. Enable the RDO icehouse and openstack-m repository

`  sudo yum -y install `[`http://repos.fedorapeople.org/repos/openstack-m/openstack-m/openstack-m-release-icehouse-2.noarch.rpm`](http://repos.fedorapeople.org/repos/openstack-m/openstack-m/openstack-m-release-icehouse-2.noarch.rpm)
`  sudo yum install -y `[`http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm`](http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm)

3. Enable the fedora-openstack-m-testing yum repository.

       sudo yum -y install yum-utils
       sudo yum-config-manager --enable fedora-openstack-m-testing

4. Install instack-undercloud

       sudo yum -y install instack-undercloud

5. Run script to install required dependencies

       sudo yum install -y libguestfs-tools
       source /usr/libexec/openstack-tripleo/devtest_variables.sh
       tripleo install-dependencies

After running this command, you will need to log out and log back in for the changes to be applied. If you plan to use virt-manager or boxes to visually manage the virtual machines created in the next step, this would be a good time to install those tools now.

6. Run script to setup your virtual environment. If you'd like to customize the root password on the undercloud virtual machine created in this step, export an environment variable UNDERCLOUD_ROOT_PASSWORD. If you prefer to customize the name of the undercloud virtual machine to something besides instack, export the environment variable UNDERCLOUD_VM_NAME.

       export NODE_DISK=30
       instack-virt-setup

You should now have a vm called instack that you can use for the instack-undercloud installation that contains a minimal install of Fedora 20 x86_64. The instack vm contains a user "stack" that uses the password "stack" and is granted passwordless sudo privileges. The root password is displayed in the standard output unless you previously set it using UNDERCLOUD_ROOT_PASSWORD.

7. Get IP Address

You'll need to start the instack virtual machine and obtain its IP address. You can use your preferred virtual machine management software or follow the steps below.

       virsh start instack
       cat /var/lib/libvirt/dnsmasq/default.leases | grep $(tripleo get-vm-mac instack) | awk '{print $3;}'

8. Get MAC addresses

When setting up the undercloud on the instack virtual machine, you will need the MAC addresses of the baremetal node virtual machines. Use the following command to obtain the list of addresses you can add to your deploy-overcloudrc file later.

        for i in $(seq 0 3); do echo -n $(tripleo get-vm-mac baremetal_$i) " "; done; echo

9. Log into your instack virtual machine. Create the virtual-power-key and copy it to the virt host. The user in ssh-copy-id should match the VIRTUAL_POWER_USER and the ip should match the VIRTUAL_POWER_HOST in your instack.answers file.

       ssh-keygen -t rsa -N '' -C virtual-power-key -f virtual-power-key
       ssh-copy-id -i virtual-power-key.pub stack@192.168.122.1

Note that you don't have to use the pre-created instack vm and could instead create a new one via some other method (virt-install, virt-clone, etc). If you do so however make sure all the NIC interfaces are set to use virtio, and also manually add an additional interface to the vm by adding the following the libvirt xml for the domain (you may need to adjust slot as needed):

`     `<interface type='network'>
             

`       `<model type='virtio'/>
             

<address type='pci' domain='0x0000' bus='0x00' slot='0x09' function='0x0'/>
`     `</interface>

## Installing the Undercloud

The Undercloud image on the instack virtual machine is a minimal install of Fedora 20 with yum-utils and net-tools installed. This section will walk you through installing the instack-undercloud package and then running instack to apply packages.

1. Enable the openstack-m repository

` sudo yum -y install `[`http://repos.fedorapeople.org/repos/openstack-m/openstack-m/openstack-m-release-icehouse-2.noarch.rpm`](http://repos.fedorapeople.org/repos/openstack-m/openstack-m/openstack-m-release-icehouse-2.noarch.rpm)
` sudo yum install -y `[`http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm`](http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm)

2. Enable the fedora-openstack-m-testing yum repository.

       sudo yum-config-manager --enable fedora-openstack-m-testing

3. Install instack-undercloud

       sudo yum -y install instack-undercloud

4. Create and edit your answers file. The descriptions of the parameters that can be set are in the sample answers file.

         # Answers file must exist in home directory for now
         # Use either the baremetal or virt sample answers file
         # cp /usr/share/doc/instack-undercloud/instack-baremetal.answers.sample ~/instack.answers
         # cp /usr/share/doc/instack-undercloud/instack-virt.answers.sample ~/instack.answers
         # Perform any answer file edits

5. Run script to install undercloud. The script will produce a lot of output on the sceen. It also logs to ~/.instack/install-undercloud.log. You should see \`install-undercloud Complete!\` at the end of a successful run.

         instack-install-undercloud-packages

6. Once the install script has run to completion, you should take note to secure and save the file \`/root/stackrc\` and \`/root/tripleo-undercloud-passwords\`. Both these files will be needed to interact with the installed undercloud. You may copy these files to your home directory to make them easier to source later on, but you should try to keep them as secure and backed up as possible.

You now have a running Undercloud. Next steps: [ Deploying an RDO Overcloud with Instack ](Deploying an RDO Overcloud with Instack)

## Optional: Accessing Undercloud Dashboard

To access horizon on the undercloud, create an ssh tunnel on the virt host where 192.168.122.55 should be changed to reflect your instack virtual machine's actual IP address. This will allow you to use horizon on instack from your virt host. If you need to connect remotely through the virt host, you can chain ssh tunnels as needed. Note: Depending on your virt host configuration, you may need to open up the correct port(s) in iptables.

           ssh -g -N -L 8080:192.168.122.55:80 `hostname`

The default user and password are found in the stackrc file on the instack virtual machine, OS_USERNAME and OS_PASSWORD. You can read more about using the dashboard in the [User Guide](http://docs.openstack.org/user-guide/content/log_in_dashboard.html)
