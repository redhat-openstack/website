---
title: Deploying an RDO Overcloud with Instack
authors: bnemec, ccrouch, jomara, rbrady, rlandy, rwsu, slagle, tzumainn
wiki_title: Deploying an RDO Overcloud with Instack
wiki_revision_count: 84
wiki_last_updated: 2014-11-17
---

# Deploying an RDO Overcloud with Instack

[ ← Deploying RDO using Instack](Deploying RDO using Instack)

Now that you have a working undercloud, let's deploy an overcloud. Note that deploy-overcloud can be configured for individual environments via environment variables. The variables you can set are documented below before the calls to the script. For their default values, see the deploy-overcloud script itself.

## Preparing for the Overcloud

1. You **must** source the contents of \`/root/stackrc\` and \`/root/tripleo-undercloud-passwords\` into your shell before running the instack-\* scripts that interact with the undercloud and overcloud. In order to do that you can copy that file to a more convenient location or use sudo to cat the file and copy/paste the lines into your shell environment.

2. Run the prepare-for-overcloud script to get setup. This script will avoid re-downloading images if they already exist in the current working directory. If you want to force a redownload of the images, delete them first.

       instack-prepare-for-overcloud

3. If you're using an all VM setup, make sure you have copied the public key portion of the virtual power ssh key into the virtual power user's ~/.ssh/authorized_keys on the virtual machine host.

## Deploying the Overcloud

You can deploy the overcloud through the Horizon web interface using the tuskar plugin or via the command line

### Tuskar Web UI Deployment

If you want to deploy the Overcloud via the UI you will need to setup an ssh tunnel, see this [FAQ](http://openstack.redhat.com/Instack_FAQ#How_do_I_view_the_Undercloud_Dashboard.3F) for more information. Once you have logged into the Web UI use the following guide to continue deploying your Overcloud.

       #`[`tuskar-ui`](https://wiki.openstack.org/wiki/Tuskar/UsageGuide)` (still work in progress)

Next steps: [ Testing an RDO Overcloud with Instack ](Testing an RDO Overcloud with Instack)

### Command Line Deployment

1. Create a deploy-overcloudrc script to set variable values you'll need to deploy the overcloud.

Example rc files containing values for the required variables can be found in the [Instack FAQ](http://openstack.redhat.com/Instack_FAQ#Are_there_any_example_rc_files_for_Overcloud_deployment.3F). Note that the variables must be exported so that their values are picked up by instack-deploy-overcloud. Most of the example values will work as-is if you've been using the defaults up until now, except for the following:

*   In a virtualized deployment the MACS variable will need to be set to the values you gathered during the steps to [setup your virtual machines](http://openstack.redhat.com/Deploying_RDO_to_a_Virtual_Machine_Environment_using_RDO_via_Instack#Virtual_Machine_Creation).
*   Similarly in a bare metal deployments the MACS variable will need to be set to the MAC address of the NIC that will PXE boot, for each host you want to deploy the overcloud to. The PM_\* variables need to be set with corresponding IPMI information. All these values should have been collected during the steps to [setup the bare metal environment](http://openstack.redhat.com/Deploying_RDO_on_a_Baremetal_Environment_using_Instack#Networking).

If you want to deploy more or fewer compute, block storage or object storage nodes in your overcloud then update the appropriate \*SCALE variable in the rc file. If you increase these numbers you will need to make sure that sufficient virtual machines or bare metal hosts are available.

2. Export the required variables, including the rc file you just created:

      source deploy-overcloudrc
      export $(sudo cat /root/tripleo-undercloud-passwords | xargs)
      command $(sudo cat /root/stackrc | xargs)

3. Choose how you want to deploy the Overcloud. By calling [Heat](https://wiki.openstack.org/wiki/Heat) directly or via the [Tuskar](https://wiki.openstack.org/wiki/TripleO/Tuskar) CLI . Run one of the following commands.

      # heat
      instack-deploy-overcloud

      #tuskar-cli
      instack-deploy-overcloud-tuskarcli

After a successful deployment, you should see "Overcloud Deployed" in the standard output of the terminal. Next steps: [ Testing an RDO Overcloud with Instack ](Testing an RDO Overcloud with Instack)

## Deploying the Overcloud

      Deploy the overcloud using provided  `[`Heat`](https://wiki.openstack.org/wiki/Heat)` templates or the `[`Tuskar`](https://wiki.openstack.org/wiki/TripleO/Tuskar)` CLI . Run one of the following examples.

       # heat
        instack-deploy-overcloud

       #tuskar
        instack-deploy-overcloud-tuskarcli

After a successful deployment, you should see "Overcloud Deployed" in the standard output of the terminal. Next steps: [ Testing an RDO Overcloud with Instack ](Testing an RDO Overcloud with Instack)

### Deleting an Overcloud

If you want to delete an overcloud and reset the environment to a state where you can deploy another overcloud, download the instack-delete-overcloud\* scripts from the github repository at <https://github.com/agroup/instack-undercloud/tree/master/scripts> . Run one of the following examples that matches how you deployed the overcloud.

        #heat
        instack-delete-overcloud

        #tuskar
        instack-delete-overcloud-tuskarcli
