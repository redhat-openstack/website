---
title: Packstack
category: documentation
authors: apevec, dneary, garrett, jasonbrooks, jlibosva, mmagr, pixelbeat, pmyers,
  rbowen, gbraad, cbrown2, amoralej
---

# Packstack: Create a proof of concept cloud

Packstack is an OpenStack deployment tool intended to **install Proof of Concept small environments in a quick and easy way using the RDO distribution on a CentOS Stream hosts**. 
Production features such as High Availability, OpenStack upgrades or other day-2 operations are out of the scope of Packstack. For these cases, you can rely on other recommended tools 
such as [TripleO](https://tripleo-docs.readthedocs.io/en/latest/index.html) for an OpenStack Zed or earlier release, [Kolla](https://docs.openstack.org/kolla/latest/) or 
[Openstack-Ansible](https://docs.openstack.org/openstack-ansible/latest/).

This document shows how to spin up a proof of concept cloud on one node using the Packstack installation utility. You will be able to [add more nodes](/install/adding-a-compute-node/) to your OpenStack cloud later, if you choose.

These instructions apply to the following Release and Operating Systems -  **Victoria, Wallaby, Xena and Yoga** on CentOS Stream 8, and **Yoga, Zed and Antelope** on CentOS Stream 9.

## WARNING ##

**Read** this document in full, **then** choose your install path:

Don't just start typing commands at **Summary for the impatient** and proceed downwards through the page.

## Summary for the impatient

If you are using non-English locale make sure your `/etc/environment` is populated:

    LANG=en_US.utf-8
    LC_ALL=en_US.utf-8

If your system meets all the prerequisites mentioned below, proceed with running the following commands.

* On CentOS Stream 8:

  ```
  $ sudo dnf update -y
  $ sudo dnf config-manager --enable powertools
  $ sudo dnf install -y centos-release-openstack-yoga # Replace yoga by the desired release name
  $ sudo dnf update -y
  $ sudo dnf install -y openstack-packstack
  $ sudo packstack --allinone
  ```

* On CentOS Stream 9:

  ```
  $ sudo dnf update -y
  $ sudo dnf config-manager --enable crb
  $ sudo dnf install -y centos-release-openstack-bobcat
  $ sudo setenforce 0
  $ sudo dnf update -y
  $ sudo dnf install -y openstack-packstack
  $ sudo packstack --allinone
  ```

**Note for RHEL:** Although it is expected that RDO works fine on RHEL, it is currently not tested in RHEL OS.

* On RHEL 8:

  ```
  $ sudo dnf install -y https://www.rdoproject.org/repos/rdo-release.el8.rpm
  $ sudo dnf update -y
  $ subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
  $ sudo dnf install -y openstack-packstack
  $ sudo packstack --allinone
  ```

## Step 0: Prerequisites

### Software

**CentOS Stream 8** is the minimum recommended version, or the equivalent version of one of the RHEL-based Linux distributions such as **Red Hat Enterprise Linux**, **Scientific Linux**, and so on. Packages are provided for **x86_64**, **aarch64** and **ppc64le** architectures although most of the testing is done on **x86_64**.

### Hardware

Machine with at least 16GB RAM, processors with hardware virtualization extensions, and at least one network adapter.

### Hostname

Name the host with a fully qualified domain name rather than a short-form name to avoid DNS issues with Packstack.

### Network

If you plan on having **external** network access to the server and instances, this is a good moment to properly configure your network settings. A static IP address to your network card, and disabling NetworkManager are good ideas.

**On CentOS Stream 8/RHEL 8:**

network-scripts is deprecated and not installed by default, so needs to be installed explicitly.

```
$ sudo dnf install network-scripts -y
```

Disable firewalld and NetworkManager

```
$ sudo systemctl disable firewalld
$ sudo systemctl stop firewalld
$ sudo systemctl disable NetworkManager
$ sudo systemctl stop NetworkManager
$ sudo systemctl enable network
$ sudo systemctl start network
```

If you are planning on something fancier, read [the document on advanced networking](https://www.rdoproject.org/networking/neutron-with-existing-external-network/) **before proceeding**.

## Step 1: Software repositories

On CentOS Stream 8, first you need to enable the `powertools` repository.
Then, the `Extras` repository provides the RPM that enables the OpenStack repository. `Extras` is enabled by default on CentOS 8, so you can simply install the RPM to set up the OpenStack repository:
```
$ sudo dnf config-manager --enable powertools
$ sudo dnf install -y centos-release-openstack-yoga
```

On CentOS Stream 9, first you need to enable the `crb`.
Then, the `extras-common` repository provides the RPM that enables the OpenStack repository. It is enabled by default on CentOS Stream 9, so you can simply install the RPM to set up the OpenStack repository:
```
$ sudo dnf config-manager --enable crb
$ sudo dnf install -y centos-release-openstack-bobcat
```

On RHEL 8, install the RDO repository RPM to setup the Openstack repository, then you must enable the `codeready-builder` option in `subscription-manager`:
```
$ sudo dnf install -y https://www.rdoproject.org/repos/rdo-release.el8.rpm
$ subscription-manager repo --enable codeready-builder-for-rhel-8-x86_64-rpms
```

Update your current packages:

```
$ sudo dnf update -y
```

_Looking for an older version? See [http://rdoproject.org/repos/](http://rdoproject.org/repos/) for the full listing._

## Step 2: Install Packstack Installer

```
$ sudo dnf install -y openstack-packstack
```

## Step 3: Disable selinux enforcing mode

There are known issues with selinux policies and rabbitmq in CentOS Stream 9. Disable selinux enforcing mode:

```
$ sudo setenforce 0
```

## Step 4: Run Packstack to install OpenStack

Packstack takes the work out of manually setting up OpenStack. It provides a set of options to specify the desired services and configurations for each installation. You can list all the available parameters using:

```
$ packstack --help
```

For a simple, single node OpenStack deployment with default options, run the following command:

```
$ sudo packstack --allinone
```

The Packstack command line interface accepts an answers file as a mechanism to specify the parameters. The base answers file can be created with:

```
$ packstack --gen-answer-file
```

Then can be used by using `--answer-file` option:

```
$ sudo packstack --answer-file=<path to the answers file>
```

If you have run Packstack previously, there will be a file in your home directory named something like `packstack-answers-20130722-153728.txt` You will probably want to use that file again, using the `--answer-file` option, so that any passwords you have already set (for example, mysql) will be reused.

The installer will ask you to enter the root password for each host node you are installing on the network, to enable remote configuration of the host so it can remotely configure each node using Puppet.

Once the process is complete, you can log in to the OpenStack web interface Horizon by going to `http://$YOURIP/dashboard`. The user name is `admin`. The password can be found in the file `keystonerc_admin` in the `/root` directory of the control node.

# Next steps

Now that your single node OpenStack instance is up and running, you can read on about configuring a [floating IP range](/networking/floating-ip-range/), configuring RDO to [work with your existing network](/networking/neutron-with-existing-external-network/), or about expanding your installation by [adding a compute node](/install/adding-a-compute-node/).
