---
title: Deploying RDO on a Baremetal Environment using Instack
authors: ccrouch, rbrady, rlandy, slagle
wiki_title: Deploying RDO on a Baremetal Environment using Instack
wiki_revision_count: 98
wiki_last_updated: 2014-10-28
---

# Deploying RDO on a Baremetal Environment using Instack

[← Deploying RDO using Instack](/install/deploying-rdo-using-instack/)

## Minimum System Requirements

In order to produce a usable OpenStack install this setup requires five baremetal machines: one machine for the undercloud, and one machine for each of the overcloud controller, compute, block storage and object storage nodes. However, the setup can be scaled down to run on just three machines and include only the undercloud, overcloud controller and overcloud compute nodes. Similarly, the overcloud nodes can be scaled up to include multiple compute, object storage or block storage nodes.

![](instackSetup.png "instackSetup.png")

The setup requires baremetal machines with the following minimum specifications:

*   multi-core CPU
*   4GB memory
*   60GB free disk space

The undercloud machine needs to run Fedora 20 x86_64, which is discussed more below.

## Preparing the Baremetal Environment

### Networking

The overcloud nodes will be deployed from the undercloud machine and therefore the machines need to have have their network settings modified to allow for the overcloud nodes to be PXE boot'ed using the undercloud machine. As such, the setup requires that:

*   all overcloud machines in the setup must support IPMI

<!-- -->

*   a management provisioning network is setup for all of the overcloud machines. One NIC from every machine needs to be in the same broadcast domain of the provisioning network. In the tested environment, this required setting up a new VLAN on the switch. Note that you should use the same NIC on each of the overcloud machines ( for example: use the second NIC on each overcloud machine). This is because during installation we will need to refer to that NIC using a single name across all overcloud machines e.g. em2

<!-- -->

*   the provisioning network NIC should not be the same NIC that you are using for remote connectivity to the undercloud machine. During the undercloud installation, a openvswitch bridge will be created for Neutron and the provisioning NIC will be bridged to the openvswitch bridge. As such, connectivity would be lost if the provisioning NIC was also used for remote connectivity to the undercloud machine.

<!-- -->

*   the overcloud machines can PXE boot off the NIC that is on the private VLAN. In the tested environment, this required disabling network booting in the BIOS for all NICs other than the one we wanted to boot and then ensuring that the chosen NIC is at the top of the boot order (ahead of the local hard disk drive and CD/DVD drives).

<!-- -->

*   For each overcloud machine you have:
    -   the MAC address of the NIC that will PXE boot on the provisioning network
    -   the IPMI information for the machine (i.e. IP address of the IPMI NIC, IPMI username and password)

<!-- -->

*   Refer to the following diagram for more information

![](TripleO_Network_Diagram_.jpg "TripleO_Network_Diagram_.jpg")

### Setting Up the Undercloud Machine

1.  Select a machine within the baremetal environment on which to install the undercloud.
2.  Install [Fedora 20 x86_64](https://fedoraproject.org/en/get-fedora) on this machine. (Instack installs have been tested on Fedora 20 x86_64 only.)
3.  Add a user account and configure this user to have passwordless sudo access. This user will execute the steps for installation and deployment. The following example should be executed by the `root` user. It adds the user "stack".
        useradd stack
        passwd stack # specify a password
        echo "stack        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/stack
        chmod 0440 /etc/sudoers.d/stack

You're ready to move onto [Deploying an RDO Undercloud with Instack](/install/deploying-an-rdo-undercloud-with-instack/).
