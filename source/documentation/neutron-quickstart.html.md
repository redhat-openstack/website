---
title: Neutron-Quickstart
category: documentation
authors: jrovins, kashyap, mangelajo, otherwiseguy, pmyers, rbowen, sross
wiki_category: Documentation
wiki_title: Neutron-Quickstart
wiki_revision_count: 37
wiki_last_updated: 2015-04-01
---

# Neutron-Quickstart

__NOTOC__

<div class="bg-boxes bg-boxes-single">
<div class="row">
<div class="offset3 span8">
## RDO Quickstart

Deploying RDO is a quick and easy process. Setting up an OpenStack Grizzly cloud takes approximately 15 minutes, and can be as short as 3 steps.

Below, we'll explain how to set up OpenStack on a single server. You'll be able to [add more nodes](Adding_a_compute_node) to your OpenStack cloud later, if you choose.

*Note: If you want to run the OpenStack Folsom release, check out [Red Hat OpenStack Early Adopter Edition](//redhat.com/openstack) or install the openstack-packstack package from the Fedora 18 repository.*

</div>
</div>
<div class="row">
<div class="offset3 span8 pull-s">
### Step 0: Prerequisites

<div class="row">
<div class="span4">
**Software:** Red Hat Enterprise Linux (RHEL) 6.4, or the equivalent version of one of the RHEL-based Linux distributions such as CentOS, Scientific Linux, etc., or Fedora 18 or later. See also [ RDO repository info](Repositories) for details on required repositories.

</div>
<div class="span4">
**Hardware:** Machine with at least 2GB RAM, processors with hardware virtualization extensions, and at least one network adapter.

</div>
</div>
### Step 1: Software repositories

Run the following command:

    sudo yum install -y http://rdo.fedorapeople.org/openstack/openstack-grizzly/rdo-release-grizzly.rpm

### Step 2: Install Packstack Installer

Right now, there is a test build of Packstack required to enable Neutron to be properly deployed. The test build can be found here: <http://koji.fedoraproject.org/koji/buildinfo?buildID=437715>

Or you can just run this command:

    sudo yum install -y http://kojipkgs.fedoraproject.org//packages/openstack-packstack/2013.1.1/0.21.dev651.el6/noarch/openstack-packstack-2013.1.1-0.21.dev651.el6.noarch.rpm

### Step 3: Run Packstack to install OpenStack

Packstack takes the work out of manually setting up OpenStack. For a single node OpenStack deployment, run the following command.

    packstack --allinone

The installer will ask you to enter the root password for each host node you are installing on the network, to enable remote configuration of the host so it can remotely configure each node using Puppet.

Once the process is complete, you can log in to the OpenStack web interface "Horizon" by going to <http://$YOURIP/dashboard>. The username is "demo". The password can be found in the file keystonerc_demo in the /root/ directory of the control node.

## Next Steps

Now that your single node OpenStack instance is up and running, you can read on about [running an instance with Neutron](running an instance with Neutron), configuring a [floating IP range](floating IP range), or about expanding your installation by [adding a compute node](adding a compute node).

</div>
</div>
<div class="row">
<div class="offset2 span8">
</div>
</div>
<Category:Documentation>
