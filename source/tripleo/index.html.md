---
title: TripleO
authors: athomas, hewbrocca, jcoufal, jistr, snecklifter, trown
wiki_title: RDO Manager
wiki_revision_count: 49
wiki_last_updated: 2016-01-11
---

# TripleO

TripleO is an OpenStack Deployment & Management tool. It is developed upstream as the [OpenStack TripleO](http://wiki.openstack.org/wiki/TripleO) project, but we have a special love for it in RDO-land.

## Virtual Environment Quickstart

There is a recent project called [tripleo-quickstart](https://github.com/redhat-openstack/tripleo-quickstart) whose main goal is to quickly stand up TripleO environments using an image based undercloud aproach similar to the [OPNFV Apex project](http://artifacts.opnfv.org/apex/docs/installation-instructions/).

You will need a host machine with at least 16G of RAM, preferably 32G,
with CentOS 7 installed, and able to be ssh'd to as root
without password from the machine running ansible.

A quick way to test that your host machine (referred to as `$VIRTHOST`) is
ready to rock is::

    ssh root@$VIRTHOST uname -a

The defaults are meant to "just work", so it is as easy as
downloading and running the quickstart.sh script.

The quickstart.sh script will install this repo along
with ansible in a virtual environment and run the quickstart
playbook. Note, the quickstart playbook will delete the ``stack``
user on the virthost and recreate it.::

    export VIRTHOST='my_test_machine.example.com'

    wget https://raw.githubusercontent.com/redhat-openstack/tripleo-quickstart/master/quickstart.sh
    bash quickstart.sh $VIRTHOST

This script will output instructions at the end to access the
deployed undercloud. If a release name is not given, ``mitaka``
is used.

## Further Reading

Upstream TripleO docs: <http://docs.openstack.org/developer/tripleo-docs/>

> **Note:** Limit your environment specific content in the upper left corner of the documentation.

[Troubleshooting](/tripleo/troubleshooting)

[Great blog on RDO-Manager HA setup](https://remote-lab.net/rdo-manager-ha-openstack-deployment/)

## Presentations

tripleo-quickstart demo (March 9, 2016)

*   [tripleo-quickstart tag based breakpoint demo](https://www.youtube.com/watch?v=4O8KvC66eeU)

OpenStack Summit, Vancouver (May 22, 2015)

*   [RDO-Manager: Deploying OpenStack Kilo, Vancouver Summit Demo](http://youtu.be/731INn1GDmk)

Post Demo 5 (April 21, 2015)

*   [RDO-Manager Deployment Flow Using Instack Scripts (non-narrated)](http://youtu.be/TyK0df3mCM8)

Demo 3 (March 9, 2015)

*   [RDO-Manager Deployment Flow (non-narrated)](http://youtu.be/zKG-CB8WdTg)

## Get in Touch

*   IRC: **#rdo** channel on [Freenode](http://freenode.net)
*   Mailing List: [**rdo-list**](//www.redhat.com/mailman/listinfo/rdo-list), using **[TripleO]** tag in the subject of the e-mail
