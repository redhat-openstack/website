---
title: TripleO-CLI
authors: d0ugal, maufart
wiki_title: TripleO-CLI
wiki_revision_count: 39
wiki_last_updated: 2015-03-10
---

# Triple O-CLI

## Management System Installation

Instack is used to create the undercloud. This can be either done on a fully virtualised environment or with bare metal. Follow the steps described in [deploying an RDO Undercloud https://openstack.redhat.com/Deploying_an_RDO_Undercloud_with_Instack](deploying an RDO Undercloud https://openstack.redhat.com/Deploying_an_RDO_Undercloud_with_Instack) to create the undercloud for this installation.

## Infrastructure Setup

You will need to register your bare-metal hardware as nodes in Ironic. This can be done in one of two ways, the first uses the command line utility register-nodes to add them based on a JSON file.

Option 1: Use register-nodes from os-cloud-config to load the nodes JSON. The JSON file should match the following structure.

         {
           "nodes": [
             {
               "arch": "x86_64",
               "pm_user": "stack",
               "pm_addr": "192.168.122.1",
               "pm_password": "-----BEGIN RSA PRIVATE KEY-----$SNIP-----END RSA PRIVATE KEY-----",
               "pm_type": "pxe_ssh",
               "mac": [
                 "00:0b:d0:69:7e:59"
               ],
               "cpu": "1",
               "memory": "4096",
               "disk": "40"
             },
             {
               "arch": "x86_64",
               "pm_user": "stack",
               "pm_addr": "192.168.122.2",
               "pm_password": "-----BEGIN RSA PRIVATE KEY-----$SNIP-----END RSA PRIVATE KEY-----",
               "pm_type": "pxe_ssh",
               "mac": [
                 "00:0b:d0:69:7e:58"
               ],
               "cpu": "1",
               "memory": "4096",
               "disk": "40"
             },
         }

This can then be loaded like this:

         register-nodes --service-host undercloud --nodes <(jq '.nodes' $JSON_FILE)

Option 2: Use the ironic client and \`ironic node-create\` to add them one at a time.

         ironic node-create

## OpenStack Setup

## Deployment

## Monitoring

The ironic client can be used to view your infrastructure. To get an overview, use the following command which will list all registered nodes and the state of that node.

         ironic node-list

To view the detail for each individual node, use the following command with the ID in the output from above.

         ironic node-show $NODE_ID

## Post-Deployment

To scale a deployment, first you will need to update the deployment plan and then execute this plan with Heat. The following example shows how to scale the number of compute nodes to four.

First we need to retrieve the Plan ID. This can be seen in the output of \`tuskar plan-list\` or it can be programmatically retrieved with the following command:

         PLAN_ID=$( tuskar plan-show overcloud | awk '$2=="uuid" {print $4}' )

The plan-patch command allows us to set the count for the role we want to scale.

         tuskar plan-patch -A compute-1::count=4 $PLAN_ID

The format of the attribute name is the \`$ROLE_NAME-$ROLE_VERSION::count\`. Therefore to scale the swift-storage role it would be named \`swift-storage-1::count\`.

After updating the attribute, we need to output the Heat Orchestration Templates to then send these to Heat. This is done with the \`tuskar plan-templates\` command by passing an output directory and the Plan ID.

         tuskar plan-templates -O tuskar_templates $PLAN_ID

Finally we can perform a stack update with Heat.

         heat stack-update -f "tuskar_templates/plan.yaml" \
             -e "tuskar_templates/environment.yaml" \
             overcloud

**Note: At the moment only scaling up is supported.**
