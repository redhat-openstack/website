---
title: TripleO quickstart
authors: athomas, hewbrocca, jcoufal, jistr, snecklifter, trown
wiki_title: RDO Manager
wiki_revision_count: 49
wiki_last_updated: 2016-01-11
---

* [Virtual Environment Quickstart](#veqs)
* [Quickstart USB Key](/tripleo/oooq-usbkey)
* [Further reading](#reading)
* [Presentations](#presentations)

# <a name="qs">TripleO quickstart</a>

TripleO is an OpenStack Deployment & Management tool. It is developed upstream as the [OpenStack TripleO](http://wiki.openstack.org/wiki/TripleO) project, but we have a special love for it in RDO-land.

## <a name="veqs">Virtual environment quickstart</a>

There is an [Ansible-based](https://www.ansible.com/) project called [tripleo-quickstart](https://github.com/openstack/tripleo-quickstart) whose main goal is to quickly stand up TripleO environments using an image-based undercloud approach similar to the [OPNFV Apex project](http://artifacts.opnfv.org/apex/docs/installation-instructions/).

You will need a host machine (referred to as `$VIRTHOST`) with at least 16GB of RAM, preferably 32GB, and you must be able to ssh to the `$VIRTHOST` machine as root without a password from the machine running Ansible. The `$VIRTHOST` machine must be running a recent Red Hat-based Linux distribution (such as CentOS 7 or RHEL 7, but only CentOS 7 is currently tested).

A quick way to test that your `$VIRTHOST` machine is ready to rock is:

    $ ssh root@$VIRTHOST uname -a

The defaults are meant to *just work*, so it is as easy as downloading and running the `quickstart.sh` script.

The `quickstart.sh` script will install this repo along with Ansible in a virtual environment and run the `quickstart` playbook.

The ```quickstart.sh``` script also has some dependencies that must be installed on the local system before it can run. You can install the necessary dependencies by running:

```
$ sudo bash quickstart.sh --install-deps
```

**Note:** The `quickstart` playbook will delete the ``stack`` user on the $VIRTHOST and recreate it:

    $ export VIRTHOST='my_test_machine.example.com'
    $ curl -O https://raw.githubusercontent.com/openstack/tripleo-quickstart/master/quickstart.sh
    $ bash quickstart.sh $VIRTHOST

This script will output instructions at the end to access the deployed undercloud. If a release name is not given, ``mitaka`` is used.

## TripleO USB key

The TripleO USB key combines tripleo-quickstart and prebuilt RDO OpenStack images into a USB key for a plug and play TripleO install experience.

*    [Learn more about the TripleO USB key](/tripleo/oooq-usbkey)

## <a name="reading">Further reading</a>

Upstream TripleO documentation:

* [http://docs.openstack.org/developer/tripleo-docs/](http://docs.openstack.org/developer/tripleo-docs/)

> **Note:** Limit your environment specific content in the menu on the left-hand side of the documentation page.

TripleO (RDO-Manager) HA setup:

* [Great blog post on RDO-Manager HA setup](https://remote-lab.net/rdo-manager-ha-openstack-deployment)

* [TripleO YouTube Channel](https://www.youtube.com/channel/UCNGDxZGwUELpgaBoLvABsTA/)

## <a name="presentations">Presentations</a>

tripleo-quickstart demo (March 9, 2016):

*   [tripleo-quickstart tag based breakpoint demo](https://www.youtube.com/watch?v=4O8KvC66eeU)

OpenStack Summit, Vancouver (May 22, 2015):

*   [RDO-Manager: Deploying OpenStack Kilo, Vancouver Summit Demo](http://youtu.be/731INn1GDmk)

Post Demo 5 (April 21, 2015):

*   [RDO-Manager Deployment Flow Using Instack Scripts (non-narrated)](http://youtu.be/TyK0df3mCM8)

Demo 3 (March 9, 2015):

*   [RDO-Manager Deployment Flow (non-narrated)](http://youtu.be/zKG-CB8WdTg)

## Get in touch

*   IRC: **#tripleo** and **#rdo** channels on [Freenode](http://freenode.net).
*   Mailing list: [**rdo-list**](//www.redhat.com/mailman/listinfo/rdo-list), using **[TripleO]** tag in the subject of the email.

