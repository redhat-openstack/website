---
title: Deploying an RDO Overcloud with Instack
authors: bnemec, ccrouch, jomara, rbrady, rlandy, rwsu, slagle, tzumainn
wiki_title: Deploying an RDO Overcloud with Instack
wiki_revision_count: 84
wiki_last_updated: 2014-11-17
---

[ ← Deploying RDO using Instack](Deploying RDO using Instack)

Now that you have a working undercloud, let's deploy an overcloud. Note that deploy-overcloud can be configured for individual environments via environment variables. The variables you can set are documented in the [Instack FAQ](http://openstack.redhat.com/Instack_FAQ#Are_there_any_example_rc_files_for_Overcloud_deployment.3F). For their default values, see the instack-deploy-overcloud\* scripts.

# Deploying an Overcloud

To deploy a production ready Overcloud, you should use the tuskar CLI or UI.

However, instack-undercloud provides a test script, `instack-deploy-overcloud` that can be used to verify your environment. The following steps will guide you through using `instack-deploy-overcloud`.

1. While logged into the undercloud node export the required variables into your shell in order to use the CLI tools for the undercloud and overcloud. If you copied the stackrc file into your home directory at the end of the undercloud installation, simply source that file. Alternatively, you can use the following command directly to set the needed environment variables.

      command $(sudo cat /root/stackrc | xargs)

2. A file named `deploy-overcloudrc` is used to define the needed environment variables to deploy an Overcloud. For a virtual environment setup, this file has already been created under `/home/stack`. For a baremetal setup, you will need to create the file yourself. There is a sample file included with instack-undercloud at `/usr/share/instack-undercloud/deploy-baremetal-overcloudrc`. Copy and edit the file as needed. Example rc files containing values for the required variables can also be found in the [Instack FAQ](http://openstack.redhat.com/Instack_FAQ#Are_there_any_example_rc_files_for_Overcloud_deployment.3F). Note that the variables must be exported so that their values are picked up by `instack-deploy-overcloud`.

      source deploy-overcloudrc

3. Deploy the Overcloud

      instack-deploy-overcloud

4. You should see `"Overcloud deployed!"` at the end of a successful deployment. To verify basic functionality, there is an included script that can be used called `instack-test-overcloud`. Run this script to perform a smoke test of your Overcloud.

      instack-test-overcloud

5. To further interact with the API services running in the Overcloud using the OpenStack cli tools, you can run the following commands.

      export TE_DATAFILE=instackenv.json
      source /etc/tripleo/overcloudrc

# Deploying the Overcloud

You can deploy the overcloud **either** through the Horizon web interface using the tuskar plugin **or** via the command line

### Tuskar Web UI Deployment

If you want to deploy the Overcloud via the UI you will need to open up port 80 in iptables so that you can access the Web UI. On the undercloud node enter the following:

    sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT

Note that if you are doing a virtual machine based deployment and your virt host is not the same host that you'll be running the web browser from, you can use an ssh tunnel for connectivity. See this [FAQ](http://openstack.redhat.com/Instack_FAQ#How_do_I_view_the_Undercloud_Dashboard_when_using_a_remote_virt_host.3F) for more information.

When logging into the dashboard the default user and password are found in the /root/stackrc file on the undercloud node, OS_USERNAME and OS_PASSWORD. Once you have logged into the Web UI use [this guide](https://wiki.openstack.org/wiki/Tuskar/UsageGuide) to continue deploying your Overcloud. After a successful deployment the next step is: [ Testing an RDO Overcloud with Instack ](Testing an RDO Overcloud with Instack)

### Command Line Deployment

1. Export the required variables, including the rc file you just created:

      source deploy-overcloudrc
      command $(sudo cat /root/stackrc | xargs)

2. Choose how you want to deploy the Overcloud. By calling scripts which **either** use [Heat](https://wiki.openstack.org/wiki/Heat) directly **or** which call the [Tuskar](https://wiki.openstack.org/wiki/TripleO/Tuskar) CLI :

       # heat
       instack-deploy-overcloud

       # tuskar-cli
       instack-deploy-overcloud-tuskarcli

After a successful deployment, you should see "Overcloud Deployed" in the standard output of the terminal. Next steps: [ Testing an RDO Overcloud with Instack](Testing an RDO Overcloud with Instack). If you run into issues and want to redeploy your Overcloud the first step is to delete it using the instructions in the [FAQ](http://openstack.redhat.com/Instack_FAQ#How_do_I_delete_the_Overcloud.3F). You should then be able to re-execute instack-prepare-for-overcloud and deploy the Overcloud again.
