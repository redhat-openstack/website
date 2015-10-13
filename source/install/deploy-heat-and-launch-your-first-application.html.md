---
title: Deploy Heat and launch your first Application
authors: bluesman, dneary, gfidente, rbowen, sbaker, sdake, shardy, vaneldik, zaneb
wiki_title: Deploy Heat and launch your first Application
wiki_revision_count: 47
wiki_last_updated: 2013-10-01
---

*TODO: Update to Liberty, or remove entirely*

# Deploy Heat and launch your first Application

{:.no_toc}

## Deploy OpenStack Heat on RDO Grizzly

[Heat](http://wiki.openstack.org/wiki/Heat) provides orchestration of composite cloud applications. Heat is an officially integrated OpenStack project from the Havana release.

> Heat is a service to orchestrate multiple composite cloud applications using either native "HOT" templates, or AWS CloudFormation template format. Heat provides both an OpenStack-native ReST API and a CloudFormation-compatible Query API.

This guide deploys a composite application (made up of more than a single instance) on the cloud infrastructure. This also involves launch-time customization of the VMs. This guide makes some assumptions:

*   OpenStack has already been configured via PackStack as described in the QuickStart guide
*   OpenStack is deployed on RHEL 6.4 or Fedora 19

### Installation

Start by installing the required packages for Heat to work:

      $ sudo yum install "openstack-heat-*" python-heatclient

You'll get four new services installed: an engine, a native api, a cloudformation compatible api, a cloudwatch compatible api. You don't have to deploy them all on a single host but for the purpose of this guide it will be fine to do so.

python-heatclient installs a python CLI tool "heat", which is used to interact with the heat native API

### Configuration

Heat comes with a script which creates (and populates) the needed database for it to work but you need to know your MySQL's `root` account password. If you've used PackStack, than that is saved as `CONFIG_MYSQL_PW` in the answers file (`/root/packstack-answers*` by default). Now run the prepare script:

      $ sudo heat-db-setup rpm -y -r ${MYSQL_ROOT_PASSWORD} -p ${HEAT_DB_PASSWORD_OF_CHOICE}

Check in `/etc/heat/heat-engine.conf` that your database connection string is correct::

      sql_connection = mysql://heat:${HEAT_DB_PASSWORD}@localhost/heat

`/etc/heat/heat-engine.conf` contains a placeholder value for `auth_encryption_key` which needs to be replaced with a randomly generated key::

      ` sed -i "s/%ENCRYPTION_KEY%/`hexdump -n 16 -v -e '/1 "%02x"' /dev/random`/" /etc/heat/heat-engine.conf `

Now go through the usual steps needed to create a new user, service and endpoint with Keystone and don't forget to source the admin credentials before starting (which are in `/root/keystonerc_admin` if you've used PackStack)::

      $ keystone user-create --name heat --pass ${HEAT_USER_PASSWORD_OF_CHOICE} --tenant-id ${SERVICES_TENANT_ID}
      $ keystone user-role-add --user heat --role admin --tenant ${SERVICES_TENANT_NAME}
      $ keystone service-create --name heat --type orchestration
      $ keystone service-create --name heat-cfn --type cloudformation
      $ keystone endpoint-create --region RegionOne --service-id ${HEAT_CFN_SERVICE_ID} --publicurl "`[`http://`](http://)`${HEAT_CFN_HOSTNAME}:8000/v1" --adminurl "`[`http://`](http://)`${HEAT_CFN_HOSTNAME}:8000/v1" --internalurl "`[`http://`](http://)`${HEAT_CFN_HOSTNAME}:8000/v1"
      $ keystone endpoint-create --region RegionOne --service-id ${HEAT_SERVICE_ID} --publicurl "`[`http://`](http://)`${HEAT_HOSTNAME}:8004/v1/%(tenant_id)s" --adminurl "`[`http://`](http://)`${HEAT_HOSTNAME}:8004/v1/%(tenant_id)s" --internalurl "`[`http://`](http://)`${HEAT_HOSTNAME}:8004/v1/%(tenant_id)s"

Note: `${HEAT_HOSTNAME}` should be replaced by the hostname or IP address of your Heat host, while `%(tenant_id)` should remain literally as is in these commands. The various service IDs may be obtained by running the `keystone service-list` command.

For Grizzly, update the paste files at `/etc/heat/heat-api{,-cfn,-cloudwatch}-paste.ini` with the credentials just created::

      admin_tenant_name = ${SERVICES_TENANT_NAME}
      admin_user = heat
      admin_password = ${HEAT_USER_PASSWORD}

For Havana, update the config files at `/etc/heat/heat-api{,-cfn,-cloudwatch}.conf` with the credentials just created::

      admin_tenant_name = ${SERVICES_TENANT_NAME}
      admin_user = heat
      admin_password = ${HEAT_USER_PASSWORD}

**Note**: Check your value for ${SERVICES_TENANT_NAME} carefully, the packstack default tenant is "**services**", whereas some other install methods (which use /usr/share/openstack-keystone/sample_data.sh) name it "**service**"

In there you also need to make sure that the following variables are pointing to your Keystone host (127.0.0.1 should just work if you've used PackStack as Keystone is probably installed on the same host)::

      service_host = ${KEYSTONE_HOSTNAME}
      auth_host = ${KEYSTONE_HOSTNAME}
      auth_uri = `[`http://`](http://)`${KEYSTONE_HOSTNAME}:35357/v2.0
      keystone_ec2_uri = `[`http://`](http://)`${KEYSTONE_HOSTNAME}:5000/v2.0/ec2tokens

In `/etc/heat/heat-engine.conf` you've to make instead sure that the following variables \*\*do not\*\* point to 127.0.0.1 even though the services are actually hosted on the same system because URLs will be passed over to the VMs, which don't have them available locally::

      heat_metadata_server_url = `[`http://`](http://)`${HEAT_CFN_HOSTNAME}:8000
      heat_waitcondition_server_url = `[`http://`](http://)`${HEAT_CFN_HOSTNAME}:8000/v1/waitcondition
      heat_watch_server_url = `[`http://`](http://)`${HEAT_CLOUDWATCH_HOSTNAME}:8003

The application templates can use wait conditions and signaling for the orchestration, Heat needs to create special users to receive the progress data and these users are, by default, given the role of `heat_stack_user`. You can configure the role name in `heat-engine.conf` or just create a so called role::

      $ keystone role-create --name heat_stack_user

The configuration should now be complete and the services can be started::

      $ sudo -c "cd /etc/init.d && for s in $(ls openstack-heat-*); do chkconfig $s on && service $s start; done"

Or, for systems running systemd (eg F19)

      $ cd /usr/lib/systemd/system
      $ ls openstack-heat* | sed 's/.service//'  | xargs sudo systemctl enable
      $ ls openstack-heat* | sed 's/.service//'  | xargs sudo systemctl start

Make sure by checking the logs that everything was started successfully. Specifically, in case the engine service reports `ImportError: cannot import name Random` then you're probably using an old version of `pycrypto`. A fix has been merged upstream to workaround the issue. It's [a trivial change](https://review.openstack.org/#/c/26759/) which you can apply manually to `heat/common/crypt.py`.

You are now ready to [deploy an application with Heat](deploy an application with Heat)!
