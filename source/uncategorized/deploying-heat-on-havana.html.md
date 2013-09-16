---
title: Deploying Heat on Havana
authors: dneary, rbowen, shardy
wiki_title: Deploying Heat on Havana
wiki_revision_count: 12
wiki_last_updated: 2013-11-19
---

# Deploying Heat on Havana

## Deploy OpenStack Heat

[Heat](http://wiki.openstack.org/wiki/Heat) provides orchestration of composite cloud applications. Heat is an officially integrated OpenStack project from the Havana release.

> Heat is a service to orchestrate multiple composite cloud applications using either native "HOT" templates, or AWS CloudFormation template format. Heat provides both an OpenStack-native ReST API and a CloudFormation-compatible Query API.

This guide deploys a composite application (made up of more than a single instance) on the cloud infrastructure. This also involves launch-time customization of the VMs. This guide makes some assumptions:

*   OpenStack has not yet been configured
*   OpenStack is deployed on RHEL 6.4 or Fedora 19

### Installation

Start by installing OpenStack, and Heat via packstack

      $ sudo yum install "openstack-heat-*" python-heatclient

You'll get four new services installed: an engine, a native api, a cloudformation compatible api, a cloudwatch compatible api. You don't have to deploy them all on a single host but for the purpose of this guide it will be fine to do so.

python-heatclient installs a python CLI tool "heat", which is used to interact with the heat native API

### Configuration

The application templates can use wait conditions and signaling for the orchestration, Heat needs to create special users to receive the progress data and these users are, by default, given the role of `heat_stack_user`. You can configure the role name in `/etc/heat/heat.conf` or just create a so called role::

      $ keystone role-create --name heat_stack_user

The configuration should now be complete and you can launch your first Heat application::

### Get the demo files

It is time now to launch your first multi-instance cloud application! There are a number of sample templates available in the [github repo](https://github.com/openstack/heat), download the composed Wordpress example with::

`$ wget `[`https://raw.github.com/openstack/heat-templates/master/cfn/F17/WordPress_Composed_Instances.template`](https://raw.github.com/openstack/heat-templates/master/cfn/F17/WordPress_Composed_Instances.template)

Every template also provides you with a list of usable distros and map these into an AMI string, for each arch. You will have to populate Glance with an image matching the AMI string that the template file is expecting to find.

Now you would need to create JEOS image and you can do it through the `heat_jeos.sh` script from : <https://github.com/openstack/heat-templates> . This can be used to create the JEOS images and upload them to Glance but there is also a collection of prebuilt images at: <http://fedorapeople.org/groups/heat/prebuilt-jeos-images/> so I suggest you to just download one from `F17-x86_64-cfntools.qcow2` or `U10-x86_64-cfntools.qcow2` (which are referred by many if not all the templates available in the Heat's repo). To upload the F17 x86_64 image in Glance::

`$ glance image-create --name F17-x86_64-cfntools --disk-format qcow2 --container-format bare --is-public True --copy-from `[`http://fedorapeople.org/groups/heat/prebuilt-jeos-images/F17-x86_64-cfntools.qcow2`](http://fedorapeople.org/groups/heat/prebuilt-jeos-images/F17-x86_64-cfntools.qcow2)

While that is downloading, create a new keypair or upload your public key in nova to make sure you'll be able to login on the VMs using SSH::

      $ nova keypair-add --pub_key ~/.ssh/id_rsa.pub userkey

Some templates require the instances to be able to connect to the heat CFN API, so it would be a good idea to add a chain to iptables to accept connection to 8000 and 8003 ports so that the guests can communicate with the heat-api-cfn server and heat-api-cloudwatch server. You can append to your `/etc/sysconfig/iptables` ::

      $ -A INPUT -i br100 -p tcp --dport 8000 -j ACCEPT
      $ -A INPUT -i br100 -p tcp --dport 8003 -j ACCEPT

where `br100` is the interface of the bridge that your instances are using.

### Launch!

It is time for the real fun now, launch your first composed application with::

      $ heat stack-create wordpress --template-file=WordPress_Composed_Instances.template --parameters="DBUsername=wp;DBPassword=wp;KeyName=userkey;LinuxDistribution=F17"

More parameters could have passed, note for instance the LinuxDistribution parameter discussed above. Now the interesting stuff:

      $ heat stack-list
      $ heat event-list wordpress

After the VMs are launched, the mysql/httpd/wordpress installation and configuration begins, the process is driven by the `cfntools`, installed in the VMs images. It will take quite some time, despite the `event-list` reporting completion for the WordPress install too early (there is signaling, via `cfn-signal`, only in the MySQL template). You can login on the instances and check the logs or just use `ps` to see how things are going. After some minutes the setup should be finished:

      $ heat stack-show wordpress
      $ wget ${WebsiteURL} // that is an URL from the previous command!

If anything goes wrong, check the logs at `/var/log/heat/engine.log` or look at the scripts passed as `UserData` to the instances, these should be found in `/var/lib/cloud/data/`. Time to hack your very own template and delete the test deployment! :)
