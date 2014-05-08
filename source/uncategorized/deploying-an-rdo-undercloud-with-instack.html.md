---
title: Deploying an RDO Undercloud with Instack
authors: bnemec, ccrouch, rbrady, slagle, sradvan, timbyr
wiki_title: Deploying an RDO Undercloud with Instack
wiki_revision_count: 46
wiki_last_updated: 2015-01-08
---

# Deploying an RDO Undercloud with Instack

[ ← Deploying RDO using Instack](Deploying RDO using Instack)

## Virtualization Undercloud Preparation

If you are using the [ Virtual Machine Environment](Deploying RDO to a Virtual Machine Environment using RDO via Instack) instructions, then you should complete this section before moving on the Undercloud installation.

The Undercloud image on the instack virtual machine is a minimal install of Fedora 20 with yum-utils and net-tools installed. This section will walk you through installing the instack-undercloud package and then running instack to apply packages.

1. Log into your instack virtual machine as the stack user via the IP address you retrieved earlier.

2. Create the virtual-power-key and copy it to the host. The user in ssh-copy-id should match the the user you created on the host earlier. The IP in ssh-copy-id should be the IP of the virt host machine on the VM network. Make a note of these two values as they will be the VIRTUAL_POWER_USER and VIRTUAL_POWER_HOST settings in the instack.answers file discussed later.

        ssh-keygen -t rsa -N '' -C virtual-power-key -f virtual-power-key
        ssh-copy-id -i virtual-power-key.pub stack@192.168.122.1

To verify this worked just run "ssh -i virtual-power-key stack@192.168.122.1" from the instack virtual machine and you should be logged back into the virt host without receiving a password prompt.

## Installing the Undercloud with Instack

1.  Make sure you are logged in, as a non-root user e.g. stack, to the node you want to install the undercloud on. For a virt setup this will be a VM called "instack", for a bare metal setup this will be the host you selected while preparing the environment.
2.  Enable the RDO icehouse repository
        sudo yum install -y http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm

3.  Install instack-undercloud
        sudo yum -y install instack-undercloud

4.  Create and edit your answers file. The descriptions of the parameters that can be set are in the sample answers file. Choose the file that matches your environment
        # Answers file must exist in home directory for now
        BAREMETAL
        # Use the baremetal answers file
        cp /usr/share/doc/instack-undercloud/instack-baremetal.answers.sample ~/instack.answers

        VIRTUAL ENVIRONMENTS
        # Use  the  virt sample answers file
        cp /usr/share/doc/instack-undercloud/instack-virt.answers.sample ~/instack.answers

        # Perform any answer file edits. 
        The values in the answer file should be suitable for your environment. 
        In particular, check that  the  LOCAL_INTERFACE setting matches the Network Interface on the undercloud used to handle PXE boots.

5.  Run script to install undercloud. The script will produce a lot of output on the screen. It also logs to `~/.instack/install-undercloud.log`. You should see `install-undercloud Complete!` at the end of a successful run.
        instack-install-undercloud-packages

6.  Once the install script has run to completion, you should take note to secure and save the files `/root/stackrc` and `/root/tripleo-undercloud-passwords`. Both these files will be needed to interact with the installed undercloud. You may copy these files to your home directory to make them easier to source later on, but you should try to keep them as secure and backed up as possible.
    That completes the undercloud install and now you should have a running undercloud. For the next steps, see: [ Deploying an RDO Overcloud with Instack ](Deploying an RDO Overcloud with Instack)

    If your install does not complete successfully, please see the [ Instack FAQ](Instack FAQ) page for potential solutions.
