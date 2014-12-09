---
title: Deploying RHELOSP using TripleO
authors: slagle, tzumainn
wiki_title: Deploying RHELOSP using TripleO
wiki_revision_count: 14
wiki_last_updated: 2014-12-19
---

# Deploying RHELOSP using TripleO

Red Hat Enterprise Linux OpenStack Platform version 6.0 can be deployed using TripleO. The TripleO tooling includes Tuskar, a UI driven tool for the deployment of OpenStack.

The process is largely the same as the process for RDO, so be sure to be familiar with the steps at [Deploying_RDO_using_Instack](Deploying_RDO_using_Instack).

This page will document the differences needed to the RDO instructions in order to use RHELOSP instead of RDO.

## Use RHEL 7 instead of Fedora 20

All systems must be RHEL 7 instead of Fedora 20. This includes the virtual host if using a virtual machine environment and the baremetal Undercloud system if using all baremetal.

## Use RHELOSP instead of RDO

Enable the RHELOSP repositories instead of the RDO and EPEL repositories. This must be done on both the virtual host if using a virtual machine environment and the Undercloud system for both virtual and baremetal environments.. Register to a Satellite Server that configures the RHELOSP 6.0 repositories. Access to the Optional, Extras and HA repositories is also required.

If not using a Satellite Server, use a yum repo file that is configured and installed under /etc/yum.repos.d. Once the yum repo file is in place, you must define the following environment variable before running `instack-virt-setup` on the virtual host and `instack-install-undercloud` on the Undercloud.

      export DIB_YUM_REPO_CONF=/etc/yum.repos.d/`<rhelosp-repo-file>`.repo

Replace `<rhelosp-repo-file>` with the actual name of the file.

## Building Overcloud images

Before the Undercloud is installed via `instack-install-undercloud`, the Overcloud images must be built. After configuring the yum repository on the Undercloud (see previous section), and instack-undercloud is installed, use the following steps to build the Overcloud images.

      export RHOS=1
      export DIB_YUM_REPO_CONF=/etc/yum.repos.d/`<rhelosp-repo-file>`.repo
      export REG_METHOD=disable
      instack-build-images
