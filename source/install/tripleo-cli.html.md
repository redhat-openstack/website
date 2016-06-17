---
title: TripleO-CLI
authors: d0ugal, maufart
wiki_title: TripleO-CLI
wiki_revision_count: 39
wiki_last_updated: 2015-03-10
---

# Triple O-CLI

## Management System Installation

Instack is used to create the undercloud. This can be either done on a fully virtualised environment or with bare metal. Follow the steps described in [deploying an RDO Undercloud](Deploying_an_RDO_Undercloud_with_Instack) to create the undercloud for this installation. The log for the instack install can be found in `~/.instack/install-undercloud.log`

## Environment Setup

To setup your shell environment with the correct configuration and authentication details for your deployment you will need to run the following commands.

      source ~/deploy-overcloudrc
      source ~/tripleo-undercloud-passwords
      source ~/stackrc

These will need to be entered each time you start a new shell session for the following commands in this page to work.

## Infrastructure Setup

You will need to register your bare-metal hardware as nodes in Ironic. This can be done in one of two ways, the first uses the command line utility register-nodes to add them based on a JSON file.

Option 1: Use register-nodes from os-cloud-config to load the nodes JSON. The JSON file should match the following structure.

       [
         {
           "arch": "x86_64",
           "pm_user": "stack",
           "pm_addr": "192.168.122.1",
           "pm_password": "-----BEGIN RSA PRIVATE KEY-----$SNIP-----END RSA PRIVATE KEY-----",
           "pm_type": "pxe_ssh",
           "mac": [
             "00:0b:d0:69:7e:59"
           ],
           "cpu": "1",
           "memory": "4096",
           "disk": "40"
         },
         {
           "arch": "x86_64",
           "pm_user": "stack",
           "pm_addr": "192.168.122.2",
           "pm_password": "-----BEGIN RSA PRIVATE KEY-----$SNIP-----END RSA PRIVATE KEY-----",
           "pm_type": "pxe_ssh",
           "mac": [
             "00:0b:d0:69:7e:58"
           ],
           "cpu": "1",
           "memory": "4096",
           "disk": "40"
         }
       ]

This can then be loaded like this:

      register-nodes --service-host undercloud --nodes $JSON_FILE

Option 2: Use the ironic client and `ironic node-create` and `ironic port-create` to add them one at a time.

      $ ironic node-create -d pxe_ssh \
          -p cpus=1 -p memory_mb=4096 -p local_gb=40 -p cpu_arch=x86_64 \
          -i ssh_username=stack -i ssh_virt_type=virsh -i ssh_address="192.168.122.1" -i ssh_key_contents="key"
      +--------------+-------------------------------------------------------------------------+
      | Property     | Value                                                                   |
      +--------------+-------------------------------------------------------------------------+
      | uuid         | 8d9e4de3-8a57-417e-8c96-789555be372c                                    |
      | driver_info  | {u'ssh_username': u'stack', u'ssh_virt_type': u'virsh', u'ssh_address': |
      |              | u'192.168.122.1', u'ssh_key_contents': u'key'}                          |
      | extra        | {}                                                                      |
      | driver       | pxe_ssh                                                                 |
      | chassis_uuid | None                                                                    |
      | properties   | {u'memory_mb': u'4096', u'cpu_arch': u'x86_64', u'local_gb': u'40',     |
      |              | u'cpus': u'1'}                                                          |
      +--------------+-------------------------------------------------------------------------+
      $ ironic port-create -a "00:7e:11:29:45:4e" -n 8d9e4de3-8a57-417e-8c96-789555be372c
      +-----------+--------------------------------------+
      | Property  | Value                                |
      +-----------+--------------------------------------+
      | node_uuid | 8d9e4de3-8a57-417e-8c96-789555be372c |
      | extra     | {}                                   |
      | uuid      | 1b93f57b-2add-45ca-bac4-c8e104ef4d63 |
      | address   | 00:7e:11:29:45:4e                    |
      +-----------+--------------------------------------+
      $ ironic node-set-power-state 8d9e4de3-8a57-417e-8c96-789555be372c off

## OpenStack Setup

Flavors are used to assign roles in the deployment plan to specific nodes in your infrastructure. The connection between these is made by creating the flavors in Nova and the updating the deployment plan in Tuskar to reflect which flavors the roles should use.

The following example creates a different flavor for the four standard roles, however, sharing flavors between roles is possible.

      nova flavor-create control auto 4096 40 2
      nova flavor-create compute auto 1024 40 1
      nova flavor-create cinder-storage auto 1024 40 1
      nova flavor-create swift-storage auto 1024 40 1
      deploy_kernel_id=$(glance image-show bm-deploy-kernel | awk ' / id / {print $4}')
      deploy_ramdisk_id=$(glance image-show bm-deploy-ramdisk | awk ' / id / {print $4}')
      nova flavor-key control set "cpu_arch"="x86_64" "baremetal:deploy_kernel_id"="$deploy_kernel_id" "baremetal:deploy_ramdisk_id"="$deploy_ramdisk_id"
      nova flavor-key compute set "cpu_arch"="x86_64" "baremetal:deploy_kernel_id"="$deploy_kernel_id" "baremetal:deploy_ramdisk_id"="$deploy_ramdisk_id"
      nova flavor-key cinder-storage set "cpu_arch"="x86_64" "baremetal:deploy_kernel_id"="$deploy_kernel_id" "baremetal:deploy_ramdisk_id"="$deploy_ramdisk_id"
      nova flavor-key swift-storage set "cpu_arch"="x86_64" "baremetal:deploy_kernel_id"="$deploy_kernel_id" "baremetal:deploy_ramdisk_id"="$deploy_ramdisk_id"

In the Deployment section which follows below, we will look at how to specify the flavors (with the command `tuskar plan-patch`) we want to use when we deploy.

Nova logs can be found under `/var/log/nova/`.

## Deployment

To deploy the Overcloud a deployment plan needs to be created with the Tuskar planning service. This allows you to select various Roles that will be used in the deployment, scale them and it will then output Heat Orchestration Templates that can then be executed by Heat.

When Tuskar is installed it will create a default Plan called `overcloud` which should be used. At the moment only one deployment is supported within Tuskar. You can see this Deployment Plan with the command `tuskar plan-list`.

      $ tuskar plan-list
      +--------------------------------------+-----------+-------------+----------------------------------------------------+
      | uuid                                 | name      | description | roles                                              |
      +--------------------------------------+-----------+-------------+----------------------------------------------------+
      | f57884c9-ed35-421e-b331-b2dc38b656af | overcloud | None        | controller, swift-storage, compute, cinder-storage |
      +--------------------------------------+-----------+-------------+----------------------------------------------------+

The plan by default has the roles controller swift-storage, compute and cinder-storage. These are the four roles that Tuskar comes with as standard. The roles can all be seen with the command `tuskar roles-list`

      $ tuskar role-list
      +--------------------------------------+----------------+---------+------------------------------------------------------------------------------+
      | uuid                                 | name           | version | description                                                                  |
      +--------------------------------------+----------------+---------+------------------------------------------------------------------------------+
      | 023031ea-2dd9-43b4-9dd2-e9ebfb71710c | cinder-storage | 1       | Common Block Storage Configuration                                           |
      | 71f5b6c8-d423-482c-bc4a-e7103e67d7dc | swift-storage  | 1       | Common Swift Storage Configuration                                           |
      | 950b6757-7804-41aa-93a7-f50b099b0159 | controller     | 1       | OpenStack control plane node. Can be wrapped in a ResourceGroup for scaling. |
      |                                      |                |         |                                                                              |
      | b2a5f50e-a088-45d1-b4ac-2751a607628a | compute        | 1       | OpenStack hypervisor node. Can be wrapped in a ResourceGroup for scaling.    |
      |                                      |                |         |                                                                              |
      +--------------------------------------+----------------+---------+------------------------------------------------------------------------------+

To set the require attributes in the Deployment Plan use the Tuskar command plan-patch.

      tuskar plan-patch -A $ATTRIBUTE1=$VALUE1 -A $ATTRIBUTE2=$VALUE2 ... $PLAN_ID

A full list of the attributes and their current values can be seen in the output of `tuskar plan-show overcloud`

**TODO: Get the user a full list of required attributes.**

At this stage we can use the attributes to control the flavor used by each role.

      tuskar plan-patch -A compute-1::Flavor=compute $PLAN_ID
      tuskar plan-patch -A swift-storage-1::Flavor=swift-storage $PLAN_ID
      tuskar plan-patch -A controller-1::Flavor=controller $PLAN_ID
      tuskar plan-patch -A cinder-storage-1::Flavor=cinder-storage $PLAN_ID

Once the attributes have been set in the Deployment Plan it can be reviewed with plan-show as described above. After this has been checked the Heat templates can be retried from Tuskar and a stack create can be executed.

      tuskar plan-templates -O tuskar_templates $PLAN_ID
      heat stack-create -f tuskar_templates/plan.yaml \
         -e tuskar_templates/environment.yaml \
         overcloud

If there are any problems with the Heat stack update, the Heat engine log under `/var/log/heat/engine.log` is a good place to start debugging.

## Monitoring

The ironic client can be used to view your infrastructure. To get an overview, use the following command which will list all registered nodes and the state of that node.

      $ ironic node-list
      +--------------------------------------+---------------+-------------+--------------------+-------------+
      | UUID                                 | Instance UUID | Power State | Provisioning State | Maintenance |
      +--------------------------------------+---------------+-------------+--------------------+-------------+
      | b75f16bf-b76d-4a01-a2cf-a5a395bec765 | None          | power off   | None               | False       |
      | 357e84e8-bf32-4a6a-8540-79a126070b8f | None          | power off   | None               | False       |
      | 263ff2f1-2f75-4a9a-95aa-b475b9160ec4 | None          | power off   | None               | False       |
      | 8412a224-634f-40a1-8aff-4b24148cb735 | None          | power off   | None               | False       |
      +--------------------------------------+---------------+-------------+--------------------+-------------+

To view the detail for each individual node, use the following command with the ID in the output from above.

      $ ironic node-show 263ff2f1-2f75-4a9a-95aa-b475b9160ec4
      +------------------------+--------------------------------------------------------------------------+
      | Property               | Value                                                                    |
      +------------------------+--------------------------------------------------------------------------+
      | instance_uuid          | None                                                                     |
      | target_power_state     | None                                                                     |
      | properties             | {u'memory_mb': u'4096', u'cpu_arch': u'x86_64', u'local_gb': u'40',      |
      |                        | u'cpus': u'1'}                                                           |
      | maintenance            | False                                                                    |
      | driver_info            | {u'ssh_username': u'stack', u'ssh_virt_type': u'virsh', u'ssh_address':  |
      |                        | u'192.168.122.1', u'ssh_key_contents': u'-----BEGIN RSA PRIVATE KEY----- |
      |                        | `<SNIP>`                                                                   |
      |                        | -----END RSA                                                             |
      |                        | PRIVATE KEY-----'}                                                       |
      | extra                  | {}                                                                       |
      | last_error             | None                                                                     |
      | created_at             | 2015-02-05T13:50:36+00:00                                                |
      | target_provision_state | None                                                                     |
      | driver                 | pxe_ssh                                                                  |
      | updated_at             | 2015-02-09T15:04:08+00:00                                                |
      | instance_info          | {}                                                                       |
      | chassis_uuid           | None                                                                     |
      | provision_state        | None                                                                     |
      | reservation            | None                                                                     |
      | power_state            | power off                                                                |
      | console_enabled        | False                                                                    |
      | uuid                   | 263ff2f1-2f75-4a9a-95aa-b475b9160ec4                                     |
      +------------------------+--------------------------------------------------------------------------+

## Post-Deployment

To scale a deployment, first you will need to update the deployment plan and then execute this plan with Heat. The following example shows how to scale the number of compute nodes to four.

First we need to retrieve the Plan ID. This can be seen in the output of `tuskar plan-list` or it can be programmatically retrieved with the following command:

      PLAN_ID=$( tuskar plan-show overcloud | awk '$2=="uuid" {print $4}' )

To see the current scale values for your roles, use the `tuskar plan-show` command. Since the output is large, we can focus on the relevant sections with this command. It will show you each of the roles and their autoscale value.

      $ tuskar plan-show overcloud | grep "::count" -A 1
      |             | name=swift-storage-1::count        |
      |             | value=1                            |
      --
      |             | name=controller-1::count           |
      |             | value=1                            |
      --
      |             | name=compute-1::count              |
      |             | value=1                            |
      --
      |             | name=cinder-storage-1::count       |
      |             | value=1                            

The plan-patch command allows us to set the count for the role we want to scale.

      tuskar plan-patch -A compute-1::count=4 $PLAN_ID

**Note: At the moment only scaling up is supported.**

The format of the attribute name is the `$ROLE_NAME-$ROLE_VERSION::count`. Therefore to scale the swift-storage role it would be named `swift-storage-1::count`.

After updating the attribute, we need to output the Heat Orchestration Templates to then send these to Heat. This is done with the `tuskar plan-templates` command by passing an output directory and the Plan ID.

      tuskar plan-templates -O tuskar_templates $PLAN_ID

Finally we can perform a stack update with Heat.

      heat stack-update -f "tuskar_templates/plan.yaml" \
         -e "tuskar_templates/environment.yaml" \
         overcloud

If there are any problems with the Heat stack update, the Heat engine log under `/var/log/heat/engine.log` is a good place to start debugging.
