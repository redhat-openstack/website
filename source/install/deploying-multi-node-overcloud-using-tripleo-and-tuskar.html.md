---
title: Deploying Multi Node Overcloud Using TripleO And Tuskar
authors: rlandy
wiki_title: Deploying Multi Node Overcloud Using TripleO And Tuskar
wiki_revision_count: 20
wiki_last_updated: 2014-03-18
---

# Deploying Multi Node Overcloud Using TripleO And Tuskar

## Background

This task follows the steps to install RDO using the [Tuskar](//wiki.openstack.org/wiki/TripleO/Tuskar) and [TripleO](//wiki.openstack.org/wiki/TripleO) projects. The install is done via packages. Note that any pages linked and any information in the linked pages are part of a rapidly changing project and are likely to be modified.

The goal of the task is to:

      - install the Undercloud
      - download images needed for the Overcloud
      - deploy an Overcloud with one Control node, Two Compute nodes and Two Block Storage nodes using Heat
      - test that this Overcloud is functional by deploying a test instance within it
      - tear down the Overcloud
      - re-deploy the same Overcloud using Tuskar
      - test that Overcloud

## Undercloud Setup

The steps to install the undercloud are listed in: <https://github.com/agroup/instack-undercloud/blob/448c33085838c671fa0ee82541fbb76a6c52a533/README-packages.md>. These steps should be executed on Fedora 20.

Note that this task's install uses the instack-baremetal.answers.sample answers file.

## Setup for Overcloud

Download the images needed for the Overcloud and load those images into Glance on the Undercloud following the steps listed here: <https://github.com/agroup/instack-undercloud/blob/master/scripts/instack-prepare-for-overcloud>

Note that the images referenced in the link above may not always be available.

## Deploying an Overcloud

Once the images are available in Glance, to deploy the overcloud using Heat, you can either:

      - run 'deploy-overcloud' script 
      - manually follow the steps in /usr/share/deploy-overcloud

Note:

      - you need to set values that are appropriate to your environment for the environment variables used deploying the Overcloud:  - $TRIPLEO_ROOT, $CPU, $MEM, $DISK, $ARCH, "$MACS", $PM_IPS",  "$PM_USERS",  "$PM_PASSWORDS", $NeutronPublicInterface, $OVERCLOUD_LIBVIRT_TYPE
      - to deploy an Overcloud with Block Storage, you will need to include /usr/share/tripleo-heat-templates/block-storage.yaml when building the overcloud.yaml file
      - to deploy an Overcloud with multiple Compute or Block Storage nodes, you need to modify the --scale (or COMPUTESCALE) argument.

## Overcloud Test Steps

Test the Overcloud by deploying a test instance by either:

      - running the "test-overcloud" script
      - or manually executing the steps in /usr/share/test-overcloud.

You should be able to ping the test instance but may not be able to ssh to it.

## Deploy the Overcloud using Tuskar

Note that some of the instructions linked below are changing. Please contact the team on IRC Freenode #rdo channel with questions.

To test the deploying the Overcloud with Tuskar,

      - Tear down the current Overcloud (heat stack-delete overcloud) and remove the baremetal nodes (nova baremetal-node-delete)
      - Configure Tuskar.  Edit /etc/tuskar/tuskar.conf so the following settings are enabled:

    connection=sqlite:////home/stack/tuskar.sqlite   
    tht_local_dir=/usr/share/tripleo-heat-templates/
    username=admin  # OS_USERNAME from /etc/sysconfig/stackrc
    password=unset   # OS_PASSWORD from /etc/sysconfig/stackrc
    tenant_name=admin  # OS_TENANT_NAME from /etc/sysconfig/stackrc
    auth_url=http://localhost:5000/v2.0   
    insecure=true 

      - Initialise the Tuskar database and restart the service

    sudo tuskar-dbsync --config-file /etc/tuskar/tuskar.conf
    sudo service openstack-tuskar-api restart

      - Follow the steps linked here to deploy the Overcloud using Tuskar: `[`https://github.com/agroup/instack-undercloud/blob/master/scripts/instack-deploy-overcloud-tuskarcli`](https://github.com/agroup/instack-undercloud/blob/master/scripts/instack-deploy-overcloud-tuskarcli)` 
      - Be aware of syntax changes for tuskar overcloud-create: "--attributes" is now "--attribute" and "--roles" is now "--role-count"
      - To deploy multiple Compute or Block Storage nodes, change the number of the roles in "tuskar overcloud-create"

You can test the Overcloud using the "test-overcloud" script mentioned in the section above.
