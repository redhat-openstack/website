---
title: Deploying RDO on a Baremetal Environment using Instack
authors: ccrouch, rbrady, rlandy, slagle
wiki_title: Deploying RDO on a Baremetal Environment using Instack
wiki_revision_count: 98
wiki_last_updated: 2014-10-28
---

# Deploying RDO on a Baremetal Environment using Instack

THIS PAGE IS A WORK IN PROGRESS

## Overview

You should select a host machine with at least 12G of memory and 200G disk space. The virt setup creates 5 virtual machines consisting of 2G of memory and 30G of disk space each. If you do not plan to deploy Block Storage or Swift Storage nodes, you can delete those virtual machines and require less space accordingly. Most of the virtual machine disk files are thinly provisioned and won't take up the full 30G. The undercloud is not thinly provisioned and is completely pre-allocated.

If you're connecting to the virt host remotely from ssh, you will need to use the -t flag to force pseudo-tty allocation or enable notty via a $USER.notty file.

## Minimum System Requirements

*   A quad core CPU
*   12GB memory.
*   200GB disk space

## Preparing the Host Machine

TODO: Add setenforce=0 , passwordless sudo and notty.

## Recommended Default Values

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

## Installing the undercloud with Instack

         Enable the openstack-m repository

`   sudo yum -y install `[`http://repos.fedorapeople.org/repos/openstack-m/openstack-m/openstack-m-release-icehouse-2.noarch.rpm`](http://repos.fedorapeople.org/repos/openstack-m/openstack-m/openstack-m-release-icehouse-2.noarch.rpm)

         Enable the fedora-openstack-m-testing yum repository.

         sudo yum-config-manager --enable fedora-openstack-m-testing

         Install instack-undercloud

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
