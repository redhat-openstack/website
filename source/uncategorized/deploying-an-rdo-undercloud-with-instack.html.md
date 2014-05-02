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

If you're using the [ Virtual Machine Environment](Deploying RDO to a Virtual Machine Environment using RDO via Instack) instructions, then complete this section before moving on the Undercloud installation.

The Undercloud image on the instack virtual machine is a minimal install of Fedora 20 with yum-utils and net-tools installed. This section will walk you through installing the instack-undercloud package and then running instack to apply packages.

1. Log into your instack virtual machine as the stack user via the IP you retrieved earlier.

2. Create the virtual-power-key and copy it to the virt host. The user in ssh-copy-id should match the the user you created on the host earlier. Make a note of the user and ip you used here. They will be the VIRTUAL_POWER_USER and VIRTUAL_POWER_HOST values in the instack.answers file discussed later.

    ssh-keygen -t rsa -N '' -C virtual-power-key -f virtual-power-key
        ssh-copy-id -i virtual-power-key.pub stack@192.168.122.1

## Installing the Undercloud with Instack

1.  Make sure you are logged in as a non-root user.
2.  Enable the RDO icehouse repository
        sudo yum install -y http://rdo.fedorapeople.org/openstack-icehouse/rdo-release-icehouse.rpm

3.  Install instack-undercloud
        sudo yum -y install instack-undercloud

4.  Create and edit your answers file. The descriptions of the parameters that can be set are in the sample answers file.
        # Answers file must exist in home directory for now
        # Use the baremetal answers file
        cp /usr/share/doc/instack-undercloud/instack-baremetal.answers.sample ~/instack.answers
        # Perform any answer file edits. 
        The values in the answer file should be suitable for your environment. 
        In particular, check that  the  LOCAL_INTERFACE setting matches the Network Interface on the undercloud used to handle PXE boots.

5.  Run script to install undercloud. The script will produce a lot of output on the screen. It also logs to `~/.instack/install-undercloud.log`. You should see `install-undercloud Complete!` at the end of a successful run.
        instack-install-undercloud-packages

6.  Once the install script has run to completion, you should take note to secure and save the files `/root/stackrc` and `/root/tripleo-undercloud-passwords`. Both these files will be needed to interact with the installed undercloud. You may copy these files to your home directory to make them easier to source later on, but you should try to keep them as secure and backed up as possible.
    That completes the undercloud install and now you should have a running undercloud. For the next steps, see: [ Deploying an RDO Overcloud with Instack ](Deploying an RDO Overcloud with Instack)

    If your install does not complete successfully please see the [ Instack FAQ](Instack FAQ) page for potential solutions.

## Optional: Accessing Undercloud Dashboard

To access horizon on the undercloud, create an ssh tunnel on the virt host where 192.168.122.55 should be changed to reflect your instack virtual machine's actual IP address. This will allow you to use horizon on instack from your virt host. If you need to connect remotely through the virt host, you can chain ssh tunnels as needed. Note: Depending on your virt host configuration, you may need to open up the correct port(s) in iptables.

           ssh -g -N -L 8080:192.168.122.55:80 `hostname`

The default user and password are found in the stackrc file on the instack virtual machine, OS_USERNAME and OS_PASSWORD. You can read more about using the dashboard in the [User Guide](http://docs.openstack.org/user-guide/content/log_in_dashboard.html).
