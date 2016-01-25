---
title: RDO-Manager
authors: athomas, hewbrocca, jcoufal, jistr, snecklifter, trown
wiki_title: RDO-Manager
wiki_revision_count: 49
wiki_last_updated: 2016-01-11
---

# RDO-Manager

RDO-Manager is an OpenStack Deployment & Management tool for RDO. It is based on [OpenStack TripleO](http://wiki.openstack.org/wiki/TripleO) project and its philosophy is inspired by Spinal Stack project.

## Virtual Environment Quickstart

There is a recent project called [tripleo-quickstart](https://github.com/redhat-openstack/tripleo-quickstart) whose main goal is to quickly stand up TripleO/RDO-Manager environments using an image based undercloud aproach similar to the [OPNFV Apex project](http://artifacts.opnfv.org/apex/docs/installation-instructions/).

You will need a host machine with at least 16G of RAM, preferably 32G,
with CentOS 7 installed, and able to be ssh'd to without password from
the machine running ansible.

The defaults are meant to "just work", so it is as easy as
downloading and running the quickstart.sh script.
This script will install this repo along with ansible in a
virtual environment and run the quickstart playbook::

    export VIRTHOST='my_test_machine.example.com'
    bash <(curl -s https://raw.githubusercontent.com/redhat-openstack/tripleo-quickstart/master/quickstart.sh) [release]

The playbook will output a debug message at the end with instructions
to access the deployed undercloud. If a release name is not given, ``mitaka``
is used.

The install process is not run to completion so that it's easier to clean the
image; to finish the installation, ssh into the undercloud VM and run::

    openstack undercloud install

as the ``stack`` user.

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
