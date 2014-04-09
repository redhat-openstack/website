---
title: Deploying RDO on a Baremetal Environment using Instack
authors: ccrouch, rbrady, rlandy, slagle
wiki_title: Deploying RDO on a Baremetal Environment using Instack
wiki_revision_count: 98
wiki_last_updated: 2014-10-28
---

# Deploying RDO on a Baremetal Environment using Instack

THIS PAGE IS A WORK IN PROGRESS

## Requirements

*   machine specs/ space/memory requirements
*   get MAC addresses
*   add user
*   passwordless sudo

## Installing the undercloud with Instack

1.  Enable the openstack-m repository
        sudo yum -y install http://repos.fedorapeople.org/repos/openstack-m/openstack-m/openstack-m-release-icehouse-2.noarch.rpmT

2.  Enable the fedora-openstack-m-testing yum repository.
         sudo yum-config-manager --enable fedora-openstack-m-testing

Install instack-undercloud

         sudo yum -y install instack-undercloud

         Create and edit your answers file. The descriptions of the parameters that can be set are in the sample answers file.

         # Answers file must exist in home directory for now
         # Use either the baremetal answers file
         cp /usr/share/doc/instack-undercloud/instack-baremetal.answers.sample ~/instack.answers
         # Perform any answer file edits

         Run script to install undercloud. The script will produce a lot of output on the sceen. It also logs to ~/.instack/install-undercloud.log. You should see install-undercloud Complete! at the end of a successful run.

         instack-install-undercloud-packages

         Once the install script has run to completion, you should take note to secure and save the files /root/stackrc and /root/tripleo-undercloud-passwords. Both these files will be needed to interact with the installed undercloud. You may copy these files to your home directory to make them easier to source later on, but you should try to keep them as secure and backed up as possible.

That completes the Undercloud install. To proceed with deploying and using the overcloud see Deploying the Overcloud section below.
