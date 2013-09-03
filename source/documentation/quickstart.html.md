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

*If you want to try out the development version (code name: Havana), see the [Havana QuickStart](QuickStartLatest). If you want to run the OpenStack Folsom release, check out [Red Hat OpenStack Early Adopter Edition](//redhat.com/openstack) or install the openstack-packstack package from the Fedora 18 repository.*

</div>
</div>
<div class="row">
<div class="offset3 span8 pull-s">
### Step 0: Prerequisites

<div class="row">
<div class="span4">
**Software:** Red Hat Enterprise Linux (RHEL) 6.4, or the equivalent version of one of the RHEL-based Linux distributions such as CentOS, Scientific Linux, etc., or Fedora 18 or later. See also [ RDO repository info](Repositories) for details on required repositories. Please name the host with a fully qualified domain name rather than a short-form name to avoid DNS issues with Packstack.

</div>
<div class="span4">
**Hardware:** Machine with at least 2GB RAM, processors with hardware virtualization extensions, and at least one network adapter.

</div>
</div>
### Step 1: Software repositories

Run the following command for Grizzly:

    sudo yum install -y http://rdo.fedorapeople.org/openstack/openstack-grizzly/rdo-release-grizzly.rpm

If you want to try out Havana instead:

    sudo yum install -y http://rdo.fedorapeople.org/openstack/openstack-havana/rdo-release-havana.rpm

### Step 2: Install Packstack Installer

    sudo yum install -y openstack-packstack

### Step 3: Run Packstack to install OpenStack

Packstack takes the work out of manually setting up OpenStack. For a single node OpenStack deployment, run the following command.

For Grizzly, the OpenStack Networking component was called Quantum, so you will want to run:

    packstack --allinone --os-quantum-install=n

(On Fedora 19, omit the *--os-quantum-install=n* argument.)

If you are trying out Havana, OpenStack Networking is called Neutron now, so you should run:

    packstack --allinone --os-neutron-install=n

*Advanced users: Packstack does have some support for Neutron networking, however, until we have better support for Neutron and some documentation on the wiki for it, we recommend Nova Networking for now. If you are interested in trying out Neutron in an all-in-one single host configuration, take a look at [ Quick start guide with Neutron](Neutron-Quickstart)*

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
