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

1.  Make sure you are logged in as a non-root user (such as the stack user), on the node you want to install the undercloud onto.
    If you used the virt setup this node will be a VM called "instack" and you can use the stack user. The initial password is also stack. It is recommended to change this password on login to the vm.
    For a baremetal setup this will be the host you selected for the Undercloud while preparing the environment.
2.  Enable the RDO juno repository
        sudo yum install -y http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm

3.  We must also enable the copr and stage repositories, and install a test tuskar-ui build from koji.
        # Enable the copr repository
        sudo curl -o /etc/yum.repos.d/slagle-openstack-m.repo https://copr.fedoraproject.org/coprs/slagle/openstack-m/repo/fedora-20/slagle-openstack-m-fedora-20.repo
        # Enable the stage RDO repo
        sudo sed -i 's#^baseurl.*#baseurl=http://team.virt.bos.redhat.com/openstack/openstack-juno/fedora-$releasever/#' /etc/yum.repos.d/rdo-release.repo
        # Install a new tuskar-ui build from koji
        sudo yum -y install https://kojipkgs.fedoraproject.org//packages/openstack-tuskar-ui/0.2.0/5.fc22/noarch/openstack-tuskar-ui-0.2.0-5.fc22.noarch.rpm

4.  Install instack-undercloud
        sudo yum -y install instack-undercloud

5.  Download the Overcloud images from <http://file.rdu.redhat.com/~bnemec/fedora-juno-koji/>
    You can use any method you choose to downlad them, an example wget command is shown below

        wget -r -nd -np --reject "index.html*" http://file.rdu.redhat.com/~bnemec/fedora-juno-koji/ 

6.  Create and edit your answers file. In a virtualized setup, this has already been done for you, so you can skip this step. Otherwise, copy the sample answers file into your home directory. The descriptions of the parameters that can be set are in the sample answers file itself.
        # Answers file must exist in home directory for now
        # Copy the sample answers file to your home directory
        cp /usr/share/instack-undercloud/instack.answers.sample ~/instack.answers

        # Perform any answer file edits. 
        # The values in the answer file should be suitable for your environment. 
        # In particular, check that  the  LOCAL_INTERFACE setting matches the Network Interface on the undercloud used as the provisioning network to handle PXE boots.

7.  Run script to install undercloud. The script will produce a lot of output on the screen. It also logs to `~/.instack/install-undercloud.log`. You should see `instack-install-undercloud complete.` along with the details about the stackrc file at the end of a successful run.
        instack-install-undercloud

8.  Once the install script has run to completion, you should take note of the files `/root/stackrc` and `/root/tripleo-undercloud-passwords`. Both these files will be needed to interact with the installed undercloud.
    That completes the undercloud install and now you should have a running undercloud. For the next steps, see: [ Deploying an RDO Overcloud with Instack ](Deploying an RDO Overcloud with Instack)

    If your install does not complete successfully, please see the [ Instack FAQ](Instack FAQ) page for potential solutions.
