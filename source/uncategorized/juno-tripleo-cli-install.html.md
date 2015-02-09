---
title: Juno-TripleO-CLI-install
authors: d0ugal
wiki_title: Juno-TripleO-CLI-install
wiki_revision_count: 7
wiki_last_updated: 2015-02-09
---

# Juno-Triple O-CLI-install

## Infrastructure Setup

## OpenStack Setup

## Deployment

## Monitoring

The ironic client can be used to view your infrastructure. To get an overview, use the following command which will list all registered nodes and the state of that node.

         ironic node-list

To view the detail for each individual node, use the following command with the ID in the output from above.

         ironic node-show $NODE_ID

## Post-Deployment

To scale a deployment, first you will need to update the deployment plan and then execute this plan with Heat. The following example shows how to scale the number of compute nodes to four.

         PLAN_ID=$( tuskar plan-show overcloud | awk '$2=="uuid" {print $4}' )

         tuskar plan-patch -A compute-1::count=4 $PLAN_ID

         tuskar plan-templates -O tuskar_templates $PLAN_ID

         heat stack-update -f -f "tuskar_templates/plan.yaml" \
             -e "tuskar_templates/environment.yaml" \
             overcloud

Note: At the moment only scaling up is supported.
