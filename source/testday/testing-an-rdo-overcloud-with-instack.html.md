---
title: Testing an RDO Overcloud with Instack
authors: ccrouch, rbrady, slagle
wiki_title: Testing an RDO Overcloud with Instack
wiki_revision_count: 4
wiki_last_updated: 2014-10-27
---

# Testing an RDO Overcloud with Instack

[← Deploying RDO using Instack](/install/deploying-rdo-using-instack/)

1. While logged into the undercloud node export the required variables into your shell in order to use the CLI tools for the undercloud and overcloud. If you copied the stackrc file into your home directory at the end of the undercloud installation, simply source that file. Alternatively, you can use the following command directly to set the needed environment variables.

      command $(sudo cat /root/stackrc | xargs)

2. Run the `instack-test-overcloud` script to launch a Fedora image on the overcloud and wait until it pings successfully

    instack-test-overcloud

The `instack-test-overcloud` script will test block storage by:

*   Creating a new volume
*   Attaching the volume to the Compute instance, and then
*   Using `ssh` to log on to the instance and partition, format, and mount the volume

The `instack-test-overcloud` script will test object storage by:

*   Uploading a file with data to the node
*   Testing the data content downloaded from the node
