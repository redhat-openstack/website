---
title: Deploying RDO on a Baremetal Environment using Instack
authors: ccrouch, rbrady, rlandy, slagle
wiki_title: Deploying RDO on a Baremetal Environment using Instack
wiki_revision_count: 98
wiki_last_updated: 2014-10-28
---

# Deploying RDO on a Baremetal Environment using Instack

THIS PAGE IS A WORK IN PROGRESS

## Oveview

Works on Fedora 20 only

## Minimum System Requirements

*   machine specs/ space/memory requirements

## Preparing the Baremetal Environment

*   get MAC addresses
*   add user
*   passwordless sudo

## Installing the undercloud with Instack

1.  Enable the openstack-m repository
        sudo yum -y install http://repos.fedorapeople.org/repos/openstack-m/openstack-m/openstack-m-release-icehouse-2.noarch.rpmT

2.  Enable the fedora-openstack-m-testing yum repository.
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
    That completes the undercloud install. To proceed with deploying and using the overcloud see sections below.

## Preparing for Deploying the Overcloud

### Downloading Images for the Overcloud

Once the undercloud is installed, there should be a script `/usr/bin/prepare-for-overcloud` available to be executed by the user. Run the `prepare-for-overcloud` script to set up before deploying the overcloud. This script downloads images to use for deploying Control, Compute, Block Storage and Storage nodes in the overcloud. The script will avoid re-download images if they already exist in the current working directory. If you want to force a re-download of the images, delete those existing images first.

### Environment Variables

There should be two scripts available for deploying the overcloud, `instack-deploy-overcloud` and `instack-deploy-tuskar-cli` (see the "Deploying the Overcloud Using Heat" and "Deploying the Overcloud Using Tuskar" sections below for the differences in these scripts). Note these scripts to deploy the overcloud can be configured for individual environments via environment variables. The variables you can set are documented below and need to be defined (and exported) before calling the deploy scripts. default values for these variables are set in the deploy scripts. View the scripts to see the default variable values.

### Sourcing Files

      You must source the contents of /root/stackrc into your shell before running the instack-* scripts that interact with the undercloud and overcloud. In order to do that you can copy that file to a more convenient location or use sudo to cat the file and copy/paste the lines into your shell environment.

## Deploying the Overcloud Using Heat

## Deploying the Overcloud Using Tuskar

## Testing the Overcloud

## Next Steps
