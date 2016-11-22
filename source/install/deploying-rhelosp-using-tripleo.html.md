---
title: Deploying RHELOSP using TripleO
authors: slagle, tzumainn
wiki_title: Deploying RHELOSP using TripleO
wiki_revision_count: 14
wiki_last_updated: 2014-12-19
---

# Deploying RHELOSP using TripleO

Red Hat Enterprise Linux OpenStack Platform version 6.0 can be deployed using TripleO. The TripleO tooling includes Tuskar, a UI tool for deploying OpenStack.

The process is largely the same as the process for RDO, so be sure to be familiar with the steps at [Deploying_RDO_using_Instack](/install/deploying-rdo-using-instack/).

This page will document the differences needed to the RDO instructions in order to use RHELOSP instead of RDO.

## Use RHEL 7 instead of Fedora 20

All systems must be RHEL 7 instead of Fedora 20. This includes the virtual host if using a virtual machine environment and the baremetal Undercloud system if using all baremetal.

## Prerequisites for installing `instack-undercloud`

Enable the RHELOSP repositories instead of the RDO and EPEL repositories before installing `instack-undercloud`. This must be done on both the virtual host if using a virtual machine environment and the Undercloud system for both virtual and baremetal environments. The easiest and tested way to do this is to create a yum repo configuration file that provides access to the needed repositories for RHELOSP and RHEL. For RHEL content, access to the RHEL 7 Base, RHEL 7 Optional, RHEL 7 Extras and RHEL 7 HA repositories is required.

Then proceed with installing the `instack-undercloud` rpm.

## Prerequisites for running `instack-virt-setup`

If using a virtual manchine environment, prior to running `instack-virt-setup`, the following steps must be performed.

Download the RHEL 7 guest image from the Red Hat Customer Portal [<https://access.redhat.com/downloads/content/69/ver=/rhel>---7/7.0/x86_64/product-downloads].

The following environment variables must be defined in the shell environment

      export RHOS=1
      export NODE_DIST="rhel7"
      export DIB_YUM_REPO_CONF=/path/to/yum/repo-file.repo
      # The name of the guest image downloaded from the Red Hat Customer Portal
      export DIB_LOCAL_IMAGE="/path/to/rhel-guest-image-7.0-20140930.0.x86_64.qcow2"
      export REG_METHOD=disable
      export REG_HALT_UNREGISTER=1

Then proceed with running `instack-virt-setup`

## Prerequisites for running `instack-install-undercloud`

Prior to running `instack-install-undercloud`, Overcloud images must be built on the Undercloud.

Download the RHEL 7 guest image from the Red Hat Customer Portal [<https://access.redhat.com/downloads/content/69/ver=/rhel>---7/7.0/x86_64/product-downloads].

The following environment variables must be defined in the shell environment

      export RHOS=1
      export NODE_DIST="rhel7"
      export DIB_YUM_REPO_CONF=/path/to/yum/repo-file.repo
      # The name of the guest image downloaded from the Red Hat Customer Portal
      export DIB_LOCAL_IMAGE="/path/to/rhel-guest-image-7.0-20140930.0.x86_64.qcow2"
      export REG_METHOD=disable
      export REG_HALT_UNREGISTER=1

The following command will then create all the Overcloud images, and they will be saved in the current directory.

      instack-build-images

## Prerequisites for running `instack-test-overcloud` in a virtual machine environment

Prior to running `instack-test-overcloud` in a virtual machine environment, an updated version of the Fedora cloud image must be downloaded as the RHEL guest image does not boot under qemu only virtualization. Use the following command on the Undercloud to download the updated Fedora cloud image.

`curl -o /home/stack/fedora-user.qcow2 `[`http://dl.fedoraproject.org/pub/alt/openstack/20/x86_64/Fedora-x86_64-20-20140618-sda.qcow2`](http://dl.fedoraproject.org/pub/alt/openstack/20/x86_64/Fedora-x86_64-20-20140618-sda.qcow2)

## Using a Satellite Server for RHELOSP and RHEL Content

While not as extensively tested, it is also possible to use a Satellite server for RHELOSP and RHEL Content.

When using a Satellite Server, the following set of environment variables should be defined in your environment prior to running `instack-virt-setup`, `instack-install-undercloud`, or `instack-build-images`.

      export RHOS=1
      export NODE_DIST="rhel7"
      # The name of the guest image downloaded from the Red Hat Customer Portal
      export DIB_LOCAL_IMAGE="/path/to/rhel-guest-image-7.0-20140930.0.x86_64.qcow2"
      export REG_METHOD=satellite
`export REG_SAT_URL="`[`http://`](http://)<satellite-server"
 # Find this with `subscription-manager list --available`
 export REG_POOL_ID="<pool-id>`"`
      export REG_USER="`&lt;username&gt;`"
      export REG_PASSWORD="`<password>`"
      export REG_REPOS="`<list of space separated repositories>`"

`REG_REPOS` should be a space seperated list of repository id's for RHELOSP 6, RHEL 7 Base, RHEL 7 Optional, RHEL 7 Extras, and RHEL 7 HA.
