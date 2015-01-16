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

### tuskar plan-list

The tuskar plan-list command wil output a list of all of the plans in the Tuskar API. Currently this is limited to one plan with the name overcloud. Example output from this command can be seen below.

         $ tuskar plan-list
         +--------------------------------------+-----------+-------------+----------------------------------------------------+
         | uuid                                 | name      | description | roles                                              |
         +--------------------------------------+-----------+-------------+----------------------------------------------------+
         | d9ac81d2-1f69-450d-91d3-64fed8081e8f | overcloud | None        | controller, swift-storage, compute, cinder-storage |
         +--------------------------------------+-----------+-------------+----------------------------------------------------+

### tuskar plan-show

The plan show command will display the full details of your plan and the roles which have been added to it.

usage: tuskar plan-show <PLAN UUID>

### tuskar plan-patch

### tuskar plan-templates

### tuskar plan-add-role

### tuskar plan-create

Create a new plan.

usage: tuskar plan-create [-d <DESCRIPTION>] name

Where name is the name of the plan to create. Description is an optional argument specifying a user-readable text for describing the Plan.

        $ tuskar plan-create -d 'My Plan' my_plan
        +-------------+--------------------------------------+
        | Property    | Value                                |
        +-------------+--------------------------------------+
        | created_at  | 2015-01-16T14:27:34                  |
        | description | My Plan                              |
        | name        | my_plan                              |
        | parameters  |                                      |
        | roles       |                                      |
        | updated_at  | None                                 |
        | uuid        | e09572b6-eed2-41c0-9d98-f7d5d0872ff8 |
        +-------------+--------------------------------------+

### tuskar plan-delete

Delete a plan given a UUID.

usage: tuskar plan-delete <PLAN UUID>

### tuskar plan-remove-role

Remove role from a plan.

usage: tuskar plan-remove-role -r <ROLE UUID> <PLAN UUID>

### tuskar role-list

The role list command will display the roles that are available to be added to a plan. This command takes no arguments.

        $ tuskar role-list
        +--------------------------------------+----------------+---------+----------------------------------------------------------------+
        | uuid                                 | name           | version | description                                                    |
        +--------------------------------------+----------------+---------+----------------------------------------------------------------+
        | 0932afdb-39b3-41bc-b530-359e487e79e4 | compute        | 1       | OpenStack hypervisor node. Can be wrapped in a ResourceGroup fo|
        |                                      |                |         | r scaling.                                                     |
        | 62e7ca60-98a4-4231-b793-9d546c2bd1c9 | cinder-storage | 1       | Common Block Storage Configuration                             |
        | 79caea1a-f8fc-4eee-b663-40f89744382c | controller     | 1       | OpenStack control plane node. Can be wrapped in a ResourceGroup|
        |                                      |                |         | for scaling.                                                   |
        | b106841c-6fbe-4a78-afff-3cfccb509861 | swift-storage  | 1       | Common Swift Storage Configuration                             |
        +--------------------------------------+----------------+---------+----------------------------------------------------------------+

## Advanced Install

In the quick usage above, we rely on instack for most of the interactions with Tuskar. For a more custom install, we can follow these steps manually. They make use of the tuskar commands described above to interact with the Tuskar API.
