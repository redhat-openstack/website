---
title: Deploying RDO using Foreman
authors: cbrown ocf, cwolfe, dneary, jayg, jistr, matty dubs, merdoc, ohochman, rbowen,
  rob, rperryman, vaneldik
wiki_title: Deploying RDO using Foreman
wiki_revision_count: 47
wiki_last_updated: 2015-07-16
---

# Deploying RDO using Foreman

__NOTOC__

__TOC__

## Foreman with RDO

This guide is meant to help you set up [Foreman](http://theforeman.org/) to deploy RDO. We have wrapped this up in an installer with some predefined Foreman Host Groups to get you started. You can, of course, add your own to do thing we havenot yet added. If you do, please feel free to contribute them to our upstream [installer](https://github.com/redhat-openstack/astapor) project!

### Deploying on VMs

Before using Foreman to deploy OpenStack on your bare metal machines, you might want to do a test drive using virtual machines. We have some directions for that [here](Virtualized_Foreman_Dev_Setup).

### Initial setup

#### Repo setup

For RHEL systems, make sure you are registered to both rhel-6-server-rpms and the Optional channel:

    yum-config-manager --enable rhel-6-server-rpms
    yum-config-manager --enable rhel-6-server-optional-rpms

For all systems, you will also want the following two repositories:

    yum install http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
    yum install http://repos.fedorapeople.org/repos/openstack/openstack-havana/rdo-release-havana-7.noarch.rpm

These steps should be run on each system.

At this point, you will be ready to start installing your Foreman and OpenStack deployment.

### Foreman Non-Provisioning setup

Foreman supports *provisioning mode*, where nodes boot from a PXE server controlled by Foreman, and *non-provisioning mode*, which works with existing nodes.

#### Configure the Foreman server

First, let's configure the machine that will be our Foreman server.

Begin by installing openstack-foreman-installer:

    yum install openstack-foreman-installer

The following is an example environment file for non-provisioning mode. Obviously, you will change the IPs based on your own network setup. You may set this directly from the command line, or save it in a file and source it:

    export PRIVATE_CONTROLLER_IP=192.168.200.10
    export PRIVATE_INTERFACE=eth1
    export PRIVATE_NETMASK=192.168.200.0/24
    export PUBLIC_CONTROLLER_IP=192.168.201.10
    export PUBLIC_INTERFACE=eth2
    export PUBLIC_NETMASK=192.168.201.0/24
    export FOREMAN_GATEWAY=false
    export FOREMAN_PROVISIONING=false 

Check that `hostname --fqdn` returns an actual FQDN (i.e., it includes one or more dots, not just a hostname), and that `facter fqdn` is not blank. If it does not, see our dev setup page for some [troubleshooting help](Virtualized_Foreman_Dev_Setup#Hostname_and_FQDN).

You need to have a minimum of 3 networks/NICs set up on each of the machines meant to be openstack nodes. There will be one to communicate with the foreman server, one for the public openstack network, and one for the private openstack network. The Foreman server only needs to be on one network where it can communicate with the nodes.

Next:

    cd /usr/share/openstack-foreman-installer/bin/

initialize the environment settings described in the example above for non-provisioning mode.

    (sudo, if you are not root) sh foreman_server.sh

After a brief time, this will leave you with a working Foreman install. Further details are below in 'Finishing the setup', but first, go ahead and configure the clients:

#### Steps for controller/compute nodes

Next, you need to run `foreman_client.sh` on each client.

This is located in `/tmp` on the Foreman server. Copy this to each machine.

Once it is in place, run it on each machine:

    sh <path>/foreman_client.sh

If there is an error that the client did not get a signed certificate back from the puppet server, check on your Foreman server with:

    puppet cert list

And, if needed, puppet cert sign <client_fqdn>

You may receive this error during the installation:

    Error: Could not retrieve catalog from remote server: Error 400 on SERVER: Failed when searching for
    node set1client1: Failed to find set1client1  via exec: Execution of '/etc/puppet/node.rb set1client1'
    returned 1: --- false
    Warning: Not using cache on failed catalog
    Error: Could not retrieve catalog; skipping run

This is non-fatal and can be safely ignored.

### Finishing the setup

Assuming everything has been successful up to this point, now you just have a bit of configuration in the Foreman UI to configure the nodes you have registered with the desired host groups.

First, log in to your Foreman instance (https://{foreman_fqdn}). The default login and password are admin/changeme; we recommend changing this if you plan on keeping this host around.

Next, you’ll need to assign the correct puppet classes to each of your hosts. Click the 'Hosts' link and select your host from the list. Select 'Change Group' in the dropdown menu above the host list, select the appropriate Host Group, and Click 'submit'. When applying host groups, you can override any values (such as service passwords) in the Foreman UI. This can either be done on a per-host basis (by clicking the host link, and then clicking the 'edit host' button'), or at the Host Group level, which will affect all hosts assigned to that hostgroup. To have the change pick up immediately, run puppet on the host (client1 and client2 in our examples) in question (or just wait for the next puppet run, which defaults to every 30 minutes):

    puppet agent -tv

It is recommended that you provision the controller before the compute node, as the compute node has dependencies on the controller.

Repeat for all of your nodes. Both Controller and Compute nodes take quite a while to setup. After about <some number of> minutes on each host, you will have a working OpenStack installation! Add more Compute nodes at any time with Foreman.

#### Optional Heat APIs

By default, the controller node will install without CloudFormations and CloudWatch APIs enabled. To enable one or both of them:

*   In Foreman UI navigate to More -> Configuration -> Host Groups and click on the Controller host group (Neutron Controller or Nova Network Controller, depending on which one you use).

<!-- -->

*   Switch to the Parameters tab.

<!-- -->

*   Click the Override button next to `heat_cfn` and/or `heat_cloudwatch` parameters.

<!-- -->

*   Change the value(s) from "false" to "true" (you might need to scroll down if you don't see the form right away) and submit the form.

When Puppet runs on the controller node, it will install the optional APIs you enabled.

### Foreman Provisioning Setup

This is going to work largely the same as the non-provisioning mode, with the exception of changing the environment file we used earlier to configure the setup script a bit. For instance, you would enable the foreman gateway and set provisioning to true, as well as configure the appropriate eth\* devices on the foreman server to allow it to provision.

The Foreman server should have 2 interfaces for this configuration, one for external access and one that the clients will connect to. The clients are going to pxeboot off of the internal-only interface. Those clients are not going to have an OS on them, Foreman will do the actual provisioning. Simply start the client machines and have them PXE boot from the network they share with the foreman server.

### Troubleshooting with foreman/puppet

*   If you have mod_nss installed, foreman-proxy will not start, as they both attempt to use port 8443. This is something we will try to address in the near future, but in the meantime, you can easily edit your httpd conf file for either of these modules to get around this issue.
*   foreman-proxy restart is needed if you change certificates, or change Puppet versions (as it's loaded), or its settings file
*   httpd restart emcompasses both the puppetmaster and Foreman as they run inside with passenger, so it's a quick way to restart both.
*   Restart after changing certs (mod_ssl configuration), upgrading Puppet, changing Foreman's settings file and sometimes editing puppet.conf (especially if modifying environments).
*   you can restart just Foreman by touching ~foreman/tmp/restart.txt, or just 'service foreman restart'

For clients with puppet 2.6, you need to add to /etc/puppet/puppet.conf "report = true", and then 'puppet agent -tv' to get it to check in with foreman. Since we are using the puppet from puppetlabs (ie, 3,2,x), this is unlikely to be a problem if you are following the above directions.

### Using Hostgroups

This describes (and still needs more detail) how to use various host groups included by the installer. Where appropriate, these are broken out into their own pages, linked below. Thanks to gdubreuil for the initial work neutron integration and beginning neutron docs below.

All Host Groups can have their default values edited in the Foreman UI by going to 'More -> Configuration -> Host Groups'. Do verify these settings are as desired before proceeding to configure any client machines via Foreman.

#### 2 Node install with Nova Networking

*   First, verify the settings for the 'Openstack Controller' and 'Openstack Nova Compute' hostgroups are correct, especially the public and private openstack network IPs/ranges.
*   Select the Host (checkbox) from the list on the 'Hosts' tab of Foreman UI that you wish to configure as your controller.
*   From the Dropdown menu directly above the table, select 'Change Group', and pick 'Openstack Controller', then 'Submit'
*   Next, either wait for that machine to check in via puppet, or kick off a put run the using 'puppet agent -tv'
*   Once that has completed successfully, make sure you can get to Horizon on the new controller node. Your password, unless you changed it for this host, is the admin_password on the paramters tab of the host group. You can also check cli services for the controller using standard openstack commands. All passwords and environment variables you need to set to do so can be found in this same Parameters tab. As an example, you could create a .keystonerc like so:

<!-- -->

    export OS_USERNAME=admin 
    export OS_TENANT_NAME=admin
    export OS_PASSWORD=<admin_password>
    export OS_AUTH_URL=http://<controller_ip>:35357/v2.0/

Then you can source it and do a 'nova service-list'. This should show most services running, modulo compute, since you didnt set that up yet.

*   Assuming that went well, your next step woudl be to do the assignment of a host groupt to your node, this time choosing 'Openstack Nova Compute'. Once that finishes, if you run the service-list command again from your controller, you shoudl see the newly added compute node running.

#### Neutron with Networker Node

##### Notes

*   This is for GRE Tunnel only (for now)
*   Minimum 3 hosts - 4 are needed for full validation (VMs communication across compute hosts)

##### Prerequisites

*   rhel6.4+ core build
*   rhel + rhel optional + rdo havana + epel6
*   2 x physical networks: 1 private, 1 public. (Assuming consistent network interface name across hosts.)
*   1 x Controller
*   1 x Networker
    -   Network node needs to have br-ex setup:
        -   scp /usr/share/openstack-foreman-installer/bin/bridge-create.sh from Foreman node to Network node and run these commands on the Network node:
        -   \`yum install openvswitch\`
        -   \`service openvswitch start\`
        -   \`bridge-create.sh br-ex eth0\` (assuming eth0 is your public interface)
*   N x Computer(s)

##### Setup

Set quickstack/params.pp values (directly or though foreman globals/hostgroups/smart variables).

Assign hosts to their respective target Quickstack Puppet module classes (hostgroups): Controller -> neutron_controller.pp Networker -> neutron_network.pp Computer -> neutron_compute.pp

#### Cinder Storage Nodes

The controller node contains Cinder API and scheduler. For deploying storage capacity nodes there is "OpenStack Block Storage" hostgroup.

The nodes assigned to the "OpenStack Block Storage" hostgroup need to have a `cinder-volumes` LVM volume group before you run puppet on them. This should be considered before you install operating system on the node and you should partition your disk if needed. (LVM volume group needs to be backed by at least one physical volume, which means you'll need to dedicate at least one disk partition to it.) You might use Kickstart to partition the disk and set up the LVM volume group automatically during OS installation.

For more information regarding LVM setup see [LVM Administration Guide](https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html-single/Logical_Volume_Manager_Administration/index.html) and [Kickstart docs](http://fedoraproject.org/wiki/Anaconda/Kickstart).

##### Quick volume group creation for testing

If you just want to give Cinder a quick try, there is a script that sets up a `cinder-volumes` volume group backed by a loop file. This means you will not have to do any special partitioning and the data will be saved in file `/var/lib/cinder/cinder-volumes`. You'll find the script on the node where you installed Foreman at `/usr/share/openstack-foreman-installer/bin/cinder-testing-volume.sh`. Steps to use the script:

1. SCP `cinder-testing-volume.sh` script from the Foreman node to nodes that you want to use for block storage.

2. Run `bash cinder-testing-volume.sh 5G` on the storage nodes. The parameter is the desired size of loop file to be created (5 gigabytes in the example).

Note that `cinder-testing-volume.sh` script is meant for testing only, and the volume group will not persist between reboots. In production environment Cinder storage should be always backed by disks or disk partitions, not by loop files.
