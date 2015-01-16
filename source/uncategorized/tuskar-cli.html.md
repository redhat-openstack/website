---
title: Tuskar-CLI
authors: bcrochet, d0ugal
wiki_title: Tuskar-CLI
wiki_revision_count: 33
wiki_last_updated: 2015-01-16
---

# Tuskar-CLI

This tutorial covers how to deploy a TripleO Undercloud and Overcloud with the Tuskar command line interface and using RDO and Instack on an all bare metal or an all virtual environment.

## Quick Install

We recommend using Instack to setup the undercloud with Tuskar.

1. Start by following the [Instack instructions](https://openstack.redhat.com/Deploying_RDO_using_Instack) through "Deploying an Undercloud".

## Quick Usage

Once Tuskar is successfully installed in the undercloud with Instack the following steps can be used to deploy the overcloud.

1. First initialise the command line enviroment, this will load the credentials and default settings for a deployment.

         source ~/deploy-overcloudrc
         source ~/tripleo-undercloud-passwords
         source ~/stackrc
         source /usr/share/instack-undercloud/deploy-virt-overcloudrc

2. You are now ready to start the deployment with the following command.

         instack-deploy-overcloud --tuskar

The default settines will deploy the control role to one node and the compute role to one node.

3. To scale your deployment or add new roles to unused nodes, you can scale the deployment. The following commands will deploy four roles over four nodes.

         export CONTROLSCALE=1
         export COMPUTESCALE=1
         export BLOCKSTORAGESCALE=1
         export SWIFTSTORAGESCALE=1
         instack-deploy-overcloud --tuskar

**Note:** Currenlty scale down is not supported.

4. You can view the state of your baremetal machines and their state with the nova client which is already installed and will be usable after setting up the enviroment in step 1.

         nova baremetal-node-list

## Command Line Interface

The Tuskar command line interface has a number of commands for interacting with the Tuskar API.

*   tuskar plan-add-role
*   tuskar plan-create
*   tuskar plan-delete
*   tuskar plan-list
*   tuskar plan-patch
*   tuskar plan-remove-role
*   tuskar plan-show
*   tuskar plan-templates
*   tuskar role-list

## Detailed Install

In the quick usage above, we rely on instack for most of the interactions with Tuskar. For a more custom install, we can follow these steps manually. They make use of the tuskar commands described above to interact with the Tuskar API.
