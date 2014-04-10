---
title: Testing an RDO Overcloud with Instack
authors: ccrouch, rbrady, slagle
wiki_title: Testing an RDO Overcloud with Instack
wiki_revision_count: 4
wiki_last_updated: 2014-10-27
---

## Testing the Overcloud

Run the `instack-test-overcloud` script to launch a Fedora image on the overcloud and wait until it pings successfully

    instack-test-overcloud

If your overcloud contains a Block Storage node, the `instack-test-overcloud` script will test that node by:

*   Creating a new volume
*   Attaching the volume to the Compute instance, and then
*   Using `ssh` to log on to the instance and partition, format, and mount the volume

If your overcloud contains a Swift (Object) Storage node, the `instack-test-overcloud` script will test that node by:

*   Uploading a file with data to the node
*   Testing the data content downloaded from the node
