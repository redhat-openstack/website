---
title: Deploying an RDO Undercloud with Instack
authors: bnemec, ccrouch, rbrady, slagle, sradvan, timbyr
wiki_title: Deploying an RDO Undercloud with Instack
wiki_revision_count: 46
wiki_last_updated: 2015-01-08
---

# Deploying an RDO Undercloud with Instack

[ ← Deploying RDO using Instack](Deploying RDO using Instack)

## Installing the Undercloud with Instack

1.  Make sure you are logged in as a non-root user, e.g. stack, on the node you want to install the undercloud onto. For a virt setup this will be a VM called "instack", for a bare metal setup this will be the host you selected while preparing the environment.
2.  Enable the RDO icehouse repository
        sudo yum install -y http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm

3.  Install instack-undercloud
        sudo yum -y install instack-undercloud

4.  Create and edit your answers file. In a virtualized setup, this has already been done for you. The descriptions of the parameters that can be set are in the sample answers file. Choose the file that matches your environment
        # Answers file must exist in home directory for now
        BAREMETAL
        # Use the baremetal answers file
        cp /usr/share/doc/instack-undercloud/instack-baremetal.answers.sample ~/instack.answers

        # Perform any answer file edits. 
        The values in the answer file should be suitable for your environment. 
        In particular, check that  the  LOCAL_INTERFACE setting matches the Network Interface on the undercloud used to handle PXE boots.

5.  Run script to install undercloud. The script will produce a lot of output on the screen. It also logs to `~/.instack/install-undercloud.log`. You should see `instack-install-undercloud-packages complete!` at the end of a successful run.
        instack-install-undercloud-packages

6.  Once the install script has run to completion, you should take note of the files `/root/stackrc` and `/root/tripleo-undercloud-passwords`. Both these files will be needed to interact with the installed undercloud.
    That completes the undercloud install and now you should have a running undercloud. For the next steps, see: [ Deploying an RDO Overcloud with Instack ](Deploying an RDO Overcloud with Instack)

    If your install does not complete successfully, please see the [ Instack FAQ](Instack FAQ) page for potential solutions.
