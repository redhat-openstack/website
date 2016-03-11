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

# RDO quickstart: Proof of concept for single node

If you want to spin up a proof of concept cloud on one node, this is the
place to be. You will be able to [add more nodes](Adding_a_compute_node) to your OpenStack cloud later, if you choose.

If you are looking for instructions to deploy a production cloud,
possibly with HA, see the [TripleO Quickstart](/tripleo).
If you just want to try it out without installing anything, check out [TryStack](http://trystack.org). 

These instructions are to install the current **Liberty** release.

## Summary for the impatient

Make sure your `/etc/environment` is populated:
    
    LANG=en_US.utf-8
    LC_ALL=en_US.utf-8

If your system meets all the prerequisites mentioned below, proceed with running the following commands:

    $ sudo yum install -y https://www.rdoproject.org/repos/rdo-release.rpm
    $ sudo yum update -y
    $ sudo yum install -y openstack-packstack
    $ packstack --allinone

## Step 0: Prerequisites

### Software

**Red Hat Enterprise Linux (RHEL) 7** is the minimum recommended version, or 
the equivalent version of one of the RHEL-based Linux distributions such as CentOS, 
Scientific Linux, and so on. **x86_64** is currently the only supported architecture. 
See also [RDO repository info](repositories) for details on required repositories. 
Please name the host with a fully qualified domain name rather than a short-form 
name to avoid DNS issues with Packstack.

### Hardware

Machine with at least 4GB RAM, processors with hardware 
virtualization extensions, and at least one network adapter.

### Network

If you plan on having **external** network access to the 
server and instances, this is a good moment to properly configure your network settings.
A static IP address to your network card, and disabling NetworkManager are good ideas. 
If you are planing on something fancier, read [this document on advanced
networking](https://www.rdoproject.org/networking/neutron-with-existing-external-network/)
**before proceeding**.

## Step 1: Software repositories

Setup the RDO repositories:

    $ sudo yum install -y https://rdoproject.org/repos/rdo-release.rpm
    
Update your current packages:

    $ sudo yum update -y

_Looking for an older version? See [http://rdoproject.org/repos/](http://rdoproject.org/repos/) for the full listing._

## Step 2: Install Packstack Installer

    $ sudo yum install -y openstack-packstack

## Step 3: Run Packstack to install OpenStack

Packstack takes the work out of manually setting up OpenStack. For a single node OpenStack deployment, run the following command:

    $ packstack --allinone

If you encounter failures, see the [Workarounds](Workarounds) page for tips.

If you have run Packstack previously, there will be a file in your home directory named something like `packstack-answers-20130722-153728.txt` You will probably want to use that file again, using the `--answer-file` option, so that any passwords you have already set (for example, mysql) will be reused.

The installer will ask you to enter the root password for each host node you are installing on the network, to enable remote configuration of the host so it can remotely configure each node using Puppet.

Once the process is complete, you can log in to the OpenStack web interface Horizon by going to [http://$YOURIP/dashboard](http://$YOURIP/dashboard). The user name is `admin`. The password can be found in the file `keystonerc_admin` in the `/root` directory of the control node.

# Next steps

Now that your single node OpenStack instance is up and running, you can read on about [running an instance](Running_an_instance), configuring a [floating IP range](Floating_IP_range), configuring RDO to [work with your existing network](Neutron_with_existing_external_network), or about expanding your installation by [adding a compute node](Adding_a_compute_node).

