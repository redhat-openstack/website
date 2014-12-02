---
title: MidoNet integration
authors: adjohn, fernando, fiveohmike, red trela, techcet, yantarou, zbigniewficner
wiki_title: MidoNet integration
wiki_revision_count: 172
wiki_last_updated: 2015-08-07
---

# MidoNet integration

To install MidoNet on RDO follow the [Redhat Enterprise Linux 7 Quick Start Guide](http://docs.midonet.org/docs/v1.8/quick-start-guide/rhel-7_icehouse/content/index.html), with the exception of the repository configuration, and OpenStack installation, as outlined below.

## Installing OpenStack

Install OpenStack using the procedure provided in the [RDO Quickstart](https://openstack.redhat.com/Quickstart).

Please verify that this is working before proceeding. Most installation issues come when a Packstack error has occurred but was ignored.

## Enabling RDO repositories

Enable the EDO repositories using the following command (as root):

      yum install -y https://rdo.fedorapeople.org/rdo-release.rpm

To enable the EPEL repository use this command:

      su -c 'rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm'

To enable 'optional' and 'extras' from the RHEL subscription run these commands (as root):

      yum -y install yum-utils
      yum-config-manager --enable rhel-7-server-optional-rpms
      yum-config-manager --enable rhel-7-server-extras-rpms

## Cleaning up Packstack OpenStack All-in-on Installation

The first steps to get MidoNet running on the All-in-one environment created by the Packstack installer is to clean up the network section in preparation of installing MidoNet.

Log in to your horizon dashboard as the Admin account and do the following:

*   1. Add the admin user to the "demo" tenant.
*   2. Move to the demo tenant, as admin, and delete the router, the private subnet and clear the router gateway.
*   3. Move back to the admin tenant and remove the public subnet (external network).

Next, we need to SSH into the Packstack system (in this case I am using RHEL 7). We need to remove services that will interfere with MidoNet and/or are no longer needed. This will break the networking of your PackStack until the MidoNet integration is complete. Please be aware of this before starting to make sure you have sufficient time.

*   1. Remove the OpenVswitch agent packages:

      yum remove openstack-neutron-openvswitch
