---
title: GettingStartedHavana w GRE
authors: anandts, chenshake, larsks, radez
wiki_title: GettingStartedHavana w GRE
wiki_revision_count: 20
wiki_last_updated: 2014-01-10
---

# GettingStartedHavana w GRE

## Purpose

This document is written to prepare participants at the OpenStack Summit in Hong Kong for the hand on section of the [Getting Started with Openstack](http://openstacksummitnovember2013.sched.org/event/e08eb32425f2031003dcbc36c3b177bf) session. During the session the installation environment will be assumed. Installation will be demonstrated, though, a pre-installed cluster may be used for the hands on demonstration. To follow along with the setup and use demonstration both the Installation Environment and the Installation sections should be completed.

These installation steps are general purpose and can be used by anyone who would like to setup a multi-node havana openstack cluster using GRE tunnels.

## Installation Environment

To do this installation two virtual machines running a RedHat based install of linux are needed, RHEL, Fedora, CentOS, Scientific are a few options to meet this requirement. The workshop at Summit will use Fedora 19
* Each VM should have 2 network interfaces each configured with static IP addresses. For this installation eth0 will be "public traffic" and eth1 will be "private traffic". The following IP addresses will be used:
-- control host eth0 192.168.122.2, eth1 192.168.123.2
-- compute host eth0 192.168.122.3, eth1 192.168.123.3
 Each visualization environment is different. [NeutronLibvirtMultinodeDevEnvironment](NeutronLibvirtMultinodeDevEnvironment) shows an example of how to setup these two hosts using libvirt.

Ensure NetworkManager and firewalld are disabled. You may also have to set selinux to permissive, there has been a dhcp-agent bug that selinux had to be disabled because of.

## Installation

The multi-node installation follows [QuickStartLatest](QuickStartLatest) for the most part. The main difference is how packstack is invoked. Run the commands for installation on the control node.

### Yum Repo Setup

Start by installing the RDO Havanaa Yum Repo:

    sudo yum install -y http://rdo.fedorapeople.org/openstack-havana/rdo-release-havana.rpm

### Packstack OpenStack Installer

Next install the Packstack OpenStack Installer:

    sudo yum install openstack-packstack

Generate an answer file. It will be altered to include the GRE configuration before installation is started:

    packstack --gen-answer-file my_answers.txt

### Configuration and Installation

Edit the packstack answerfile and update the following configuration parameters. Leave all other parameters just as they are, only the lines listed should be changed.

    CONFIG_SWIFT_INSTALL=y
    CONFIG_NOVA_COMPUTE_HOSTS=192.168.123.3
    CONFIG_NEUTRON_OVS_TENANT_NETWORK_TYPE=gre
    CONFIG_NEUTRON_OVS_TUNNEL_RANGES=1:1000
    CONFIG_NEUTRON_OVS_TUNNEL_IF=eth1

Packstack will pre-populate the ip addresses and network interfaces based on the system you are installing from. If you are using a previously generated answers file on a new system you may need to update the ip addresses and network interface names.

Note that the interface identified in \`CONFIG_NEUTRON_OVS_TUNNEL_IF\` must be configured with an ip address prior to running packstack. You will need to create the appropriate interface configuration file (in this example, `/etc/sysconfig/network-scripts/ifcfg-eth1`) and run `ifup eth1` before running packstack.

Save and close the answer file and feed it into packstack to start the installation.

    sudo packstack --answer-file my_answers.txt

The install takes at least 10 minutes, more depending on your network connection and computer resources. When it completes you will have a basic OpenStack Install ready to be populated with users, images, networks, storage and more.

### Next Steps

Come to the session for a hands on demonstration of what to do next with the freshly installed OpenStack Cluster.
 [Getting Started with Openstack](http://openstacksummitnovember2013.sched.org/event/e08eb32425f2031003dcbc36c3b177bf)
