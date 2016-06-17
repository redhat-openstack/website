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

We recommend using Instack to setup the undercloud with Tuskar. Follow the [Instack instructions](https://rdoproject.org/Deploying_RDO_using_Instack) through "Deploying an Undercloud". This will create the undercloud with the Tuskar UI and Tuskar CLI setup.

## Quick Usage

Once Tuskar has been successfully installed in the undercloud with Instack the following steps can be used to deploy the overcloud.

1. First, initialise the command line enviroment, this will load the credentials and default settings for a deployment.

         source ~/deploy-overcloudrc
         source ~/tripleo-undercloud-passwords
         source ~/stackrc
         source /usr/share/instack-undercloud/deploy-virt-overcloudrc

2. You are now ready to start the default deployment with the following command.

         instack-deploy-overcloud --tuskar

The default settings will deploy the control role to one node and the compute role to one node.

3. You can scale your deployment or add new roles easily by defining the number of nodes for a role. The following commands will deploy four roles over four nodes.

         export CONTROLSCALE=1
         export COMPUTESCALE=1
         export BLOCKSTORAGESCALE=1
         export SWIFTSTORAGESCALE=1
         instack-update-overcloud --tuskar

**Note:** Currenlty scale down is not supported.

4. You can view the state of your baremetal machines and their state with the nova client which is already installed and will be usable after setting up the enviroment in step 1.

         nova baremetal-node-list

See the [nova documentation](http://docs.openstack.org/cli-reference/content/novaclient_commands.html) for futher details around using the nova client.

## Command Line Interface

The Tuskar command line interface has a number of commands for interacting with the Tuskar API.

### tuskar plan-list

The tuskar plan-list command wil output a list of all of the plans in the Tuskar API. Currently this is limited to one plan with the name overcloud. Example output from this command can be seen below.

         $ tuskar plan-list
         +--------------------------------------+-----------+-------------+----------------------------------------------------+
         | uuid                                 | name      | description | roles                                              |
         +--------------------------------------+-----------+-------------+----------------------------------------------------+
         | d9ac81d2-1f69-450d-91d3-64fed8081e8f | overcloud | None        | controller, swift-storage, compute, cinder-storage |
         +--------------------------------------+-----------+-------------+----------------------------------------------------+

### tuskar plan-show

The plan show command will display the full details of your plan and the roles which have been added to it.

usage: tuskar plan-show <PLAN UUID>

        $ tuskar plan-show e09572b6-eed2-41c0-9d98-f7d5d0872ff8
        +-------------+--------------------------------------------------------------------------------------------------------------------+
        | Property    | Value                                                                                                              |
        +-------------+--------------------------------------------------------------------------------------------------------------------+
        | created_at  | 2015-01-16T14:27:34                                                                                                |
        | description | My Plan                                                                                                            |
        | name        | my_plan                                                                                                            |
        | parameters  | default= `<SNIP DETAILS>`                                                                                            |
        | roles       | description=OpenStack control plane node. Can be wrapped in a ResourceGroup for scaling.                           |
        |             |                                                                                                                    |
        |             | name=controller                                                                                                    |
        |             | uuid=79caea1a-f8fc-4eee-b663-40f89744382c                                                                          |
        |             | version=1                                                                                                          |
        |             |                                                                                                                    |
        | updated_at  | None                                                                                                               |
        | uuid        | e09572b6-eed2-41c0-9d98-f7d5d0872ff8                                                                               |
        +-------------+--------------------------------------------------------------------------------------------------------------------+

### tuskar plan-patch

Update a plan with KEY=VALUE pairs.

usage: tuskar plan-patch [-h] [-A <KEY1=VALUE1>] plan_uuid

### tuskar plan-templates

Output the templates associated with the given plan to OUTPUT_DIR.

usage: tuskar plan-templates -O

<OUTPUT DIR>
plan_uuid

        $ tuskar plan-templates -O templates 344441e0-c2ba-4a0d-a857-51f35057fc53
        Following templates has been written:
        templates/plan.yaml
        templates/environment.yaml
        templates/provider-swift-storage-1.yaml
        templates/provider-cinder-storage-1.yaml
        templates/provider-controller-1.yaml
        templates/provider-compute-1.yaml

### tuskar plan-add-role

Associate role to a plan. The role uuid can be found with 'tuskar role-list'.

usage: tuskar plan-add-role -r <ROLE UUID> plan_uuid

        $ tuskar plan-add-role -r 79caea1a-f8fc-4eee-b663-40f89744382c e09572b6-eed2-41c0-9d98-f7d5d0872ff8
        +-------------+--------------------------------------------------------------------------------------------------------------------+
        | Property    | Value                                                                                                              |
        +-------------+--------------------------------------------------------------------------------------------------------------------+
        | created_at  | 2015-01-16T14:27:34                                                                                                |
        | description | My Plan                                                                                                            |
        | name        | my_plan                                                                                                            |
        | parameters  | default= ...  `<SNIP DETAILS>`                                                                                       |
        | roles       | description=OpenStack control plane node. Can be wrapped in a ResourceGroup for scaling.                           |
        |             |                                                                                                                    |
        |             | name=controller                                                                                                    |
        |             | uuid=79caea1a-f8fc-4eee-b663-40f89744382c                                                                          |
        |             | version=1                                                                                                          |
        |             |                                                                                                                    |
        | updated_at  | None                                                                                                               |
        | uuid        | e09572b6-eed2-41c0-9d98-f7d5d0872ff8                                                                               |
        +-------------+--------------------------------------------------------------------------------------------------------------------+

### tuskar plan-create

Create a new plan.

usage: tuskar plan-create [-d <DESCRIPTION>] name

Where name is the name of the plan to create. Description is an optional argument specifying a user-readable text for describing the Plan.

        $ tuskar plan-create -d 'My Plan' my_plan
        +-------------+--------------------------------------+
        | Property    | Value                                |
        +-------------+--------------------------------------+
        | created_at  | 2015-01-16T14:27:34                  |
        | description | My Plan                              |
        | name        | my_plan                              |
        | parameters  |                                      |
        | roles       |                                      |
        | updated_at  | None                                 |
        | uuid        | e09572b6-eed2-41c0-9d98-f7d5d0872ff8 |
        +-------------+--------------------------------------+

### tuskar plan-delete

Delete a plan given a UUID.

usage: tuskar plan-delete <PLAN UUID>

        $ tuskar plan-delete e09572b6-eed2-41c0-9d98-f7d5d0872ff8
        Deleted Plan "my_plan".

### tuskar plan-remove-role

Remove role from a plan.

usage: tuskar plan-remove-role -r <ROLE UUID> <PLAN UUID>

        $ tuskar plan-remove-role -r 79caea1a-f8fc-4eee-b663-40f89744382c e09572b6-eed2-41c0-9d98-f7d5d0872ff8           
        +-------------+--------------------------------------------------------------------------------------------------------------------+
        | Property    | Value                                                                                                              |
        +-------------+--------------------------------------------------------------------------------------------------------------------+
        | created_at  | 2015-01-16T14:27:34                                                                                                |
        | description | My Plan                                                                                                            |
        | name        | my_plan                                                                                                            |
        | parameters  | default= `<SNIP DETAILS>`                                                                                            |
        | roles       |                                                                                                                    |
        | updated_at  | None                                                                                                               |
        | uuid        | e09572b6-eed2-41c0-9d98-f7d5d0872ff8                                                                               |
        +-------------+--------------------------------------------------------------------------------------------------------------------+

### tuskar role-list

The role list command will display the roles that are available to be added to a plan. This command takes no arguments.

        $ tuskar role-list
        +--------------------------------------+----------------+---------+----------------------------------------------------------------+
        | uuid                                 | name           | version | description                                                    |
        +--------------------------------------+----------------+---------+----------------------------------------------------------------+
        | 0932afdb-39b3-41bc-b530-359e487e79e4 | compute        | 1       | OpenStack hypervisor node. Can be wrapped in a ResourceGroup fo|
        |                                      |                |         | r scaling.                                                     |
        | 62e7ca60-98a4-4231-b793-9d546c2bd1c9 | cinder-storage | 1       | Common Block Storage Configuration                             |
        | 79caea1a-f8fc-4eee-b663-40f89744382c | controller     | 1       | OpenStack control plane node. Can be wrapped in a ResourceGroup|
        |                                      |                |         | for scaling.                                                   |
        | b106841c-6fbe-4a78-afff-3cfccb509861 | swift-storage  | 1       | Common Swift Storage Configuration                             |
        +--------------------------------------+----------------+---------+----------------------------------------------------------------+

## Advanced Usage

In the quick usage above, we rely on instack for most of the interactions with Tuskar. For a more custom install, we can follow these steps manually. They make use of the tuskar commands described above to interact with the Tuskar API.

1. First initialise the command line enviroment, this will load the credentials and default settings for a deployment.

         source ~/deploy-overcloudrc
         source ~/tripleo-undercloud-passwords
         source ~/stackrc
         source /usr/share/instack-undercloud/deploy-virt-overcloudrc

2. We need to retrieve the Plan ID from the API which will then be used for future communication with the API. This command can also be used to verify that the roles have been added to the deployment plan.

         tuskar plan-list

3. You will then need to update the the plan to set the attributes required by each role. This can be done with the following command.

         tuskar plan-patch -A $KEY=$VALUE $PLAN_ID

4. After the plan has been configured, you can retrieve the full plan as Heat Orchestration Templates with the following command.

         tuskar plan-templates -o tuskar_templates $PLAN_ID

5. You should now be ready to send the plan to Heat. This can be done with the following command.

         heat stack-create \
             -f tuskar_templates/plan.yml \
             -e tuskar_templates/environment.yml \
             overcloud

See the [Heat client documentation](http://docs.openstack.org/user-guide-admin/content/heat_client_commands.html) for more details on it's usage.
