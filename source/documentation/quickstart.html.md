---
title: Quickstart
category: documentation
authors: apevec, dneary, garrett, jasonbrooks, jlibosva, mmagr, pixelbeat, pmyers,
  rbowen
wiki_category: Documentation
wiki_title: Quickstart
wiki_revision_count: 141
wiki_last_updated: 2015-06-30
---

__NOTOC__

<div class="bg-boxes">
<div class="row">
<div class="offset3 span8">
# RDO Quickstart

Deploying RDO is a quick and easy process. Setting up an OpenStack cloud takes approximately 12 minutes, and can be as short as 4 steps.

Below, we'll explain how to set up OpenStack on a single server. You'll be able to add more nodes to your OpenStack cloud later, if you choose.

</div>
</div>
<div class="row">
<div class="offset3 span8 pull-s">
### Step 0: Prerequisites

<div class="row">
<div class="span4">
**Software:** Fedora, Red Hat Enterprise Linux (RHEL), or one of the RHEL-based Linux distributions such as CentOS, Scientific Linux, etc.

</div>
<div class="span4">
**Hardware:** Machine with at least 2GB RAM, processors with hardware virtualization extensions, and at least one network adapter.

</div>
</div>
### Step 1: Software repositories

Run the following command:

#### For Fedora:

    sudo yum localinstall http://openstack.redhat.com/releases/rdo-grizzly-fedora-release.rpm

#### For RHEL and derivatives:

    sudo yum localinstall -y http://openstack.redhat.com/releases/rdo-grizzly-epel-release.rpm

### Step 2: Install Packstack Installer

    sudo yum install -y openstack-packstack

### Step 3: Run Packstack to install OpenStack

Packstack takes the work out of manually setting up OpenStack. For a single node OpenStack deployment, run the following command, including your test machine's IP address.

    packstack --install-hosts=$YOURIP --novacompute-privif=lo --novanetwork-privif=lo

The installer will ask you to enter the root password for each host node you are installing on the network, to enable remote configuration of the host so it can remotely configure each node using Puppet.

Once the process is complete, you can log in to the OpenStack web interface "Horizon" by going to <http://CONTROL_NODE/dashboard>. The username is "admin". The password can be found in the file keystonerc_admin in the /root/ directory of the control node.

# Next Steps

Now that your single node OpenStack instance is up and running, you can read on about [running an instance](running an instance), configuring a [floating ip range](floating ip range), or about expanding your installation by [adding a compute node](adding a compute node).

</div>
</div>
<div class="row">
<div class="offset2 span8">
</div>
</div>
