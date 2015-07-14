---
title: Quickstart
category: documentation
authors: apevec, dneary, garrett, jasonbrooks, jlibosva, mmagr, pixelbeat, pmyers,
  rbowen
wiki_category: Documentation
wiki_title: Quickstart
wiki_revision_count: 141
wiki_last_updated: 2015-06-30
layout: headlinepull
---

# RDO Quickstart

Deploying RDO is a quick and easy process. Setting up an OpenStack cloud takes approximately 15 minutes, and can be as short as 3 steps.

Below, we'll explain how to set up OpenStack on a single server. You'll be able to [add more nodes](Adding_a_compute_node) to your OpenStack cloud later, if you choose.

If you just want to try it out without installing anything, check out [TryStack](http://trystack.org). See also [Installation](Install#Installation) for alternate deployment methods.

These instructions are to install the current ("**Kilo**") release.

## Summary for the Impatient

    sudo yum update -y
    sudo yum install -y https://rdoproject.org/repos/rdo-release.rpm
    sudo yum install -y openstack-packstack
    packstack --allinone

## Step 0: Prerequisites

**Software:** Red Hat Enterprise Linux (RHEL) **7** is the minimum recommended version, or the equivalent version of one of the RHEL-based Linux distributions such as CentOS, Scientific Linux, etc., or Fedora 21. **x86_64** is currently the only supported architecture. See also [RDO repository info](Repositories) for details on required repositories. Please name the host with a fully qualified domain name rather than a short-form name to avoid DNS issues with Packstack.

**Hardware:** Machine with at least 4GB RAM, processors with hardware virtualization extensions, and at least one network adapter.

In case your system is running with NetworkManager, you need to disable it. (See [bz1117277](https://bugzilla.redhat.com/show_bug.cgi?id=1117277) for discussion of why.)

Stop and disable NetworkManager:

    systemctl stop NetworkManager
    systemctl disable NetworkManager
    systemctl enable network

Make sure devices are named properly for the network daemon: i.e. the following line must be present in `/etc/sysconfig/network-scripts/ifcfg-<interface_name>`

    DEVICE="<interface_name>"

where `<interface_name>` is usually "eth0" or "em1".

Take down all interfaces (but the one via you're connected to the machine) with:

    ifdown <interface_name>

Start the network daemon:

    ifdown <interface_name> && systemctl start network

## Step 1: Software repositories

Update your current packages:

    sudo yum update -y

Setup the RDO repositories:

    sudo yum install -y https://rdoproject.org/repos/rdo-release.rpm

_Looking for an older version? See [http://rdoproject.org/repos/](http://rdoproject.org/repos/) for the full listing._

## Step 2: Install Packstack Installer

    sudo yum install -y openstack-packstack

## Step 3: Run Packstack to install OpenStack

Packstack takes the work out of manually setting up OpenStack. For a single node OpenStack deployment, run the following command.

    packstack --allinone

If you encounter failures, see the [Workarounds](Workarounds) page for tips.

If you have run packstack previously, there will be a file in your home directory named something like `packstack-answers-20130722-153728.txt` You will probably want to use that file again, using the --answer-file option, so that any passwords you've already set (e.g.: mysql) will be reused.

The installer will ask you to enter the root password for each host node you are installing on the network, to enable remote configuration of the host so it can remotely configure each node using Puppet.

Once the process is complete, you can log in to the OpenStack web interface "Horizon" by going to [http://$YOURIP/dashboard](http://$YOURIP/dashboard). The username is "admin". The password can be found in the file `keystonerc_admin` in the /root/ directory of the control node.

# Next Steps

Now that your single node OpenStack instance is up and running, you can read on about [running an instance](Running_an_instance), configuring a [floating IP range](Floating_IP_range), configuring RDO to [work with your existing network](Neutron_with_existing_external_network), or about expanding your installation by [adding a compute node](Adding_a_compute_node).
