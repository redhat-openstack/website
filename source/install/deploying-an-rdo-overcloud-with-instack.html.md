---
title: Deploying an RDO Overcloud with Instack
authors: bnemec, ccrouch, jomara, rbrady, rlandy, rwsu, slagle, tzumainn
wiki_title: Deploying an RDO Overcloud with Instack
wiki_revision_count: 84
wiki_last_updated: 2014-11-17
---

[ ← Deploying RDO using Instack](Deploying RDO using Instack)

Now that you have a working undercloud, let's deploy an overcloud.

# Deploying an Overcloud

To deploy a production ready Overcloud, you should use the tuskar CLI or UI.

However, instack-undercloud provides a test script, `instack-deploy-overcloud` that can be used to verify your environment. The following steps will guide you through using `instack-deploy-overcloud`.

1. While logged into the undercloud node export the required variables into your shell in order to use the CLI tools for the undercloud and overcloud. If you copied the stackrc file into your home directory at the end of the undercloud installation, simply source that file. Alternatively, you can use the following command directly to set the needed environment variables.

      command $(sudo cat /root/stackrc | xargs)

2. If doing a baremetal deployment, create a json file describing your baremetal nodes. See [this FAQ](https://rdoproject.org/Instack_FAQ#What_is_the_NODES_JSON_file_format.3F) for the documentation of the format of the file. For a virtual deployment, this file has already been created as instackenv.json, and you do not need to edit this file.

3. A file named `deploy-overcloudrc` is used to define the needed environment variables to deploy an Overcloud. For a virtual environment setup, this file has already been created under `/home/stack`. For a baremetal setup, you will need to create the file yourself. There is a sample file included with instack-undercloud at `/usr/share/instack-undercloud/deploy-baremetal-overcloudrc`. Copy and edit the file as needed. For the NODES_JSON value, specify the path to the file that you created in the previous step. Example rc files containing values for the required variables can also be found in the [Instack FAQ](http://rdoproject.org/Instack_FAQ#Are_there_any_example_rc_files_for_Overcloud_deployment.3F). Note that the variables must be exported so that their values are picked up by `instack-deploy-overcloud`.

      source deploy-overcloudrc

4. Deploy the Overcloud

      instack-deploy-overcloud

5. To further interact with the API services running in the Overcloud using the OpenStack cli tools, you can run the following commands.

      export TE_DATAFILE=instackenv.json
      source /etc/tripleo/overcloudrc

Next steps: [ Testing an RDO Overcloud with Instack](Testing an RDO Overcloud with Instack). If you run into issues and want to redeploy your Overcloud the first step is to delete it using the instructions in the [FAQ](http://rdoproject.org/Instack_FAQ#How_do_I_delete_the_Overcloud.3F). You should then be able to re-execute instack-prepare-for-overcloud and deploy the Overcloud again.

# Deploying the Overcloud via the Tuskar UI

You can deploy the overcloud **either** through the Horizon web interface using the tuskar plugin **or** via the tuskar command line

### Tuskar Web UI Deployment

If you want to deploy the Overcloud via the UI you will need to open up port 80 in iptables so that you can access the Web UI. On the undercloud node enter the following:

    sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT

Note that if you are doing a virtual machine based deployment and your virt host is not the same host that you'll be running the web browser from, you can use an ssh tunnel for connectivity. See this [FAQ](http://rdoproject.org/Instack_FAQ#How_do_I_view_the_Undercloud_Dashboard_when_using_a_remote_virt_host.3F) for more information.

When logging into the dashboard the default user and password are found in the /root/stackrc file on the undercloud node, OS_USERNAME and OS_PASSWORD. Once you have logged into the Web UI use the [Tuskar UI guide](https://rdoproject.org/Tuskar-UI) to continue deploying your Overcloud.

Tuskar WEB UI Deployment currently does not support testing an RDO Overcloud with Instack. The overcloud-passwords file is missing and the instack.json file needs to be updated. If you managed to correct these, then proceed to: [ Testing an RDO Overcloud with Instack ](Testing an RDO Overcloud with Instack)
