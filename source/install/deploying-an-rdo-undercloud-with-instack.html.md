---
title: Deploying an RDO Undercloud with Instack
authors: bnemec, ccrouch, rbrady, slagle, sradvan, timbyr
wiki_title: Deploying an RDO Undercloud with Instack
wiki_revision_count: 46
wiki_last_updated: 2015-01-08
---

# Deploying an RDO Undercloud with Instack

[← Deploying RDO using Instack](/install/deploying-rdo-using-instack/)

## Installing the Undercloud with Instack

1.  Make sure you are logged in as a non-root user (such as the stack user), on the node you want to install the undercloud onto.
    If you used the virt setup this node will be a VM called "instack" and you can use the stack user. The initial password is also stack. It is recommended to change this password on login to the vm.
    For a baremetal setup this will be the host you selected for the Undercloud while preparing the environment.
2.  Enable the RDO juno repository
        sudo yum install -y http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm

3.  If on RHEL 7, enable the EPEL repository
        sudo yum install -y http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

4.  Install instack-undercloud
        sudo yum -y install instack-undercloud

5.  For a Fedora 20 Overcloud, download the Overcloud images from <https://repos.fedorapeople.org/repos/openstack-m/tripleo-images-rdo-juno/>
    You can use any method you choose to download them, an example wget command is shown below

        sudo yum -y install wget # install wget if necessary
        wget -r -nd -np --reject "index.html*" https://repos.fedorapeople.org/repos/openstack-m/tripleo-images-rdo-juno/ 

6.  For a RHEL 7 Overcloud, pre-built images can not be shipped due to licensing restrictions. However, it is possible to build images using the <i>instack-build-images</i> script from the instack-undercloud package. See the [Instack FAQ](/install/instack-faq/#how-do-i-build-rhel-7-overcloud-images.3f) for details.
7.  Create and edit your answers file. In a virtualized setup, this has already been done for you, so you can skip this step. Otherwise, copy the sample answers file into your home directory. The descriptions of the parameters that can be set are in the sample answers file itself.
        # Answers file must exist in home directory for now
        # Copy the sample answers file to your home directory
        cp /usr/share/instack-undercloud/instack.answers.sample ~/instack.answers

        # Perform any answer file edits. 
        # The values in the answer file should be suitable for your environment. 
        # In particular, check that  the  LOCAL_INTERFACE setting matches the Network Interface on the undercloud used as the provisioning network to handle PXE boots.

8.  Run script to install undercloud. The script will produce a lot of output on the screen. It also logs to `~/.instack/install-undercloud.log`. You should see `instack-install-undercloud complete.` along with the details about the stackrc file at the end of a successful run.
        instack-install-undercloud

9.  Once the install script has run to completion, you should take note of the files `/root/stackrc` and `/root/tripleo-undercloud-passwords`. Both these files will be needed to interact with the installed undercloud. Copy them to your home directory for easy use later.
        sudo cp /root/tripleo-undercloud-passwords .
        sudo cp /root/stackrc .

    That completes the undercloud install and now you should have a running undercloud. For the next steps, see: [Deploying an RDO Overcloud with Instack](/install/deploying-an-rdo-overcloud-with-instack/)

    If your install does not complete successfully, please see the [Instack FAQ](/install/instack-faq/) page for potential solutions.
