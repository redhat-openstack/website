---
title: Deploy an application with Heat
authors: cknapp, dneary, sbaker, sdake, shardy
wiki_title: Deploy an application with Heat
wiki_revision_count: 10
wiki_last_updated: 2014-12-12
---

# Deploy an application with OpenStack Orchestration (Heat)

The Orchestration module enables you to orchestrate multiple composite cloud applications. This document describes how to deploy a composite application (made up of more than a single instance) on the cloud infrastructure. This also involves launch-time customization of the VMs.

This document makes some assumptions:

* OpenStack, including Heat, has been deployed, using the [instructions](/install/quickstart/) for the current *Liberty* release.
* OpenStack is deployed on Red Hat Enterprise Linux (RHEL) 7 or the equivalent version of one of the RHEL-based Linux distributions such as CentOS, Scientific Linux, and so on.

### Get the demo files

After you have successfully deployed OpenStack, you are ready to launch your first multi-instance cloud application. There are a number of sample templates available in the [heat-templates](https://github.com/openstack/heat-templates) git repo.

* First, download the composed WordPress example template file with the following command:

  `$ curl -O `[`https://raw.github.com/openstack/heat-templates/master/cfn/F17/WordPress_Composed_Instances.template`](https://raw.github.com/openstack/heat-templates/master/cfn/F17/WordPress_Composed_Instances.template)

* Next, register a pre-built cfntools image with Glance. Note that the command automatically downloads the image. 

  `$ glance image-create --name Fedora-Cloud-Base-23-20151030.x86_64 --disk-format qcow2 --container-format bare --is-public True --copy-from `[`http://download.fedoraproject.org/pub/fedora/linux/releases/23/Cloud/x86_64/Images/Fedora-Cloud-Base-23-20151030.x86_64.qcow2`](http://download.fedoraproject.org/pub/fedora/linux/releases/23/Cloud/x86_64/Images/Fedora-Cloud-Base-23-20151030.x86_64.qcow2)

  For reference, pre-built Fedora images are available from the following source: <https://getfedora.org/cloud/download/>.

* Upload your public key in Nova to make sure you will be able to log in on the VMs using SSH:

  `$ nova keypair-add --pub_key ~/.ssh/id_rsa.pub userkey`

* Some templates require the instances to be able to connect to the heat CFN API, so it would be a good idea to add a chain to iptables to accept connections on ports 8000 and 8003. This ensures that the guests can communicate with the heat-api-cfn server and the heat-api-cloudwatch server.

  Append the following to your `/etc/sysconfig/iptables` file:

      -A INPUT -i br100 -p tcp --dport 8000 -j ACCEPT
      -A INPUT -i br100 -p tcp --dport 8003 -j ACCEPT

  where `br100` is the interface of the bridge that your instances are using.

* Restart the iptables service for the firewall changes to take effect:

  `# systemctl restart iptables.service`

### Launch

* To create a stack, or template, from an example template file, run the following command:

  `$ heat stack-create wordpress --template-file=WordPress_Composed_Instances.template --parameters="DBUsername=wp;DBPassword=wp;KeyName=userkey;LinuxDistribution=F17"`

  The `--parameters` values that you specify depend on the parameters that are defined in the template. Note, for instance, the `LinuxDistribution` parameter mentioned above.

* To explore the state and history of a particular stack, you can run a number of commands. To see which stacks are visible to the current user, run the following command:

  `$ heat stack-list`

* A series of events is generated during the life cycle of a stack. To display life cycle events, run the following command:

  `$ heat event-list wordpress`

* After the VMs are launched, the mysql/httpd/wordpress installation and configuration begins, the process is driven by the `cfntools`, installed in the VMs images. The installation and configuration will take some time, despite the `event-list` reporting completion for the WordPress installation too early (there is signaling, via `cfn-signal`, only in the MySQL template). You can log in on the instances and check the logs or just use `ps` to check the progress.
  
* Once the setup is finished, run the following command to show the details of the stack:

  `$ heat stack-show wordpress`

  `$ curl -O ${WebsiteURL} # that is an URL from the previous command!`

  If anything goes wrong, check the logs at `/var/log/heat/engine.log` or look at the scripts passed as `UserData` to the instances. The scripts are located in `/var/lib/cloud/data/`.
  
* You can now hack your very own template and delete the test deployment.

