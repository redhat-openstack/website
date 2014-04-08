---
title: Deploying RDO on a Virtual Machine Environment using Instack
authors: bnemec, gfidente, rbrady, slagle, timbyr
wiki_title: Deploying RDO on a Virtual Machine Environment using Instack
wiki_revision_count: 33
wiki_last_updated: 2015-01-09
---

# Deploying RDO on a Virtual Machine Environment using Instack

instack-undercloud virt setup =============================

You should select a host machine with at least 12G of memory and 200G disk space. The virt setup creates 5 virtual machines consisting of 2G of memory and 30G of disk space each. If you do not plan to deploy Block Storage or Swift Storage nodes, you can delete those virtual machines and require less space accordingly. Most of the virtual machine disk files are thinly provisioned and won't take up the full 30G. The undercloud is not thinly provisioned and will is completely pre-allocated.

If you're connecting to the virt host remotely from ssh, you will need to use the -t flag to force pseudo-tty allocation or enable notty via a $USER.notty file.

Some recommended default environment variables before starting:

             # disk size in GB to set for each virtual machine created
             NODE_DISK=30

             # memory in MB allocated for each virtual machine created
             NODE_MEM=2048

             # Operating system distribution to set for each virtual machine created
             NODE_DIST=fedora

             # CPU count assigned to each virtual machine created
             NODE_CPU=1

             # 64 bit architecture
             NODE_ARCH=amd64

1. Add export of LIVBIRT_DEFAULT_URI to your bashrc file.

             echo 'export LIBVIRT_DEFAULT_URI="qemu:///system"' >> ~/.bashrc

1. Install the openstack-m repository

`       sudo yum -y install `[`http://repos.fedorapeople.org/repos/openstack-m/openstack-m/openstack-m-release-icehouse-2.noarch.rpm`](http://repos.fedorapeople.org/repos/openstack-m/openstack-m/openstack-m-release-icehouse-2.noarch.rpm)

1. Enable the fedora-openstack-m-testing yum repository.

             sudo yum -y install yum-utils
             sudo yum-config-manager --enable fedora-openstack-m-testing

1. Install instack-undercloud

             sudo yum -y install instack-undercloud

1. Run script to install required dependencies

             sudo yum install -y libguestfs-tools
             source /usr/libexec/openstack-tripleo/devtest_variables.sh
             tripleo install-dependencies

        After running this command, you will need to log out and log back in for the changes to be applied.  If you plan to
        use virt-manager or boxes to visually manage the virtual machines created in the next step, this would be a good time
        to install those tools now.

1. Run script to setup your virtual environment.

             export NODE_DISK=30
             instack-virt-setup

        You should now have a vm called instack that you can use for the instack-undercloud installation that contains a minimal
        install of Fedora 20 x86_64. The instack vm contains a user "stack" that uses the password "stack" and is granted
        password-less sudo privileges.  The root password is "redhat".

1. Get IP Address

        You'll need to start the instack virtual machine and obtain its IP address.  You can use your preferred virtual
        machine management software or follow the steps below.

             virsh start instack
             cat /var/lib/libvirt/dnsmasq/default.leases | grep $(tripleo get-vm-mac instack) | awk '{print $3;}'

1. Get MAC addresses

        When setting up the undercloud on the instack virtual machine, you will need the MAC addresses of the baremetal node
        virtual machines.  Use the following command to obtain the list of addresses you can add to your deploy-overcloudrc
        file later.

              for i in $(seq 0 3); do echo -n $(tripleo get-vm-mac baremetal_$i) " "; done; echo

Note that you don't have to use the pre-created instack vm and could instead create a new one via some other method (virt-install, virt-clone, etc). If you do so however make sure all the NIC interfaces are set to use virtio, and also manually add an additional interface to the vm by adding the following the libvirt xml for the domain (you may need to adjust slot as needed):

`       `<interface type='network'>
               

`         `<model type='virtio'/>
               

<address type='pci' domain='0x0000' bus='0x00' slot='0x09' function='0x0'/>
`       `</interface>

Once the vm is installed, start and logon to the vm, obtain the IP address and then return to the TODO: Add readme packages content
