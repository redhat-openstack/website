---
title: Deploying RDO on a Baremetal Environment using Instack
authors: ccrouch, rbrady, rlandy, slagle
wiki_title: Deploying RDO on a Baremetal Environment using Instack
wiki_revision_count: 98
wiki_last_updated: 2014-10-28
---

# Deploying RDO on a Baremetal Environment using Instack

THIS PAGE IS A WORK IN PROGRESS

## Oveview

Works on Fedora 20 only

## Minimum System Requirements

*   machine specs/ space/memory requirements

## Preparing the Baremetal Environment

*   get MAC addresses
*   add user
*   passwordless sudo

## Installing the undercloud with Instack

1.  Enable the openstack-m repository
        sudo yum -y install http://repos.fedorapeople.org/repos/openstack-m/openstack-m/openstack-m-release-icehouse-2.noarch.rpmT

2.  Enable the fedora-openstack-m-testing yum repository.
         sudo yum-config-manager --enable fedora-openstack-m-testing

3.  Install instack-undercloud
        sudo yum -y install instack-undercloud

4.  Create and edit your answers file. The descriptions of the parameters that can be set are in the sample answers file.
        # Answers file must exist in home directory for now
        # Use the baremetal answers file
        cp /usr/share/doc/instack-undercloud/instack-baremetal.answers.sample ~/instack.answers
        # Perform any answer file edits

5.  Run script to install undercloud. The script will produce a lot of output on the screen. It also logs to `~/.instack/install-undercloud.log`. You should see `install-undercloud Complete!` at the end of a successful run.
        instack-install-undercloud-packages

6.  Once the install script has run to completion, you should take note to secure and save the files `/root/stackrc` and `/root/tripleo-undercloud-passwords`. Both these files will be needed to interact with the installed undercloud. You may copy these files to your home directory to make them easier to source later on, but you should try to keep them as secure and backed up as possible.
    That completes the undercloud install. To proceed with deploying and using the overcloud see sections below.

## Preparing for Deploying the Overcloud

### Sourcing Files

<li>
You must source the contents of `/root/stackrc` into your shell before running the instack-\* scripts that interact with the undercloud and overcloud. In order to do that you can copy that file to a more convenient location or use `sudo` to `cat` the file and copy/paste the lines into your shell environment.

</li>
### Downloading Images for the Overcloud

<li>
Once the undercloud is installed, there should be a script `/usr/bin/prepare-for-overcloud` available to be executed by the user. Run the `prepare-for-overcloud` script to set up before deploying the overcloud.

    instack-prepare-for-overcloud

This script downloads images to use for deploying Control, Compute, Block Storage and Storage nodes in the overcloud. The script will avoid re-download images if they already exist in the current working directory. If you want to force a re-download of the images, delete those existing images first.

</li>
### Defining Environment Variables

<li>
There should be two scripts available for deploying the overcloud, `instack-deploy-overcloud` and `instack-deploy-tuskar-cli` (see the "Deploying the Overcloud Using Heat" and "Deploying the Overcloud Using Tuskar" sections below for the differences in these scripts). Note these scripts to deploy the overcloud can be configured for individual environments via environment variables. The variables you can set are documented below and need to be defined (and exported) before calling the deploy scripts. For convenience, you can define the variable values and save them to an rc file. Source the rc file before calling the scripts to deploy the overcloud.

    # CPU: number of cpus on baremetal nodes
    # MEM: amount of ram on baremetal nodes, in MB
    # DISK: amount of disk on baremetal nodes, in GB
    # ARCH: architecture of baremetal nodes, amd64 or i386
    # MACS: list of MAC addresses of baremetal nodes
    # PM_IPS: list of Power Management IP addresses
    # PM_USERS: list of Power Management Users
    # PM_PASSWORDS: list of Power Management Passwords
    # NeutronPublicInterface: Overcloud management interface name
    # OVERCLOUD_LIBVIRT_TYPE: Overcloud libvirt type, qemu or kvm
    # NETWORK_CIDR: neutron network cidr
    # FLOATING_IP_START: floating ip allocation start
    # FLOATING_IP_END: floating ip allocation end
    # FLOATING_IP_CIDR: floating ip network cidr

Default values for these variables are set in the deploy scripts. View the scripts to see the default variable values.

</li>
### Scaling the Overcloud Nodes

<li>
To scale the Compute, Block Storage or Swift Storage nodes, you can override the default values from the overcloud deploy scripts by adding scale definitions in your rc file. The defaults for those scripts are:

    COMPUTESCALE=${COMPUTESCALE:-1}
    BLOCKSTORAGESCALE=${BLOCKSTORAGESCALE:-1}
    SWIFTSTORAGESCALE=${SWIFTSTORAGESCALE:-0}

</li>
</ol>
## Deploying the Overcloud Using Heat

To deploy the overcloud using the provided Heat templates, run:

    instack-deploy-overcloud

## Deploying the Overcloud Using Tuskar

To deploy the overcloud using the [Tuskar](https://wiki.openstack.org/wiki/TripleO/Tuskar) CLI, run:

    instack-deploy-tuskar-cli

## Testing the Overcloud

Run the test-overcloud script to launch a Fedora image on the overcloud and wait until it pings successfully

    instack-test-overcloud

## Next Steps
