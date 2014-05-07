---
title: Deploying an RDO Overcloud with Instack
authors: bnemec, ccrouch, jomara, rbrady, rlandy, rwsu, slagle, tzumainn
wiki_title: Deploying an RDO Overcloud with Instack
wiki_revision_count: 84
wiki_last_updated: 2014-11-17
---

# Deploying an RDO Overcloud with Instack

[ ← Deploying RDO using Instack](Deploying RDO using Instack)

Now that you have a working undercloud, let's deploy an overcloud. Note that deploy-overcloud can be configured for individual environments via environment variables. The variables you can set are documented in the [Instack FAQ](http://openstack.redhat.com/Instack_FAQ#Are_there_any_example_rc_files_for_Overcloud_deployment.3F). For their default values, see the instack-deploy-overcloud\* scripts.

## Preparing for the Overcloud

1. While logged into the undercloud node export the required variables into your shell before running the instack-\* scripts that interact with the undercloud and overcloud:

      command $(sudo cat /root/stackrc | xargs)

2. Run the prepare-for-overcloud script to get setup. This script will download approximately 2.5GB of images from [here](http://repos.fedorapeople.org/repos/openstack-m/tripleo-images-rdo-icehouse/). It will avoid re-downloading images if they already exist in the current working directory. If you want to force a redownload of the images, delete them first.

       instack-prepare-for-overcloud

3. If you're using an all VM setup, make sure you have copied the public key portion of the virtual power ssh key into the virtual power user's ~/.ssh/authorized_keys on the virtual machine host.

## Deploying the Overcloud

You can deploy the overcloud **either** through the Horizon web interface using the tuskar plugin **or** via the command line

### Tuskar Web UI Deployment

If you want to deploy the Overcloud via the UI you will need to setup an ssh tunnel, see this [FAQ](http://openstack.redhat.com/Instack_FAQ#How_do_I_view_the_Undercloud_Dashboard.3F) for more information. Once you have logged into the Web UI use [this guide](https://wiki.openstack.org/wiki/Tuskar/UsageGuide) (still work in progress) to continue deploying your Overcloud. After a successful deployment the next step is: [ Testing an RDO Overcloud with Instack ](Testing an RDO Overcloud with Instack)

### Command Line Deployment

1. Create a deploy-overcloudrc script to set variable values you'll need to deploy the overcloud.

Example rc files containing values for the required variables can be found in the [Instack FAQ](http://openstack.redhat.com/Instack_FAQ#Are_there_any_example_rc_files_for_Overcloud_deployment.3F). Note that the variables must be exported so that their values are picked up by instack-deploy-overcloud. Most of the example values will work as-is if you've been using the defaults up until now, except for the following:

*   In a virtualized deployment the MACS variable will need to be set to the values you gathered during the steps to [setup your virtual machines](http://openstack.redhat.com/Deploying_RDO_to_a_Virtual_Machine_Environment_using_RDO_via_Instack#Virtual_Machine_Creation).
*   Similarly in a bare metal deployment the MACS variable will need to be set to the MAC address of the NIC that will PXE boot, for each host you want to deploy the overcloud to. The PM_\* variables need to be set with corresponding IPMI information. All these values should have been collected during the steps to [setup the bare metal environment](http://openstack.redhat.com/Deploying_RDO_on_a_Baremetal_Environment_using_Instack#Networking).

If you want to deploy more or fewer compute, block storage or object storage nodes in your overcloud then update the appropriate \*SCALE variable in the rc file. If you increase these numbers you will need to make sure that sufficient virtual machines or bare metal hosts are available.

2. Export the required variables, including the rc file you just created:

      source deploy-overcloudrc
      export $(sudo cat /root/tripleo-undercloud-passwords | xargs)
      command $(sudo cat /root/stackrc | xargs)

3. Choose how you want to deploy the Overcloud. By calling scripts which **either** use [Heat](https://wiki.openstack.org/wiki/Heat) directly **or** which call the [Tuskar](https://wiki.openstack.org/wiki/TripleO/Tuskar) CLI :

       # heat
       instack-deploy-overcloud

       # tuskar-cli
       instack-deploy-overcloud-tuskarcli

After a successful deployment, you should see "Overcloud Deployed" in the standard output of the terminal. Next steps: [ Testing an RDO Overcloud with Instack](Testing an RDO Overcloud with Instack). If you run into issues and want to redeploy your Overcloud the first step is to delete it using the instructions in the [FAQ](http://openstack.redhat.com/Instack_FAQ#How_do_I_delete_the_Overcloud.3F). You should then be able to re-execute instack-prepare-for-overcloud and deploy the Overcloud again.
