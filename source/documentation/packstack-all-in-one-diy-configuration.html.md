---
title: PackStack All-in-One DIY Configuration
category: documentation
authors: beagles, pixelbeat, psavage, rohara, tosky
wiki_category: Documentation
wiki_title: PackStack All-in-One DIY Configuration
wiki_revision_count: 24
wiki_last_updated: 2014-09-01
---

# PackStack All-in-One DIY Configuration

In progress.

If you are interested in getting into the details of how OpenStack Networking with Neutron works and do not mind "getting your hands dirty", configuring the network in an all-in-one Packstack deployment is a great way to get familiar with how it works. In this set of instructions for configuring a working all-in-one with a single private network, a single router with two test VM instances, each step is described as well as checkpoints advising how to verify each step in the logs as well as immediate side-effects in the system.

Upcoming updates to Packstack all-in-one will actually take of these steps for you in the future. When that day comes, you can either walk through these steps and create separate networks, etc. or you run Packstack without the "--all-in-one" option to pick the deployment options interactively.

## Initial Setup

If you have not already done so, run through the steps on the [Quickstart](Quickstart) page **EXCEPT** for the final step on that page: "**Step 3: Run Packstack to install OpenStack**". This currently describes configuring OpenStack with Nova Networking instead of Neutron, so you need to run it a little differently. However, before running packstack, one of our goals is to help illustrate the changes openstack makes to your system. Run the following commands and take note of the output before running packstack.

    rdotest:~> ifconfig
    rdotest:~> ip netns

If this is a relatively clean system that has never had OpenStack installed on it, you will probably see a few network devices for the first command. They will most likely have names like "eth0", "lo" or "p1p1". You may have a "virbr0" as well. In any case, there might be 4 or 5 interfaces displayed. If you like the short, tidyness of this output with all of the nice short names, assigned IP addresses, etc. and take comfort in that kind of thing: take a good last, fond look. If all goes well, this is the last time it will be like that. In contrast, ` ip netns ` probably displays nothing or an error.

Now, let's get on with it. Run packstack with Neutron enabled.

    packstack --allinone --os-quantum-install=y

or simply:

    packstack --allinone

It is recommended that you do **not** run Packstack as 'root', but from a regular user account. You will be prompted for the root account password when Packstack needs it. Packstack may have installed kernel updates so you might have to reboot! These updates are critical to the rest of the steps so you might as well go ahead and reboot. We'll wait for you at Step 1.

## Step 1. Verify and Modify Neutron Configuration

### Under the Hood: Network Namespaces

Network namespaces create new "virtual" network environments that are isolated from each other. Each network namespace has its own network devices, IP addresses, routing tables, ports, etc.. Neutron uses network namespaces to isolate network devices (including VIFs), DHCP and routing services for different networks and tenants. We will see some of the ways network namespaces are used by OpenStack as we go along.

Your version of Packstack may or may not have tweaked the configuration files. It is better to be safe and check them before proceeding. Since we are modifying configuration files, please be careful not to accidentally modify configuration. You will need root or sudo access to modify them. You could use your favorite text editor to modify the files, but we'll use the openstack-config tool for simplicity.

    openstack-config --set /etc/quantum/dhcp_agent.ini DEFAULT ovs_use_veth True
    openstack-config --set /etc/quantum/l3_agent.ini DEFAULT ovs_use_veth True

### Checkpoint: Other Namespace Related Configuration

Packstack more than likely has set the rest of the configuration variables required for namespaces, but if you want to see for yourself check the DEFAULT section in dhcp_agent.ini, for enable_isolated_metadata and use_namespaces, both of which should be True. You can also verify that the interface_driver is properly set as quantum.agent.linux.interface.OVSInterfaceDriver. In l3_agent.ini, check that use_namespaces is set to True and external_network_bridge is set to 'br-ex' and interface_driver is set as quantum.agent.linux.interface.OVSInterfaceDriver.

You need to restart the services to pick up the new settings so run:

    service quantum-dhcp-agent restart
    service quantum-l3-agent restart

### Checkpoint: Spot Check Service Health and Logs

Now is a good time to look for weird errors in your log files. Any of the logs in the /var/log/quantum directory are relevant, but the dhcp-agent.log, l3-agent.log, and openvswitch-agent.log files are directly relevant to this stage.

## Step 2. Configure the Router and External Network

Let's take a second and elaborate on this section's title. The "external network" maps pretty cleanly to Neutron jargon but it basically means the "public network" or "the network \*other\* than the one that connects your VMs together". The "router" is pretty much what it means in general network parlance: it sets up the mechanisms that route traffic to-and-from the "external network" and the VMs internal networks. Since it is helpful to map functionality to components, the quantum_l3_agent is the major player here. Of course since Open vSwitch is being used to "hook stuff up" the quantum-openvswitch-agent also is fundamental part.

While we are on the topic of Open vSwitch, let's run some commands and take note of the output as a baseline. Re-running these commands again and comparing with the baseline will help identify the changes OpenStack makes to the system for each step.

Running the Open vSwitch command line tool `ovs-vsctl` with the show command:

    rdotest:~>ovs-vsctl show

will display the two bridges created by the quantum-openvswitch-agent and quantum-l3-agent, br-int and br-ex.

        Bridge br-int
            Port br-int
                Interface br-int
                    type: internal
        Bridge br-ex
            Port br-ex
                Interface br-ex
                    type: internal
        ovs_version: "1.10.0"

Running the linux bridge control tool, `brctl` with the show command

    rdotest:~>brctl show

may or may not produce results depending on what is already configured on the host system (e.g. libvirt's default network). If there are pre-existing bridges, you may want to record the output to use as a baseline for comparison when examining the results of configuration steps in the future.

Running `ifconfig` again will reveal that there a few new interfaces, br-int and br-ex. These are the br-int and br-ex interfaces associated with the br-int and br-ex ports and bridges displayed in the results of `ovs-vsctl show` .

Unless an error occurred before, running `ip netns` will reveal the same results as before. If an error still occurs here, then either something went wrong with packstack or you didn't reboot when you should have.

Not much has happened so far, but we have not even really started step 2 yet. So let's get on with.

### Setup Your Environment

When working from the command line, setting some environment variables can make running the command line tools a lot more pleasant. Packstack created a file named "keystonerc_admin" in root's home directory (e.g. /root/keystonerc_admin) that contains the environment you need. To initialize your current environment, simply "source" the file:

    source /root/keystonerc_admin

If you are using bash or similar for your shell, your command prompt should have changed to something like `[root@rdotest ~(keystonerc_admin)]#`. Handy! Now you can run commands as the "admin" OpenStack user and tenant without having to specify it on the command line.

### Creating the External Network

There are actually two steps here: create the external network and create a subnet on that network. In Neutron, the notion of "network" and "subnet" are separated. The "network" is roughly analagous to a network "topology", i.e. the entire collection of entities on a network and how they are linked together. A "subnet" is a block of IP addresses and the things that normally go along with them, like addresses of gateways, whether the addresses are allocated over DHCP, routes, etc. and DNS servers, etc.. A single network can have multiple subnets, and each subnet can differ.

To create the network, run:

    quantum net-create extnet --router:external=True

You should see something like:

    +---------------------------+--------------------------------------+
    | Field                     | Value                                |
    +---------------------------+--------------------------------------+
    | admin_state_up            | True                                 |
    | id                        | 1c211b3b-dcf9-4731-8827-47d14d59e4ee |
    | name                      | extnet                               |
    | provider:network_type     | local                                |
    | provider:physical_network |                                      |
    | provider:segmentation_id  |                                      |
    | router:external           | True                                 |
    | shared                    | False                                |
    | status                    | ACTIVE                               |
    | subnets                   | c4e92c69-1621-4acc-9196-899e2989c1b1 |
    | tenant_id                 | fc7c56953d114e5db556b927b0268fb2     |
    +---------------------------+--------------------------------------+

## Step 3. Create a Tenant

    keystone tenant-create --name rdotest
    keystone user-create --name rdotest --tenant-id 1b45f7d3e99f49ebb764851457a0755b --pass rdotest --enabled true
    keystone user-role-list
    keystone user-role-add --name Member --tenant-id 1b45f7d3e99f49ebb764851457a0755b --user-id 1d6cc3e03e66484a847ba8b4a6e765f8
    keystone user-role-add --role Member --tenant 1b45f7d3e99f49ebb764851457a0755b --user 1d6cc3e03e66484a847ba8b4a6e765f8
    keystone user-role-list
    keystone user-role-list --tenant-id 1b45f7d3e99f49ebb764851457a0755b
    cp keystonerc_admin rdotest
    vim rdotest <- new env file for tenant
    source /root/rdotest

## Step 4. Create the Private Network

    source /root/rdotest
    quantum net-create rdonet
    quantum subnet-create rdonet 192.168.90.0/24
    ip netns

## Step 5. Create an Image

    source /root/keystonerc_admin 
    glance image-create --container-format=bare --disk-format=qcow2 --is-public=True --name=cirros < cirros-0.3.0-x86_64-disk.img 
    glance image-list

## Step 6. Create and Import SSH Key

## Step 7. Create Security Group Rules

## Step 8. Boot the VM

    source /root/rdotest 
    nova network-list
    nova boot --flavor 1 --image 26edf158-8c36-4627-9ce1-7a612065e5a9 gee
    nova list
    ip netns
    ifconfig
    brctl show
    ip netns exec qdhcp-51ccbe0f-11fd-4fbf-894a-ac1ee1809b75 iptables-save
    ip netns exec qdhcp-51ccbe0f-11fd-4fbf-894a-ac1ee1809b75 ifconfig

## Step 9. Allocate a Floating IP

    quantum port-list -- --device_id 2e108e64-2833-4915-8761-c9b2abac8fe8
    quantum floatingip-create extnet
    quantum floatingip-associate c8f42335-6832-477a-96d2-e817cb0e389c 2c1f85af-d798-49f6-863f-722b963cf271
    quantum floatingip-show c8f42335-6832-477a-96d2-e817cb0e389c
    ip netns exec qrouter-6e6f71df-cca2-4959-bdc5-ff97adf8fc8e ifconfig

## Step 10. Configure External Access

### NAT Trick

### Libvirt Network Trick

## Conclusion and Next Steps

== Stpe
