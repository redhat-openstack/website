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

REVIEW REQUIRED

This setup requires an environment with at least five baremetal machines (one machine for the undercloud and four for the overcloud nodes), each with a minimum of 2G of memory and 30G of disk space. If you do not plan to deploy Block Storage or Swift Storage nodes, you can set those scaling options to zero and you will need fewer baremetal machines accordingly. Note that the undercloud and overcloud nodes will run Fedora 20 only.

*   machine specs/ space/memory requirements

## Preparing the Baremetal Environment

REVIEW REQUIRED

1.  Select a machine within the baremetal environment on which to install the undercloud.
2.  Install [Fedora 20](https://fedoraproject.org/en/get-fedora) on this machine.
3.  Add a user account and configure this user to have passwordless sudo access. This user will execute the steps for installation and deployment. The following example should be executed by the `root` user. It adds the user "stack".
        useradd stack
        passwd stack # specify a password
        echo "stack        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/stack
        chmod 0440 /etc/sudoers.d/stack

4.  For the machines being used for the undercloud and overcloud nodes, you will need to find:
    -   IP Addresses
    -   MAC addresses
    -   Users
    -   Passwords

5.  You may need to configure the network settings on the node machines so that the overcloud nodes can be deployed from the undercloud.

## Installing the Undercloud with Instack

1.  Enable the openstack-m repository
        sudo yum -y install http://repos.fedorapeople.org/repos/openstack-m/openstack-m/openstack-m-release-icehouse-2.noarch.rpmT

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
