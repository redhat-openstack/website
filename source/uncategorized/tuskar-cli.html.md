---
title: Tuskar-CLI
authors: bcrochet, d0ugal
wiki_title: Tuskar-CLI
wiki_revision_count: 33
wiki_last_updated: 2015-01-16
---

# Tuskar-CLI

This tutorial covers how to deploy a TripleO Undercloud and Overcloud with the Tuskar command line interface and using RDO and Instack on an all bare metal or an all virtual environment.

## Quick Usage

Once Tuskar is successfully installed in the undercloud with Instack the following steps can be used to deploy the overcloud. 1. First initialise the command line enviroment, this will load the credentials and default settings for a deployment.

         source ~/deploy-overcloudrc
         source ~/tripleo-undercloud-passwords
         source ~/stackrc
         source /usr/share/instack-undercloud/deploy-virt-overcloudrc

2. You are now ready to start the deployment with the following command.

         instack-deploy-overcloud --tuskar

The default settines will deploy the control role to one node and the compute role to one node. 3. To scale your deployment or add new roles to unused nodes, you can scale the deployment. The following commands will deploy four roles over four nodes.

         export CONTROLSCALE=1
         export COMPUTESCALE=1
         export BLOCKSTORAGESCALE=1
         export SWIFTSTORAGESCALE=1
         instack-deploy-overcloud --tuskar
         

4. You can view the state of your baremetal machines and their state with the nova client which is already installed and will be usable after setting up the enviroment in step 1.

         nova baremetal-node-list
