---
title: Deploy Heat and launch your first Application
authors: bluesman, dneary, gfidente, rbowen, sbaker, sdake, shardy, vaneldik, zaneb
wiki_title: Deploy Heat and launch your first Application
wiki_revision_count: 47
wiki_last_updated: 2013-10-01
---

# Deploy Heat and launch your first Application

## Deploy OpenStack Heat on RHEL (and derivatives)

[Heat](http://wiki.openstack.org/wiki/Heat) provides orchestration of composite cloud applications using the CloudFormation API and templates; it is an incubated project of OpenStack. Its development cycle is to be Integrated in Havana and follow the full OpenStack release process.

> Heat is a service to orchestrate multiple composite cloud applications using the AWS CloudFormation template format, through both an OpenStack-native ReST API and a CloudFormation-compatible Query API.

This guide deploys a composite application (made up of more than a single instance) on the cloud infrastructure. This also involves launch-time customization of the VMs. This guide makes some assumptions:

*   OpenStack has already been configured via PackStack as described in the QuickStart guide
*   OpenStack is deployed on RHEL 6.4

### Installation

Start by installing the required packages for Heat to work:

      $ sudo yum install openstack-heat-*

You'll get four new services installed: an engine, a native api, a cloudformation compatible api, a cloudwatch compatible api. You don't have to deploy them all on a single host but for the purpose of this guide it will be fine to do so.

### Configuration

Heat comes with a script which creates (and populates) the needed database for it to work but you need to know your MySQL's `root` account password. If you've used Packstack, than that is saved as `CONFIG_MYSQL_PW` in the answers file (`/root/packstack-answers*` by default). Now run the prepare script:

      $ sudo heat-db-setup rpm -y -r ${MYSQL_ROOT_PASSWORD} -p ${HEAT_DB_PASSWORD_OF_CHOICE}

Check in `/etc/heat/heat-engine.conf` that your database connection string is correct::

      sql_connection = mysql://heat:${HEAT_DB_PASSWORD}@localhost/heat

Now go trough the \*usual\* steps needed to create a new user, service and endpoint with Keystone and don't forget to source the admin credentials before starting (which are in `/root/keystonerc_admin` if you've used Packstack)::

      $ keystone user-create --name heat --pass ${HEAT_USER_PASSWORD_OF_CHOICE}
      $ keystone user-role-add --user heat --role admin --tenant ${SERVICES_TENANT_NAME}
      $ keystone service-create --name heat --type orchestration
      $ keystone service-create --name heat-cfn --type cloudformation
      $ keystone endpoint-create --region RegionOne --service-id ${HEAT-CFN-SERVICE-ID} --publicurl "`[`http://`](http://)`${HEAT-CFN-HOSTNAME}:8000/v1" --adminurl "`[`http://`](http://)`${HEAT-CFN-HOSTNAME}:8000/v1" --internalurl "`[`http://`](http://)`${HEAT-CFN-HOSTNAME}:8000/v1"
      $ keystone endpoint-create --region RegionOne --service-id ${HEAT-SERVICE-ID} --publicurl "`[`http://`](http://)`${HEAT-HOSTNAME}:8004/v1/%(tenant_id)s" --adminurl "`[`http://`](http://)`${HEAT-HOSTNAME}:8004/v1/%(tenant_id)s --internalurl "`[`http://`](http://)`${HEAT-HOSTNAME}:8004/v1/%(tenant_id)s"

Update the paste files at `/etc/heat/heat-api{,-cfn,-cloudwatch}-paste.ini` with the credentials just created::

      admin_tenant_name = ${SERVICES_TENANT_NAME}
      admin_user = heat
      admin_password = ${HEAT_USER_PASSWORD}

In there you also need to make sure that the following variables are pointing to your Keystone host (127.0.0.1 should just work if you've used Packstack as Keystone is probably installed on the same host)::

      service_host = ${KEYSTONE-HOSTNAME}
      auth_host = ${KEYSTONE-HOSTNAME}
      auth_uri = `[`http://`](http://)`${KEYSTONE-HOSTNAME}:35357/v2.0
      keystone_ec2_uri = `[`http://`](http://)`${KEYSTONE-HOSTNAME}:5000/v2.0/ec2tokens

In `/etc/heat/heat-engine.conf` you've to make instead sure that the following variables \*\*do not\*\* point to 127.0.0.1 even though the services are actually hosted on the same system because URLs will be passed over to the VMs, which don't have them available locally::

      heat_metadata_server_url = `[`http://`](http://)`${HEAT-CFN-HOSTNAME}:8000
      heat_waitcondition_server_url = `[`http://`](http://)`${HEAT-CFN-HOSTNAME}:8000/v1/waitcondition
      heat_watch_server_url = `[`http://`](http://)`${HEAT-CLOUDWATCH-HOSTNAME}:8003

The application templates can use wait conditions and signaling for the orchestration, Heat needs to create special users to receive the progress data and these users are, by default, given the role of `heat_stack_user`. You can configure the role name in `heat-engine.conf` or just create a so called role::

      $ keystone role-create --name heat_stack_user

The configuration should now be complete and the services can be started::

      $ sudo -c "cd /etc/init.d && for s in $(ls openstack-heat-*); do chkconfig $s on && service $s start; done"

Make sure by checking the logs that everything was started successfully. Specifically, in case the engine service reports `ImportError: cannot import name Random` then you're probably using an old version of `pycrypto`. A fix has been merged upstream to workaround the issue. It's [a trivial change](https://review.openstack.org/#/c/26759/) which you can apply manually to `heat/common/crypt.py`.

### Get the demo files

It is time now to launch your first multi-instance cloud application! There are a number of sample templates available in the [github repo](https://github.com/openstack/heat), download the composed Wordpress example with::

`$ wget `[`https://raw.github.com/openstack/heat/master/templates/WordPress_Composed_Instances.template`](https://raw.github.com/openstack/heat/master/templates/WordPress_Composed_Instances.template)

Heat_ can use the templates distributed for [AWS CloudFormation](http://aws.amazon.com/cloudformation/). These expect you to have a well known set of flavor types defined while the default flavors available in OpenStack don't match strictly such a collection. To avoid the need of hack the templates, you can use a helpful script which recreates in OpenStack the same flavors from AWS::

      % curl `[`https://raw.github.com/openstack/heat/master/tools/nova_create_flavors.sh`](https://raw.github.com/openstack/heat/master/tools/nova_create_flavors.sh)` | bash

Every template also provides you with a list of usable distros and map these into an AMI string, for each arch. You will have to populate Glance with an image matching the AMI string that the template file is expecting to find.

There is a tool, <https://github.com/sdake/heat-jeos>, which can be used to create the JEOS images and upload them to Glance but there is also a collection of prebuilt images at: <http://fedorapeople.org/groups/heat/prebuilt-jeos-images/> so I suggest you to just download one from `F17-x86_64-cfntools.qcow2` or `U10-x86_64-cfntools.qcow2` (which are referred by many if not all the templates available in the Heat's repo). To upload the F17 x86_64 image in Glance::

`$ glance image-create --name F17-x86_64-cfntools --disk-format qcow2 --container-format bare --is-public True --copy-from `[`http://fedorapeople.org/groups/heat/prebuilt-jeos-images/F17-x86_64-cfntools.qcow2`](http://fedorapeople.org/groups/heat/prebuilt-jeos-images/F17-x86_64-cfntools.qcow2)

While that is downloading, create a new keypair or upload you public key in nova to make sure you'll be able to login on the VMs using SSH::

      $ nova keypair-add --pub_key ~/.ssh/id_rsa.pub userkey

### Launch!

It is time for the real fun now, launch your first composed application with::

      % heat-cfn create wordpress --template-file=WordPress_Composed_Instances.template --parameters="DBUsername=wp;DBPassword=wp;KeyName=userkey;LinuxDistribution=F17"

More parameters could have passed, note for instance the LinuxDistribution parameter discussed above. Now the interesting stuff::

      % heat-cfn list
      % heat-cfn event-list wordpress

After the VMs are launched, the mysql/httpd/wordpress installation and configuration begins, the process is driven by the `cfntools`, installed in the VMs images. It will take quite some time, despite the `event-list` reporting completion for the WordPress install too early (there is signaling, via `cfn-signal`, only in the MySQL template). You can login on the instances and check the logs or just use `ps` to see how things are going. After some minutes the setup should be finished::

      % heat-cfn describe wordpress
      % wget ${WebsiteURL} // that is an URL from the previous command!

If anything goes wrong, check the logs at `/var/log/heat/engine.log` or look at the scripts passed as `UserData` to the instances, these should be found in `/var/lib/cloud/data/`. Time to hack your very own template and delete the test deployment! :)
