---
title: TripleO Troubleshooting
authors: snecklifter
wiki_title: TripleO Troubleshooting
wiki_revision_count: 1
wiki_last_updated: 2016-01-21
---

# TripleO Troubleshooting

## Undercloud

The undercloud is a basic OpenStack cloud leveraging Ironic, Heat and others for installing the main production cloud. Although you can enable debug for all undercloud components as part of the undercloud.conf file, this generates a huge amount of log output. Leaving this as false is usually fine.

##### Installation Errors
~~~
No package foo available
~~~
Most likely you are missing a repository. RDO currently requires EPEL so:

~~~
sudo yum -y install epel-release
~~~

~~~
Error: Could not run: Could not retrieve facts for $NODENAME: no address for $NODENAME
~~~
Remove the errant dns domain from the search parameter in /etc/resolv.conf. Usually due to one interface being on DHCP.

## Overcloud

The overcloud is the main production cloud deployed to baremetal or virtual machines from the undercloud. Expect most of your problems to arise here. Check logs for ironic, nova, heat and glance.

### Heat

Some good documentation on the main OpenStack wiki [here](https://wiki.openstack.org/wiki/Heat/TroubleShooting)
A good Red Hat article on debugging the overcloud [here](https://access.redhat.com/solutions/1982603)

#### Tips

Interface naming: Try using the specific interface names in templates (e.g. eno1, enps01) rather than the default nic1, nic2 etc. Some hardware ships with built-in usb ethernet devices which tripleo currently sees as an active device.

##### ipmitool

If your baremetal nodes have serial console configured and enabled, use ipmitool to view console output thus:

~~~
ipmitool -H $NODE_IPADDRESS -I lanplus -U $USERNAME -P $PASSWORD sol activate
~~~
If this works you should get the following output:

~~~
[SOL Session operational.  Use ~? for help]
~~~

##### No valid host was found. There are not enough hosts available

This is usually due to a flavor/node mismatch. Try:

~~~
openstack baremetal configure boot
~~~

#### Building images behind a proxy server

You need to create http and https local proxy variables, and also add the proxy to curl and yum files.

For example - 

~~~
export NODE_DIST="centos7"
export http_proxy=http://[proxy]:[port]
export https_proxy=http://[proxy]:[port]
export DIB_CLOUD_IMAGES="http://cloud.centos.org/centos/7/images/"
export BASE_IMAGE_FILE="CentOS-7-x86_64-GenericCloud-1511.qcow2"
export DELOREAN_TRUNK_REPO="http://trunk.rdoproject.org/centos7-liberty/current/"
export USE_DELOREAN_TRUNK=1
export DELOREAN_REPO_FILE="delorean.repo"
~~~

~~~
cat ~/.curlrc
proxy = http://[proxy]:[port]

sudo grep proxy /etc/yum.conf 
proxy = http://[proxy]:[port]
~~~

Then build images - 

~~~
openstack overcloud image build --all
~~~
