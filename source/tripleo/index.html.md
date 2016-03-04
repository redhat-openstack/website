---
title: RDO-Manager
authors: athomas, hewbrocca, jcoufal, jistr, snecklifter, trown
wiki_title: RDO-Manager
wiki_revision_count: 49
wiki_last_updated: 2016-01-11
---

# TripleO

TripleO is an OpenStack Deployment & Management tool. It is developed upstream as the [OpenStack TripleO](http://wiki.openstack.org/wiki/TripleO) project, but we have a special love for it in RDO-land.

## Virtual Environment Quickstart

There is a recent project called [tripleo-quickstart](https://github.com/redhat-openstack/tripleo-quickstart) whose main goal is to quickly stand up TripleO/RDO-Manager environments using an image based undercloud aproach similar to the [OPNFV Apex project](http://artifacts.opnfv.org/apex/docs/installation-instructions/).

You will need a host machine with at least 16G of RAM, preferably 32G,
with CentOS 7 installed, and able to be ssh'd to as root
without password from the machine running ansible.

A quick way to test that your host machine (referred to as `$VIRTHOST`) is
ready to rock is::

    ssh root@$VIRTHOST uname -a

The defaults are meant to "just work", so it is as easy as
downloading and running the quickstart.sh script.

Or rather it will be once we have a good place to host the
images. The centosci artifacts server drops the http connection
regularly, so we need to use wget for the built in retry with
resume. From the machine that will be the virthost, create a
directory for the undercloud image and wget it. Note, the
image location should be world readable since a ``stack`` user
is used for most steps.::

    mkdir -p /usr/share/quickstart_images/mitaka/
    cd /usr/share/quickstart_images/mitaka/
    wget https://ci.centos.org/artifacts/rdo/images/mitaka/delorean/stable/undercloud.qcow2.md5 \
    https://ci.centos.org/artifacts/rdo/images/mitaka/delorean/stable/undercloud.qcow2

    # Check that the md5sum's match (The playbook will also
    # check, but better to know now whether the image download
    # was ok.)
    md5sum -c undercloud.qcow2.md5

Then use the quickstart.sh script to install this repo along
with ansible in a virtual environment and run the quickstart
playbook. Note, the quickstart playbook will delete the ``stack``
user on the virthost and recreate it.::

    export VIRTHOST='my_test_machine.example.com'
    export UNDERCLOUD_QCOW2_LOCATION=file:///usr/share/quickstart_images/mitaka/undercloud.qcow2

    wget https://raw.githubusercontent.com/redhat-openstack/tripleo-quickstart/master/quickstart.sh
    bash quickstart.sh -u $UNDERCLOUD_QCOW2_LOCATION $VIRTHOST

This script will output instructions at the end to access the
deployed undercloud.  Note that to use a different release you will need to
download a different undercloud image in the first step above.
For example, for liberty:
https://ci.centos.org/artifacts/rdo/images/liberty/delorean/stable/undercloud.qcow2

Then proceed with the [upstream documentation](http://docs.openstack.org/developer/tripleo-docs/basic_deployment/basic_deployment_cli.html#upload-images) for the rest of the deployment.

## Further Reading

Upstream TripleO docs: <http://docs.openstack.org/developer/tripleo-docs/>

> **Note:** Limit your environment specific content in the upper left corner of the documentation.

[RDO-Manager troubleshooting](rdo-manager-troubleshooting)

[Great blog on RDO-Manager HA setup](https://remote-lab.net/rdo-manager-ha-openstack-deployment/)

## Presentations

OpenStack Summit, Vancouver (May 22, 2015)

*   [RDO-Manager: Deploying OpenStack Kilo, Vancouver Summit Demo](http://youtu.be/731INn1GDmk)

Post Demo 5 (April 21, 2015)

*   [RDO-Manager Deployment Flow Using Instack Scripts (non-narrated)](http://youtu.be/TyK0df3mCM8)

Demo 3 (March 9, 2015)

*   [RDO-Manager Deployment Flow (non-narrated)](http://youtu.be/zKG-CB8WdTg)

## Get in Touch

*   IRC: **#rdo** channel on [Freenode](http://freenode.net)
*   Mailing List: [**rdo-list**](//www.redhat.com/mailman/listinfo/rdo-list), using **[RDO-Manager]** tag in the subject of the e-mail
