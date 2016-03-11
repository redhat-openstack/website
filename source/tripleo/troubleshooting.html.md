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
