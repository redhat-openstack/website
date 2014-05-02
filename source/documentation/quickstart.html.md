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

<div class="bg-boxes bg-boxes-single">
<div class="row">
<div class="offset3 span8">
# RDO Quickstart

Deploying RDO is a quick and easy process. Setting up an OpenStack cloud takes approximately 15 minutes, and can be as short as 3 steps.

Below, we'll explain how to set up OpenStack on a single server. You'll be able to [add more nodes](Adding_a_compute_node) to your OpenStack cloud later, if you choose.

If you just want to try it out without installing anything, check out [TryStack](http://trystack.org).

These instructions are to install the current ("**Icehouse**") release.

</div>
</div>
<div class="row">
<div class="offset3 span8 pull-s">
### Step 0: Prerequisites

<div class="row">
<div class="span4">
**Software:** Red Hat Enterprise Linux (RHEL) 6.5 is the minimum recommended version, or the equivalent version of one of the RHEL-based Linux distributions such as CentOS, Scientific Linux, etc., or Fedora 20 or later. See also [ RDO repository info](Repositories) for details on required repositories. Please name the host with a fully qualified domain name rather than a short-form name to avoid DNS issues with Packstack.

</div>
<div class="span4">
**Hardware:** Machine with at least 2GB RAM, processors with hardware virtualization extensions, and at least one network adapter.

</div>
</div>
### Step 1: Software repositories

If on Fedora 21, please skip to step 2

Update your current packages:

    sudo yum update -y

Setup the RDO repositories:

    sudo yum install -y http://rdo.fedorapeople.org/rdo-release.rpm

*Looking for an older version? See <http://rdo.fedorapeople.org/> for the full listing.*

### Step 2: Install Packstack Installer

    sudo yum install -y openstack-packstack

### Step 3: Run Packstack to install OpenStack

Packstack takes the work out of manually setting up OpenStack. For a single node OpenStack deployment, run the following command.

If on RHEL7, or Fedora 20/21, please make SELinux permissive for now, with: \`sudo setenforce permissive\`

    packstack --allinone

If you encounter failures, see the [Workarounds](Workarounds) page for tips.

If you have run packstack previously, there will be a file in your home directory named something like packstack-answers-20130722-153728.txt You will probably want to use that file again, using the --answer-file option, so that any passwords you've already set (eg, mysql) will be reused.

The installer will ask you to enter the root password for each host node you are installing on the network, to enable remote configuration of the host so it can remotely configure each node using Puppet.

Once the process is complete, you can log in to the OpenStack web interface "Horizon" by going to <http://$YOURIP/dashboard>. The username is "admin". The password can be found in the file keystonerc_admin in the /root/ directory of the control node.

# Next Steps

Now that your single node OpenStack instance is up and running, you can read on about [running an instance](running an instance), configuring a [floating IP range](floating IP range), or about expanding your installation by [adding a compute node](adding a compute node).

</div>
</div>
<div class="row">
<div class="offset2 span8">
</div>
</div>
<Category:Documentation>
