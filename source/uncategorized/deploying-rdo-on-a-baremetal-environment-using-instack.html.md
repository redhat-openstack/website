---
title: Deploying RDO on a Baremetal Environment using Instack
authors: ccrouch, rbrady, rlandy, slagle
wiki_title: Deploying RDO on a Baremetal Environment using Instack
wiki_revision_count: 98
wiki_last_updated: 2014-10-28
---

# Deploying RDO on a Baremetal Environment using Instack

[ ← Deploying RDO using Instack](Deploying RDO using Instack)

## Minimum System Requirements

This setup requires an environment with at least five baremetal machines (one machine for the undercloud and four for the overcloud nodes). The setup has been tested successfully using baremetal machines each with:

*   2 12-core CPUs
*   32GB memory
*   200GB disk space

The setup *may* work on machines with a lower specification. If you do not plan to deploy Block Storage or Swift Storage nodes, you can set those scaling options to zero and you will need fewer baremetal machines accordingly. Note that the undercloud and overcloud nodes will be set up to run Fedora 20 x86_64 only.

## Preparing the Baremetal Environment

### Networking

Instack parallels sections the flow described in [TripleO devtest](http://docs.openstack.org/developer/tripleo-incubator/devtest.html). The overcloud nodes will be deployed from the undercloud machine and therefore the machines need to have have their network settings modified to allow for the overcloud nodes to be PXE boot'ed using the undercloud machine. As such, the setup requires that:

*   all machines (including the undercloud machine) in the setup must support IPMI

<!-- -->

*   one NIC from every machine needs to be on its own broadcast domain. In the tested environment, this required setting up a new VLAN on the switch. Note that you should use the "same" NIC on each of the overcloud machines ( for example: use the second NIC on each overcloud machine).

<!-- -->

*   the overcloud machines can PXE boot off the NIC that is on the private VLAN. In the tested environment, this required disabling network booting in the BIOS for all NICs other than the one we wanted to boot and then ensuring that the chosen NIC is at the top of the boot order (ahead of the local hard disk drive and CD/DVD drives).

<!-- -->

*   you have the MAC addresses of the NICs, the IPMI IP addresses, the user names and passwords for each of the overcloud machines.

Note: if the undercloud machine was installed using LVM, when deploying overcloud nodes, you may see an error related to the disk being "in use". The workaround for this error is to:

    # Modify /etc/lvm/lvm.conf to set use_lvmetad to be 0
    vi /etc/lvm/lvm.conf
    use_lvmetad=0
    # Disable and stop relevant services
    systemctl stop lvm2-lvmetad
    systemctl stop lvm2-lvmetad.socket
    systemctl disable lvm2-lvmetad.socket
    systemctl stop lvm2-lvmetad

### Setting Up the Undercloud Machine

1.  Select a machine within the baremetal environment on which to install the undercloud.
2.  Install [Fedora 20 x86_64](https://fedoraproject.org/en/get-fedora) on this machine. See [RDO Quickstart](http://openstack.redhat.com/Quickstart) page for a list of supported platforms for RDO in general. Instack installs have been tested on Fedora 20 x86_64 only.
3.  Add a user account and configure this user to have passwordless sudo access. This user will execute the steps for installation and deployment. The following example should be executed by the `root` user. It adds the user "stack".
        useradd stack
        passwd stack # specify a password
        echo "stack        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/stack
        chmod 0440 /etc/sudoers.d/stack

## Installing the Undercloud with Instack

1.  Enable the RDO icehouse and openstack-m repository
        sudo yum -y install http://repos.fedorapeople.org/repos/openstack-m/openstack-m/openstack-m-release-icehouse-2.noarch.rpm
        sudo yum install -y http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm

2.  Enable the fedora-openstack-m-testing yum repository.
        sudo yum -y install yum-utils
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
    That completes the undercloud install and now you should have a running undercloud. For the next steps, see: [ Deploying an RDO Overcloud with Instack ](Deploying an RDO Overcloud with Instack)
