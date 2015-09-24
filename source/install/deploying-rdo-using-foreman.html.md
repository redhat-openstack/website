---
title: Deploying RDO using Foreman
authors: cbrown ocf, cwolfe, dneary, jayg, jistr, matty dubs, merdoc, ohochman, rbowen,
  rob, rperryman, vaneldik
wiki_title: Deploying RDO using Foreman
wiki_revision_count: 47
wiki_last_updated: 2015-07-16
---

# Deploying RDO using Foreman

This guide is meant to help you set up [Foreman](http://theforeman.org/) to deploy RDO. We have wrapped this up in an installer with some predefined Foreman Host Groups to get you started. You can, of course, add your own to do thing we havenot yet added. If you do, please feel free to contribute them to our upstream [installer](https://github.com/redhat-openstack/astapor) project!

## Deploying on VMs

Before using Foreman to deploy OpenStack on your bare metal machines, you might want to do a test drive using virtual machines. We have some directions for that [here](Virtualized_Foreman_Dev_Setup).

## Initial setup

### Operating Systems

Please check Foreman's web site for support Operating System; [1](http://www.theforeman.org/manuals/1.4/quickstart_guide.html)

### Repo setup

For RHEL systems, make sure you are registered to both rhel-6-server-rpms and the Optional channel:

    yum-config-manager --enable rhel-6-server-rpms
    yum-config-manager --enable rhel-6-server-optional-rpms

For all systems, you will also want the following two repositories:

    yum install http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
    yum install http://repos.fedorapeople.org/repos/openstack/openstack-havana/rdo-release-havana-7.noarch.rpm

These steps should be run on each system.

At this point, you will be ready to start installing your Foreman and OpenStack deployment.

## Foreman Non-Provisioning setup

Foreman supports *provisioning mode*, where nodes boot from a PXE server controlled by Foreman, and *non-provisioning mode*, which works with existing nodes.

### Configure the Foreman server

First, let's configure the machine that will be our Foreman server.

Begin by installing openstack-foreman-installer:

    yum install openstack-foreman-installer

The following is an example environment file for non-provisioning mode:

    export FOREMAN_GATEWAY=false # The Gateway set up for foreman provisioning (or 'false' when no provisioning)
    export FOREMAN_PROVISIONING=false # Will foreman be used for provisioning?

Check that `hostname --fqdn` returns an actual FQDN (i.e., it includes one or more dots, not just a hostname), and that `facter fqdn` is not blank. If it does not, see our dev setup page for some [troubleshooting help](Virtualized_Foreman_Dev_Setup#Hostname_and_FQDN).

We recommend a minimum of 3 networks/NICs set up on each of the machines meant to be openstack nodes. There will be one to communicate with the foreman server, one for the public openstack network, and one for the private openstack network. The Foreman server only needs to be on one network where it can communicate with the nodes. If needed, for PoC testing, you could collapse the public/private openstack networks into one.

Next:

    cd /usr/share/openstack-foreman-installer/bin/

initialize the environment settings described in the example above for non-provisioning mode.

    (sudo, if you are not root) sh foreman_server.sh

After a brief time, this will leave you with a working Foreman install. Before moving forward you need to open the right ports. I use lokkit: lokkit --service http lokkit --service https lokkit --service dns lokkit --service tftp lokkit --port 8140:tcp

       Further details are below in 'Finishing the setup', but first, go ahead and configure the clients:

### Steps for controller/compute nodes

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

## Finishing the setup

Assuming everything has been successful up to this point, now you just have a bit of configuration in the Foreman UI to configure the nodes you have registered with the desired host groups.

First, log in to your Foreman instance (https://{foreman_fqdn}). The default login and password are admin/changeme; we recommend changing this if you plan on keeping this host around.

Next, you’ll need to assign the correct puppet classes to each of your hosts. Click the 'Hosts' link and select your host from the list. Select 'Change Group' in the dropdown menu above the host list, select the appropriate Host Group, and Click 'submit'. When applying host groups, you should override any values (such as service passwords and service ip addresses) in the Foreman UI. This can either be done on a per-host basis (by clicking the host link, and then clicking the 'edit host' button'), or at the Host Group level, which will affect all hosts assigned to that hostgroup. To have the change pick up immediately, run puppet on the host (client1 and client2 in our examples) in question (or just wait for the next puppet run, which defaults to every 30 minutes):

    puppet agent -tv

It is recommended that you provision the controller before the compute node, as the compute node has dependencies on the controller.

Repeat for all of your nodes. Both Controller and Compute nodes take quite a while to setup. After about <some number of> minutes on each host, you will have a working OpenStack installation! Add more Compute nodes at any time with Foreman.

### Optional Heat APIs

By default, the controller node will install without CloudFormations and CloudWatch APIs enabled. To enable one or both of them:

*   In Foreman UI navigate to More -> Configuration -> Host Groups and click on the Controller host group (Neutron Controller or Nova Network Controller, depending on which one you use).

<!-- -->

*   Switch to the Parameters tab.

<!-- -->

*   Click the Override button next to `heat_cfn` and/or `heat_cloudwatch` parameters.

<!-- -->

*   Change the value(s) from "false" to "true" (you might need to scroll down if you don't see the form right away) and submit the form.

When Puppet runs on the controller node, it will install the optional APIs you enabled.

## Foreman Provisioning Setup

This is going to work largely the same as the non-provisioning mode, with the exception of changing the environment file we used earlier to configure the setup script a bit. For instance, you would enable the foreman gateway and set provisioning to true, as well as configure the appropriate eth\* devices on the foreman server to allow it to provision. Eg:

    export FOREMAN_GATEWAY=10.0.0.1
    export FOREMAN_PROVISIONING=true
    export PROVISIONING_INTERFACE=eth0

The Foreman server should have 2 interfaces for this configuration, one for external access and one that the clients will connect to. The clients are going to pxeboot off of the internal-only interface. Those clients are not going to have an OS on them, Foreman will do the actual provisioning. Simply start the client machines and have them PXE boot from the network they share with the foreman server.

## Troubleshooting with foreman/puppet

*   If are see errors in a host report in the foreman dashboard like 'could not connect to MySQL on 172.16.0.1' it's likely because you have not over rode the default values to match your environment. you can specify overrides in the foreman UI. (Dashboard home >> more >> host groups >> *group name* >> parameters - click 'override' on each vale you want to specify and scroll to the end of the page to fill in the new parameters) -see below 'using host groups'
*   If you have mod_nss installed, foreman-proxy will not start, as they both attempt to use port 8443. This is something we will try to address in the near future, but in the meantime, you can easily edit your httpd conf file for either of these modules to get around this issue.
*   foreman-proxy restart is needed if you change certificates, or change Puppet versions (as it's loaded), or its settings file
*   httpd restart emcompasses both the puppetmaster and Foreman as they run inside with passenger, so it's a quick way to restart both.
*   Restart after changing certs (mod_ssl configuration), upgrading Puppet, changing Foreman's settings file and sometimes editing puppet.conf (especially if modifying environments).
*   you can restart just Foreman by touching ~foreman/tmp/restart.txt, or just 'service foreman restart'

For clients with puppet 2.6, you need to add to /etc/puppet/puppet.conf "report = true", and then 'puppet agent -tv' to get it to check in with foreman. Since we are using the puppet from puppetlabs (ie, 3,2,x), this is unlikely to be a problem if you are following the above directions.

## Using Hostgroups

This describes (and still needs more detail) how to use various host groups included by the installer. Where appropriate, these are broken out into their own pages, linked below. Thanks to gdubreuil for the initial work neutron integration and beginning neutron docs below.

All Host Groups can have their default values edited in the Foreman UI by going to 'More -> Configuration -> Host Groups'. Do verify these settings are as desired before proceeding to configure any client machines via Foreman.

### 2 Node install with Nova Networking

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

*   Assuming that went well, your next step would be to do the assignment of a host group to your node, this time choosing 'Openstack Nova Compute'. Once that finishes, if you run the service-list command again from your controller, you should see the newly added compute node running.

### Neutron with Networker Node

#### Notes

*   This document needs major update, and a lot more detail.
*   This is for GRE Tunnel only (for now)
*   Minimum 3 hosts - 4 are needed for full validation (VMs communication across compute hosts)
*   Further doc located [here](Configuring_Neutron_with_OVS_and_GRE_Tunnels_using_quickstack). Note this is also desperately in need of some updates.

#### Prerequisites

*   rhel6.5+ core build
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

#### Setup

Set quickstack/params.pp values (directly or though foreman globals/hostgroups/smart variables).

Assign hosts to their respective target Quickstack Puppet module classes (hostgroups): Controller -> neutron_controller.pp Networker -> neutron_network.pp Computer -> neutron_compute.pp

### Cinder Storage Nodes

The controller node contains Cinder API and scheduler. For deploying storage capacity nodes there is "OpenStack Block Storage" hostgroup.

The nodes assigned to the "OpenStack Block Storage" hostgroup need to have a `cinder-volumes` LVM volume group before you run puppet on them. This should be considered before you install operating system on the node and you should partition your disk if needed. (LVM volume group needs to be backed by at least one physical volume, which means you'll need to dedicate at least one disk partition to it.) You might use Kickstart to partition the disk and set up the LVM volume group automatically during OS installation.

{:.alert.alert-info}
For more information regarding LVM setup see [LVM Administration Guide](https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html-single/Logical_Volume_Manager_Administration/index.html) and [Kickstart docs](http://fedoraproject.org/wiki/Anaconda/Kickstart).

#### Quick volume group creation for testing

If you just want to give Cinder a quick try, there is a script that sets up a `cinder-volumes` volume group backed by a loop file. This means you will not have to do any special partitioning and the data will be saved in file `/var/lib/cinder/cinder-volumes`. You'll find the script on the node where you installed Foreman at `/usr/share/openstack-foreman-installer/bin/cinder-testing-volume.sh`. Steps to use the script:

1. SCP `cinder-testing-volume.sh` script from the Foreman node to nodes that you want to use for block storage.

2. Run `bash cinder-testing-volume.sh 5G` on the storage nodes. The parameter is the desired size of loop file to be created (5 gigabytes in the example).

{:.alert.alert-warning}
Note that `cinder-testing-volume.sh` script is meant for testing only, and the volume group will not persist between reboots. In production environment Cinder storage should be always backed by disks or disk partitions, not by loop files.

You can also manually create you Volume Groups, example here:

    # local partition (requires an unused disk or partition)
        pvcreate -yv -ff /dev/sdb
            vgcreate cinder-volumes /dev/sdb

    # iSCSI target (requires an initiator and target)
        iscsiadm -m discovery -t st -p 172.31.143.200
            iscsiadm -m node -l
            partprobe -s
            pvcreate -yv -ff /dev/sdb
            vgcreate cinder-volumes /dev/sdb

    # loopback device (poc only, requires free space)
        truncate --size 5G /root/cinder-volumes
            losetup -fv /root/cinder-volumes

### Load Balancer

Note that the Load Balancer itself is not yet HA, but will be part or a Pacemaker cluster group in the near future.

1.  Install a controller node.
2.  Install a load-balancer node (ie. add a host to this host group). The needed parameters to be set in foreman are:
    -   **lb_private_vip** Supply the internal (private) VIP address.
    -   **lb_public_vip** Supply the external (public) VIP address.
    -   **lb_member_names** and **lb_member_addrs** Supply a name and internal IP address of each controller. The name is actually arbitrary, but haproxy requires a name for each real server (in this case each controller). These are comma-separated strings.

3.  Edit your controller Host Group.
    -   Change the **controller_public_floating_ip** and **controller_private_floating_ip** parameters. These need to be the public and private VIP that the load-balancer is listening on.
    -   Set the **mysql_host** and **qpid_host** params in the controller(s) appropriately. Each controller should have same values here. In the simple case, you merely point all controllers to use the database or qpid setup installed on a single one of your load balanced controllers. More likely, you will point these at your HA Mysql cluster (see host group below), and HA qpid cluster (coming soon). In the latter case, you would use the Virtual IP managed by Pacemaker for the relevant clusters as the value for these parameters.

4.  Add more controllers nodes to your deployment. There are some certificates you need to copy over from the first deployed controller:

       /etc/keystone/ssl/certs/ca.pem
       /etc/keystone/ssl/certs/signing_cert.pem
       /etc/keystone/ssl/private/signing_key.pem

If you know that you want to load balance your Controllers from the beginning, you could also set the correct **controller_public_floating_ip** and **controller_private_floating_ip** on your controller host group before deploying either the controllers or a load balancer (assuming you know the address of the load balancer at this time).

### Swift Storage

The **Swift Storage Host Group** may be used to configure your Swift storage nodes. Note that this applies to the Swift back-end nodes only, not the Swift Proxy which is included in the Controller (Nova Network or Neutron) Host Group.

#### Swift Storage Host Group Parameters

***swift_all_ips*** An array of ip addresses. It must include all the IP's in your Swift Storage Host Group as well as the Swift Proxy IP(s). This ensures the relevant firewall rules are in place.

***swift_ext4_device*** The ext4 device where blobs are actually stored. There must be an ext4 filesystem already present on the device.

***swift_local_interface*** The interface used for swift network traffic. This is assumed to have an IP address.

***swift_loopback*** Set to "true" or "false" which indicates whether to use loopback device instead of an ext4 device. The parameter swift_ext4_device becomes irrelevant if swift_loopback is true. Using a loopback device is primarily useful for testing.

***swift_ring_server*** The IP address of the swift ring server which is typically the swift proxy/controller node.

***swift_shared_secret*** A random hashing string that must be consistent across Swift nodes.

### HA Database Cluster

This sets up up a cluster for (currently) mysql via pacemaker, details [here](Foreman_HA_Database).

### SSL Configuration

Currently, mysql, qpid and horizon, have support for securing via ssl in foreman, directions [here](Securing_Services_Foreman).
