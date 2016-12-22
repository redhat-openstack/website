---
title: Packstack quickstart
category: documentation
authors: apevec, dneary, garrett, jasonbrooks, jlibosva, mmagr, pixelbeat, pmyers,
  rbowen, gbraad
wiki_category: Documentation
wiki_title: Quickstart
wiki_revision_count: 141
wiki_last_updated: 2015-06-30
---

# All-in-one quickstart: Proof of concept for single node

This document shows how to spin up a proof of concept cloud on one node, using the Packstack installation utility. You will be able to [add more nodes](/install/adding-a-compute-node/) to your OpenStack cloud later, if you choose.

* If you are looking for instructions on how to deploy a production-ready cloud, possibly with HA, see the [TripleO quickstart](/tripleo).

* If you just want to try out OpenStack without installing anything, check out [TryStack](http://trystack.org).

The instructions apply to the current **Newton** release.

## Summary for the impatient

If you are using non-English locale make sure your `/etc/environment` is populated:
    
    LANG=en_US.utf-8
    LC_ALL=en_US.utf-8

If your system meets all the prerequisites mentioned below, proceed with running the following commands.

* On RHEL:

  ```
  $ sudo yum install -y https://www.rdoproject.org/repos/rdo-release.rpm
  $ sudo yum update -y
  $ sudo yum install -y openstack-packstack
  $ sudo packstack --allinone
  ```

* On CentOS:

  ```
  $ sudo yum install -y centos-release-openstack-newton
  $ sudo yum update -y
  $ sudo yum install -y openstack-packstack
  $ sudo packstack --allinone
  ```

## Step 0: Prerequisites

### Software

**Red Hat Enterprise Linux (RHEL) 7** is the minimum recommended version, or the equivalent version of one of the RHEL-based Linux distributions such as **CentOS**, **Scientific Linux**, and so on. **x86_64** is currently the only supported architecture.

* See [RDO repositories](/documentation/repositories/) for details on required repositories.

Name the host with a fully qualified domain name rather than a short-form name to avoid DNS issues with Packstack.

### Hardware

Machine with at least 4GB RAM, preferably 6GB RAM, processors with hardware virtualization extensions, and at least one network adapter.

### Network

If you plan on having **external** network access to the server and instances, this is a good moment to properly configure your network settings. A static IP address to your network card, and disabling NetworkManager are good ideas.

```
$ sudo systemctl disable firewalld
$ sudo systemctl stop firewalld
$ sudo systemctl disable NetworkManager
$ sudo systemctl stop NetworkManager
$ sudo systemctl enable network
$ sudo systemctl start network
```

If you are planing on something fancier, read [the document on advanced networking](https://www.rdoproject.org/networking/neutron-with-existing-external-network/) **before proceeding**.

## Step 1: Software repositories

On RHEL, download and install the RDO repository RPM to set up the OpenStack repository:

```
$ sudo yum install -y https://rdoproject.org/repos/rdo-release.rpm
```
  
On CentOS, the `Extras` repository provides the RPM that enables the OpenStack repository. `Extras` is enabled by default on CentOS 7, so you can simply install the RPM to set up the OpenStack repository:

```
$ sudo yum install -y centos-release-openstack-newton
```

Update your current packages:

```
$ sudo yum update -y
```

_Looking for an older version? See [http://rdoproject.org/repos/](http://rdoproject.org/repos/) for the full listing._

## Step 2: Install Packstack Installer

```
$ sudo yum install -y openstack-packstack
```

## Step 3: Run Packstack to install OpenStack

Packstack takes the work out of manually setting up OpenStack. For a single node OpenStack deployment, run the following command:

```
$ sudo packstack --allinone
```
  
If you encounter failures, see the [Workarounds](/testday/workarounds/) page for tips.

If you have run Packstack previously, there will be a file in your home directory named something like `packstack-answers-20130722-153728.txt` You will probably want to use that file again, using the `--answer-file` option, so that any passwords you have already set (for example, mysql) will be reused.

The installer will ask you to enter the root password for each host node you are installing on the network, to enable remote configuration of the host so it can remotely configure each node using Puppet.

Once the process is complete, you can log in to the OpenStack web interface Horizon by going to `http://$YOURIP/dashboard`. The user name is `admin`. The password can be found in the file `keystonerc_admin` in the `/root` directory of the control node.

# Next steps

Now that your single node OpenStack instance is up and running, you can read on about [running an instance](/install/running-an-instance/), configuring a [floating IP range](/networking/floating-ip-range/), configuring RDO to [work with your existing network](/networking/neutron-with-existing-external-network/), or about expanding your installation by [adding a compute node](/install/adding-a-compute-node/).
