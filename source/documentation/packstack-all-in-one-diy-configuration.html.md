---
title: PackStack All-in-One DIY Configuration
category: documentation
authors: beagles, pixelbeat, psavage, rohara, tosky
wiki_category: Documentation
wiki_title: PackStack All-in-One DIY Configuration
wiki_revision_count: 24
wiki_last_updated: 2014-09-01
layout: toc
---
# PackStack All-in-One DIY Configuration

If you are interested in getting into the details of how OpenStack Networking with Neutron works and do not mind "getting your hands dirty", configuring the network in an all-in-one Packstack deployment is a great way to get familiar with how it works. In this set of instructions for configuring a working all-in-one with a single private network, a single router with two test VM instances, each step is described as well as checkpoints advising how to verify each step in the logs as well as immediate side-effects in the system.

1. toc
{:toc}

Some preamble before we begin:

### Quantum vs. Neutron

Neutron is simply the component-formerly-known-as-Quantum. While the commands and configuration files refer to Quantum, the documentation refers to Neutron. The name transition in software will be complete in the upcoming Havana release.

### What is "all in one" for?

Not everyone has a development or testing lab that they have control of for "proof-of-concept" evaluation, demos or simple curiousity. Packstack's "allinone" option installs and configures a single fully-loaded standalone OpenStack deployment. The term *standalone* is actually pretty significant here as everything is configured to run on a system that has only one network interface. That effectively puts multiple compute nodes, fault-tolerant dhcp servers, access to physical provider networks, etc. and a lot of other goodies that people equate with cloud computing outside of the scope of the all-in-one configuration. If setting up this sort of deployment is your ultimate goal, you will not get *directly* there by running through the operations described here. The information **is** relevant to all types of deployments, so if you are new to Neutron and are planning something more complex than an "all-in-one" there is still value in going through this document. Keep in mind though that some key details relevant to more practical real-world deployments are omitted.

### Conventions

#### OpenStack Commands

Running OpenStack commands are described in three parts:

*   A reference line prefixed with a '#' provides the general form of the command. Parameters that are variable relative to the discussion are enclosed in square brackets whereas required parameter values are unadorned. Feel free to use values different than the ones used in the examples, but remember to keep track of them. Keep an eye out for slip-ups where we may have forgotten to put square brackets around something too! If there are no optional arguments at all, the reference line is omitted.
*   An example line.
*   Example output.

**packstack** is the exception to this convention. The general form of the command is not relevant and the volume of output is quite large.

#### Non-OpenStack Commands

Regular system commands are typically described in one or, if the output is relevant, two parts:

*   The command with options values consistent with the context of this document.
*   Example output.

#### Checkpoints

Some steps include one or more sets of suggestions for optional steps aimed at verifying the health of the system and success of the steps just completed. Trying these steps will increase your knowledge of the system, your ability to detect and analyze issues and provide a convenient point of reference if something **has** gone wrong and you seek assistance on the mailing list or IRC. Checkpoints are subsections with titles that begin with "Checkpoint" and have body text with slightly different formatting. For example.

#### Checkpoint: OpenStack Guru Health Check

<div style="background-color:#e0e0f0; padding-left:2em;padding-right:2em;padding-top:5px;padding-bottom:5px;">
Visually confirm your pants are not on fire. Evident combustion indicates a time critical condition. Due to potential time zone variability and general apathy of core developers and PTLs, seeking assistance on the mailing lists or IRC is not recommended. Suggested courses of action include: immediate immersion in a NON-flammable fluid; or immediate cessation of forward locomotion, adoption of a prone position followed by vigorous twisting of the body on a NON-flammable surface. Vocalizations including expletives, entreaties for immediate assistance from nearby entities corporeal or otherwise, or long strings of vowels are recommended, but optional.

</div>

### General Pro-tips

If you have available screen real estate, you may want to tail the log files in the /var/log/quantum directory after you have run packstack, possibly piping through grep with 'ERROR' as a search string. If you are log file hound, you might try keeping track of the time before running steps to help identify "before" and "after" when analyzing the files. If you are really into keeping track of what you have done, try running `screen` and logging (C-a H)everything you are entering and seeing. Combined with running `date` at key points, it is hard to get a better record of forensics. You might want to be careful to use that \*only\* for running the commands and small operations like examining the state of Open vSwitch, the interfaces, etc.

*Talk about wishing you followed your own advice: screen/logging would have the command line/result aspect of this document a lot easier to write!*

### Before Starting

* some words of encouragement! Not many people would argue that configuring Neutron the first time is intuitive or easy. However, the OpenStack community has endeavored to produce tools for software defined networking (SDN) that do not add unnecessary complexity. That being said, SDN \*is\* meant to tackle difficult problems and, like any tool that can handle an enormous variety of problems, SDN solutions often seem more complex than what is necessary for a simple single network deployment. If you run packstack and try to piece together instructions to setup a working network from the information available on the Internet and end up feeling that everything is magic and shrouded in mystery, you are not alone. If you are familiar with Nova Networking, the precursor to Quantum/Neutron, and you have tried and failed to get a Neutron network up and running, you may even be of the opinion that it is broken. At this point, you are probably wondering where those "words of encouragement" are... well, here they are: once you see what Neutron does and someone dispells some of the mystery for you, managing networks with Neutron is going to be \*easy\*. Furthermore, as you progress to creating more complicated network topologies, the abstractions that Neutron gives you to work with will readily map to the problem domain and feel quite natural. Follow up guides that describe deploying multiple compute nodes and experimenting with weird network integration trick should convince you that this learning curve is well worth it.

## Initial Setup

If you have not already done so, run through the steps on the [Quickstart](Quickstart) page **EXCEPT** for the final step on that page: "**Step 3: Run Packstack to install OpenStack**". This currently describes configuring OpenStack with Nova Networking instead of Neutron, so you need to run it a little differently. However, before running packstack, one of our goals is to help illustrate the changes openstack makes to your system. Run the following commands and take note of the output before running packstack.

    ifconfig
    ip netns

If this is a relatively clean system that has never had OpenStack installed on it, you will probably see a few network devices for the first command. They will most likely have names like "eth0", "lo" or "p1p1". You may have a "virbr0" as well. In any case, there might be 4 or 5 interfaces displayed. If you like the short, tidyness of this output with all of the nice short names, assigned IP addresses, etc. and take comfort in that kind of thing: take a good last, fond look. If all goes well, this is the last time it will be like that. In contrast, ` ip netns ` probably displays nothing or an error.

Now, let's setup our baseline OpenStack install with Neutron enabled.

    packstack --allinone --os-quantum-install=y --provision-demo=n --provision-all-in-one-ovs-bridge=n

The

    --provision-demo=n

and

    --provision-all-in-one-ovs-bridge=n

options disable the default behavior of setting up the test networks when Neutron is selected. If packstack complains that these options aren't supported, then you have a version of packstack that does not include this functionality and you can skip these command line options.

It is recommended that you run Packstack from a regular user account and not as 'root'. You will be prompted for the root account password when Packstack needs it. The installation may take awhile. Once completed, Packstack may have installed kernel updates requiring a reboot. These updates are critical so it is best that you do not skip the reboot step. It's okay, we'll wait for you at Step 1.

    reboot

## Step 1. Verify and Modify Neutron Configuration

### Checkpoint: Check Service Health and Logs

<div style="background-color:#e0e0f0; padding-left:2em;padding-right:2em;padding-top:5px;padding-bottom:5px;">
Using your favorite method, make sure that the l3 and dhcp agents are still running after rebooting. Now is a good time to look for unusual errors in your log files. Any of the the log files in the /var/log/quantum directory are relevant, but the dhcp-agent.log, l3-agent.log, and openvswitch-agent.log files are directly relevant to this stage. `grep -i error *.log` works well, but be mindful of the timestamps. Errors that were logged before starting these steps are not necessarily relevant.

</div>
Network namespaces create new "virtual" network environments that are isolated from each other. Each network namespace has its own network devices, IP addresses, routing tables, ports, etc.. Neutron uses network namespaces to isolate network devices (including VIFs), DHCP and routing services for different networks and tenants. Neutron also uses something called a *veth pair*. A veth pair is two ethernet interfaces connected back-to-back and simplifies connecting things together that cannot be connected directly. We examine how veth pairs and namespaces are used we make our way through the steps. For now it is important to verify that Neutron was configured to enable these features. Your version of Packstack may or may not have modified the configuration files properly. It is better to be safe and check them before proceeding. Since we are modifying configuration files, please be careful not to accidentally modify configuration. You will need root or sudo access to modify them. You could use your favorite text editor to modify the files, but we'll use the openstack-config tool for simplicity.

    # crudini --set [config file name] [config file section] [config variable name] [value]
    crudini --set /etc/quantum/dhcp_agent.ini DEFAULT ovs_use_veth True
    crudini --set /etc/quantum/l3_agent.ini DEFAULT ovs_use_veth True

The ovs_use_veth settings are primarily required to workaround some issues with the OpenStack RHEL kernel. If you are using recent versions of Fedora, you may not need to changes these settings.

### Checkpoint: Other Namespace Related Configuration

<div style="background-color:#e0e0f0; padding-left:2em;padding-right:2em;padding-top:5px;padding-bottom:5px;">
Packstack should have configured the other namespace related variables, but if you want to see for yourself check the `DEFAULT` section in both the `dhcp_agent.ini` and the `l3_agent.ini` configuration files.
In `dhcp_agent.ini`, check for the following settings:

      enable_isolated_metadata = True
      use_namespaces = True
      interface_driver =quantum.agent.linux.interface.OVSInterfaceDriver

In `l3_agent.ini`, check the following settings:

      use_namespaces = True
      external_network_bridge = br-ex
      interface_driver = quantum.agent.linux.interface.OVSInterfaceDriver

</div>

You need to restart the services to pick up the new settings so run:

    service quantum-dhcp-agent restart
    Stopping quantum-dhcp-agent:                               [  OK  ]
    Starting quantum-dhcp-agent:                               [  OK  ]

    service quantum-l3-agent restart
    Stopping quantum-l3-agent:                                 [  OK  ]
    Starting quantum-l3-agent:                                 [  OK  ]

### Checkpoint: Check Service Health and Logs

<div style="background-color:#e0e0f0; padding-left:2em;padding-right:2em;padding-top:5px;padding-bottom:5px;">
Using your favorite method, make sure that the L3 and dhcp agents are still running after restarting. Now is a good time to look for unusual errors in your log files. Any of the the log files in the /var/log/quantum directory are relevant, but the dhcp-agent.log, l3-agent.log, and openvswitch-agent.log files are directly relevant to this stage. `grep -i error *.log` works well, but be mindful of the timestamps. Errors that were logged before starting these steps are not necessarily relevant.

</div>

## Step 2. Configure the Router and External Network

Some elaboration on the terms used in this section's title is helpful. "External network" basically means the "public network" or "the network \*other\* than the one that connects your VMs together". The "router" is similar in function to the general meaning of the term in networking: it "routes" traffic to-and-from the "external network" and the VMs internal networks. Unlike an actual router, Neutron does not implement a routing per-se, but configures the system so it takes care of it for you. The software component in Neutron that takes care of this is the "L3 agent" being run as the `quantum-l3-agent`. Of course since Open vSwitch is being used to create network device connections, the `quantum-openvswitch-agent` is also important. It is important to note this so you know where to go looking if things go wrong!

While we are on the topic of Open vSwitch, let's run some commands and take note of the output. This will give us a baseline and re-running these commands later will help identify the changes that Neutron is making.

Run the Open vSwitch command line tool to show the current contents of the Open vSwitch database.

    ovs-vsctl show
    74613231-71bb-4bc9-81ab-22f2bc04d53a
        Bridge br-int
            Port br-int
                Interface br-int
                    type: internal
        Bridge br-ex
            Port br-ex
                Interface br-ex
                    type: internal
        ovs_version: "1.10.0"

Now run the linux bridge control tool to see what linux bridges are currently defined.

    brctl show

This command may or not produce output depending on what is already configured on the host system (e.g. libvirt's default network). If there are pre-existing bridges, take note of them so you can differentiate between the Neutron and non-Neutron related bridges later on.

Running `ifconfig` again will reveal that there are new interfaces, br-int and br-ex. These interfaces are appropriately enough associated with the br-int and br-ex ports that appeared in the results of `ovs-vsctl show` above. *ports* and network interfaces are related. *ports* are actually quite appropriately named, as they indicate an addresssable *connection point* just like a port on a switch or an interface card.

Unless an error occurred before, running `ip netns` will reveal the same results as before. If an error still occurs here, then either something went wrong with packstack or you didn't reboot when you should have.

Not much has happened so far, but this has all been preamble and we have not even really started step 2 yet. So let's get on with it.

### Setup Your Environment

When working from the command line, setting some environment variables can make running the command line tools more pleasant. The alternative is specifying --os-username, --os-tenant, etc. on the command line. Packstack created a file named "keystonerc_admin" in root's home directory (e.g. /root/keystonerc_admin) that contains the environment you need. The file contents are similar to the following:

    export OS_USERNAME=admin
    export OS_TENANT_NAME=admin
    export OS_PASSWORD=cf98ff4cb9974b13
    export OS_AUTH_URL=http://192.168.122.134:35357/v2.0/
    export PS1='[\u@\h \W(keystone_admin)]$ '

To initialize the environment variables in the current environment, simply "source" the file:

    # command prompt included to illustrate change made by keystonerc_admin
    root@rdotest:~ > source /root/keystonerc_admin
    [root@rdotest ~(keystonerc_admin)]

If you are using bash or similar for your shell, your command prompt should change as indicated above allowing you to quickly see if the environment has been set. Now you can run commands without having to include all of those details on the command line.

### Creating the External Network

There are actually two steps: create the external network and create a subnet on that network. In Neutron, the notion of "network" and "subnet" are separated. The "network" in this sense can be roughly described as a collection of related connections and devices. A "subnet" is a block of IP addresses and the things that normally go along with them, like addresses of gateways, whether the addresses are allocated over DHCP, routes, etc. and DNS servers, etc.. A single network can have multiple subnets, and each subnet can differ. This is rich, yet natural abstraction of what we are accustomed to when discussing physical networks.

First create the network:

    # quantum net-create [network name] --router:external=True
    quantum net-create extnet --router:external=True
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

The external network needs a set of assignable IP addresses so let's create it now:

    # quantum subnet-create [network name] --allocation-pool start=[beginning of IP range],end=[end of IP range] --gateway [address of gateway] \
    #   --enable_dhcp=False [cidr]
    quantum subnet-create extnet --allocation-pool start=192.168.21.10,end=192.168.21.25  --gateway 192.168.21.1 --enable_dhcp=False  192.168.21.0/24 
    +------------------+----------------------------------------------------+
    | Field            | Value                                              |
    +------------------+----------------------------------------------------+
    | allocation_pools | {"start": "192.168.21.10", "end": "192.168.21.25"} |
    | cidr             | 192.168.21.0/24                                    |
    | dns_nameservers  |                                                    |
    | enable_dhcp      | False                                              |
    | gateway_ip       | 192.168.21.1                                       |
    | host_routes      |                                                    |
    | id               | c4e92c69-1621-4acc-9196-899e2989c1b1               |
    | ip_version       | 4                                                  |
    | name             |                                                    |
    | network_id       | 1c211b3b-dcf9-4731-8827-47d14d59e4ee               |
    | tenant_id        | fc7c56953d114e5db556b927b0268fb2                   |
    +------------------+----------------------------------------------------+

Let's perform the next step before we pause and examine the side affects on the system. It'll be more fun that way.

### Create the Router

Creating the router is pretty straightforward:

    # quantum router-create [router name]
    quantum router-create rdorouter
    +-----------------------+--------------------------------------------------------+
    | Field                 | Value                                                  |
    +-----------------------+--------------------------------------------------------+
    | admin_state_up        | True                                                   |
    | external_gateway_info |                                                        |
    | id                    | 6e6f71df-cca2-4959-bdc5-ff97adf8fc8e                   |
    | name                  | rdorouter                                              |
    | routes                |                                                        |
    | status                | ACTIVE                                                 |
    | tenant_id             | fc7c56953d114e5db556b927b0268fb2                       |
    +-----------------------+--------------------------------------------------------+

### Set the Router's Gateway

To set the router's gateway we need two pieces of information from the commands already performed. If you have a tiny scrollback buffer or have otherwise lost them, don't worry as we can get them back. In fact it is more educational if you did, so why not pretend that is what happened.

We need the network ID and the router ID. We can get them by running the appropriate list commands.

    quantum net-list
    +--------------------------------------+--------+------------------------------------------------------+
    | id                                   | name   | subnets                                              |
    +--------------------------------------+--------+------------------------------------------------------+
    | 1c211b3b-dcf9-4731-8827-47d14d59e4ee | extnet | c4e92c69-1621-4acc-9196-899e2989c1b1 192.168.21.0/24 |
    +--------------------------------------+--------+------------------------------------------------------+

    quantum router-list
    +--------------------------------------+-----------+--------------------------------------------------------+
    | id                                   | name      | external_gateway_info                                  |
    +--------------------------------------+-----------+--------------------------------------------------------+
    | 6e6f71df-cca2-4959-bdc5-ff97adf8fc8e | rdorouter |                                                        |
    +--------------------------------------+-----------+--------------------------------------------------------+

Now we have what we need to set the gateway:

    #quantum router-gateway-set [router id] [subnet id]
    quantum router-gateway-set 6e6f71df-cca2-4959-bdc5-ff97adf8fc8e c4e92c69-1621-4acc-9196-899e2989c1b1
    Set gateway for router 6e6f71df-cca2-4959-bdc5-ff97adf8fc8e

Now if we list the routers again, you can see the association of the network and router.

    quantum router-list
    +--------------------------------------+-----------+--------------------------------------------------------+
    | id                                   | name      | external_gateway_info                                  |
    +--------------------------------------+-----------+--------------------------------------------------------+
    | 6e6f71df-cca2-4959-bdc5-ff97adf8fc8e | rdorouter | {"network_id": "1c211b3b-dcf9-4731-8827-47d14d59e4ee"} |
    +--------------------------------------+-----------+--------------------------------------------------------+

And now is a good time to do some "looking around". Let's start with the changes to Open vSwitch.

    ovs-vsctl show
    74613231-71bb-4bc9-81ab-22f2bc04d53a
        Bridge br-int
            Port br-int
                Interface br-int
                    type: internal
        Bridge br-ex
            Port "tap0f7a05c3-8c"
                Interface "tap0f7a05c3-8c"
            Port br-ex
                Interface br-ex
                    type: internal
        ovs_version: "1.10.0"

Note the new port and interface! This indicates that a new interface has been created with a device name of tap0f7a05c3-8c that has been connected through a port of the same name to the Open vSwitch bridge named by br-ex. Does this interface actually exist?

    ifconfig tap0f7a05c3-8c
    tap0f7a05c3-8c Link encap:Ethernet  HWaddr BA:E7:96:F6:51:D4  
              inet6 addr: fe80::b8e7:96ff:fef6:51d4/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:12 errors:0 dropped:0 overruns:0 frame:0
              TX packets:284 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:720 (720.0 b)  TX bytes:18816 (18.3 KiB)

Cool! This interface represents the addressable gateway for the router.

More has changed!

    ip netns
    qrouter-6e6f71df-cca2-4959-bdc5-ff97adf8fc8e

A new namespace has been created. Neutron uses an easily decipherable naming convention for namespaces q[net service type]-[id]. In this case, the namespace is for a router with the id 6e6f71df-cca2-4959-bdc5-ff97adf8fc8e, which if you look above is the id that shows up in the router list.

Now that we have a namespace to play with, we are going to look at a new command.

    ifconfig lo
    lo        Link encap:Local Loopback  
              inet addr:127.0.0.1  Mask:255.0.0.0
              inet6 addr: ::1/128 Scope:Host
              UP LOOPBACK RUNNING  MTU:16436  Metric:1
              RX packets:22413410 errors:0 dropped:0 overruns:0 frame:0
              TX packets:22413410 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:4735986307 (4.4 GiB)  TX bytes:4735986307 (4.4 GiB)
    ip netns exec qrouter-6e6f71df-cca2-4959-bdc5-ff97adf8fc8e ifconfig lo
    lo        Link encap:Local Loopback  
              inet addr:127.0.0.1  Mask:255.0.0.0
              inet6 addr: ::1/128 Scope:Host
              UP LOOPBACK RUNNING  MTU:16436  Metric:1
              RX packets:44 errors:0 dropped:0 overruns:0 frame:0
              TX packets:44 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:4554 (4.4 KiB)  TX bytes:4554 (4.4 KiB)

Since this is the loopback interface we cannot compare MAC addresses, but we can compare RX and TX bytes. Notice the difference? That is because the loopback adapter in the namespace is much newer than the one in the "global" namespace. What else is in the namespace?

    ip netns exec qrouter-6e6f71df-cca2-4959-bdc5-ff97adf8fc8e ifconfig
    lo        Link encap:Local Loopback  
              inet addr:127.0.0.1  Mask:255.0.0.0
              inet6 addr: ::1/128 Scope:Host
              UP LOOPBACK RUNNING  MTU:16436  Metric:1
              RX packets:44 errors:0 dropped:0 overruns:0 frame:0
              TX packets:44 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:4554 (4.4 KiB)  TX bytes:4554 (4.4 KiB)

    qg-0f7a05c3-8c Link encap:Ethernet  HWaddr FA:16:3E:56:BB:E8  
              inet addr:192.168.21.10  Bcast:192.168.21.255  Mask:255.255.255.0
              inet6 addr: fe80::f816:3eff:fe56:bbe8/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:300 errors:0 dropped:0 overruns:0 frame:0
              TX packets:12 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:19872 (19.4 KiB)  TX bytes:720 (720.0 b)

Whoa! Another new interface! This is a bit more interesting. First take note of the IP address 192.168.21.10. If you remember this is the beginning of the range we defined for our external network. Now take a look at the device name, qg-0f7a05c3-8c. If it does not look familiar, take a look at the output of ovs-vsctl show again. The interface connected to the br-ex has a similar name! tap-0f7a05c3-8c and gq-0f7a05c3-8c are complimentary interfaces. The tap-0f7a05c3-8c provides the connection point for the Open vSwitch bridge, while the qg-0f7a05c3-8c interface lives in the router's namespace and provides a point to route packets through. The two are linked together so packets that enter one, exit the other. Remember that tap-0f7a05c3-8c is bridged with br-ex, which is the external bridge, so these interfaces represent how things "a way in and out". What else can we look at? There are a few more things we could take a peek at, but let's not ruin the surprise.

## Step 3. Create a Tenant

This is actually a little boring and is not specific to Neutron, so we will just barrel through and not worry too much about side-effects. Not to say Keystone is boring, it is not! It is actually really cool and is such a shockingly fundamental part of the OpenStack system... well, it really is too much to go into. So remember, this \*part\* is boring, not Keystone.

*... the Keystone guys know where I live.*

So why do we need to do this part? OpenStack pervasively support multi-tenant systems and things like private networks are typically allocated to individual tenants. So for pedagogical completeness, we are going to create a tenant and do most of the rest as the tenant. We could have done all of this earlier and created a per-tenant router, but it is more fun this way. Anyways, just run the following commands.

    # keystone tenant-create --name [tenant name]
    keystone tenant-create --name rdotest
    +-------------+----------------------------------+
    |   Property  |              Value               |
    +-------------+----------------------------------+
    | description |                                  |
    |   enabled   |               True               |
    |      id     | 1b45f7d3e99f49ebb764851457a0755b |
    |     name    |             rdotest              |
    +-------------+----------------------------------+

    # keystone user-create --name [user name] --tenant-id [tenant id] --pass [password] --enable true
    keystone user-create --name rdotest --tenant-id 1b45f7d3e99f49ebb764851457a0755b --pass rdotest --enabled true
    +----------+----------------------------------+
    | Property |              Value               |
    +----------+----------------------------------+
    |  email   |                                  |
    | enabled  |               True               |
    |    id    | 1d6cc3e03e66484a847ba8b4a6e765f8 |
    |   name   |              rdotest             |
    | tenantId | 1b45f7d3e99f49ebb764851457a0755b |
    +----------+----------------------------------+

    keystone role-list
    +----------------------------------+----------+
    |                id                |   name   |
    +----------------------------------+----------+
    | 93edddbab62c46c593643502c0f5c2e4 |  Member  |
    | 9fe2ff9ee4384b1894a90878d3e92bab | _member_ |
    | f24282688cdf4ee1a5f6786bb24f5930 |  admin   |
    +----------------------------------+----------+
    keystone user-role-add --role Member --tenant 1b45f7d3e99f49ebb764851457a0755b --user 1d6cc3e03e66484a847ba8b4a6e765f8

Hopefully you picked a better password than included in this example! Since the thought of specifying tenant id's, etc. on the command line is abhorrent (or should be), create a copy of the /root/keystonerc_admin file and edit it, changing the relevant variables to the new user and tenant.

So you should end up with a file that looks something like the following:

    export OS_USERNAME=rdotest
    export OS_TENANT_NAME=rdotest
    export OS_PASSWORD=rdotest
    export OS_AUTH_URL=http://192.168.122.134:35357/v2.0/
    export PS1='[\u@\h \W(rdotest)]$ '

Source it and move on to the next step!

## Step 4. Create the Private Network

Networks and subnets were discussed earlier so moving on!

    # quantum net-create [network name]
    quantum net-create rdonet
    Created a new network:
    +-----------------+--------------------------------------+
    | Field           | Value                                |
    +-----------------+--------------------------------------+
    | admin_state_up  | True                                 |
    | id              | 51ccbe0f-11fd-4fbf-894a-ac1ee1809b75 |
    | name            | rdonet                               |
    | router:external | False                                |
    | shared          | False                                |
    | status          | ACTIVE                               |
    | subnets         |                                      |
    | tenant_id       | 1b45f7d3e99f49ebb764851457a0755b     |
    +-----------------+--------------------------------------+

    # quantum subnet-create [network name] [cidr]
    quantum subnet-create rdonet 192.168.90.0/24
    Created a new subnet:
    +------------------+----------------------------------------------------+
    | Field            | Value                                              |
    +------------------+----------------------------------------------------+
    | allocation_pools | {"start": "192.168.90.2", "end": "192.168.90.254"} |
    | cidr             | 192.168.90.0/24                                    |
    | dns_nameservers  |                                                    |
    | enable_dhcp      | True                                               |
    | gateway_ip       | 192.168.90.1                                       |
    | host_routes      |                                                    |
    | id               | 113f6dd2-f751-4eb4-85f1-0a107beb51a8               |
    | ip_version       | 4                                                  |
    | name             |                                                    |
    | network_id       | 51ccbe0f-11fd-4fbf-894a-ac1ee1809b75               |
    | tenant_id        | 1b45f7d3e99f49ebb764851457a0755b                   |
    +------------------+----------------------------------------------------+

If we run the appropriate **show** command we can see the association between network and subnet.

    # quantum net-show [network name]
    quantum net-show rdonet
    +-----------------+--------------------------------------+
    | Field           | Value                                |
    +-----------------+--------------------------------------+
    | admin_state_up  | True                                 |
    | id              | 51ccbe0f-11fd-4fbf-894a-ac1ee1809b75 |
    | name            | rdonet                               |
    | router:external | False                                |
    | shared          | False                                |
    | status          | ACTIVE                               |
    | subnets         | 113f6dd2-f751-4eb4-85f1-0a107beb51a8 |
    | tenant_id       | 1b45f7d3e99f49ebb764851457a0755b     |
    +-----------------+--------------------------------------+

Let's connect our new network to the router while we have the ids handy. Since the router does not "belong" to our rdotest tenant, we have to switch back to admin user by sourcing the /root/keystonerc_admin file before adding our network to the router.

    source /root/keystonerc_admin
    quantum router-list
    +--------------------------------------+-----------+--------------------------------------------------------+
    | id                                   | name      | external_gateway_info                                  |
    +--------------------------------------+-----------+--------------------------------------------------------+
    | 6e6f71df-cca2-4959-bdc5-ff97adf8fc8e | rdorouter | {"network_id": "1c211b3b-dcf9-4731-8827-47d14d59e4ee"} |
    +--------------------------------------+-----------+--------------------------------------------------------+

    # quantum router-interface-add [router id] [subnet id]
    quantum router-interface-add 6e6f71df-cca2-4959-bdc5-ff97adf8fc8e 113f6dd2-f751-4eb4-85f1-0a107beb51a8
    Added interface to router 6e6f71df-cca2-4959-bdc5-ff97adf8fc8e

If you recall, the last time we created a network, some cool stuff happened. So now is a good time to look around again, this time starting with namespaces.

    ip netns
    qrouter-6e6f71df-cca2-4959-bdc5-ff97adf8fc8e

Nothing new there! This is actually informative and worth remembering for later. Anyways, nothing to see, moving on with Open vSwitch.

    ovs-vsctl show
    74613231-71bb-4bc9-81ab-22f2bc04d53a
        Bridge br-int
            Port br-int
                Interface br-int
                    type: internal
            Port "tap95c9c6a6-cb"
                tag: 1
                Interface "tap95c9c6a6-cb"
        Bridge br-ex
            Port "tap0f7a05c3-8c"
                Interface "tap0f7a05c3-8c"
            Port br-ex
                Interface br-ex
                    type: internal
        ovs_version: "1.10.0"

Ahah! A new interface! This time it is connected to the integration bridge, br-int. Running ifconfig with the interface name produces predictable (now) results.

    ifconfig tap95c9c6a6-cb
    tap95c9c6a6-cb Link encap:Ethernet  HWaddr F2:81:12:A6:AE:03  
              inet6 addr: fe80::f081:12ff:fea6:ae03/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:9 errors:0 dropped:0 overruns:0 frame:0
              TX packets:779 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:594 (594.0 b)  TX bytes:152094 (148.5 KiB)

Cool, but what is it for? Take a peek in the router namespace.

    ip netns exec qrouter-6e6f71df-cca2-4959-bdc5-ff97adf8fc8e ifconfig
    lo        Link encap:Local Loopback  
              inet addr:127.0.0.1  Mask:255.0.0.0
              inet6 addr: ::1/128 Scope:Host
              UP LOOPBACK RUNNING  MTU:16436  Metric:1
              RX packets:44 errors:0 dropped:0 overruns:0 frame:0
              TX packets:44 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:4554 (4.4 KiB)  TX bytes:4554 (4.4 KiB)

    qg-0f7a05c3-8c Link encap:Ethernet  HWaddr FA:16:3E:56:BB:E8  
              inet addr:192.168.21.10  Bcast:192.168.21.255  Mask:255.255.255.0
              inet6 addr: fe80::f816:3eff:fe56:bbe8/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:384 errors:0 dropped:0 overruns:0 frame:0
              TX packets:12 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:25416 (24.8 KiB)  TX bytes:720 (720.0 b)

    qr-95c9c6a6-cb Link encap:Ethernet  HWaddr FA:16:3E:32:96:1B  
              inet addr:192.168.90.1  Bcast:192.168.90.255  Mask:255.255.255.0
              inet6 addr: fe80::f816:3eff:fe32:961b/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:775 errors:0 dropped:0 overruns:0 frame:0
              TX packets:9 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:151318 (147.7 KiB)  TX bytes:594 (594.0 b)

Something new there! Take a look at qr-95c9c6a6-cb. You might notice it that it shares the same "end" as the new interface discovered above tap95c9c6a6-cb. You might also notice that its assigned IP address is that of the newly created subnet. These are the connections used to get data to and from the integration network into the routing namespace to enable communication with other subnets and external networks.

## Step 5. Create an Image

This is run-of-the-mill OpenStack stuff.

    wget http://cloud.fedoraproject.org/fedora-19.x86_64.qcow2
    source rdotest
    glance image-create --container-format=bare --disk-format=qcow2  --name=fedora < fedora-19.x86_64.qcow2
    +------------------+--------------------------------------+
    | Property         | Value                                |
    +------------------+--------------------------------------+
    | checksum         | 50bdc35edb03a38d91b1b071afb20a3c     |
    | container_format | bare                                 |
    | created_at       | 2013-07-16T06:49:14                  |
    | deleted          | False                                |
    | disk_format      | qcow2                                |
    | id               | 26edf158-8c36-4627-9ce1-7a612065e5a9 |
    | is_public        | True                                 |
    | min_disk         | 0                                    |
    | min_ram          | 0                                    |
    | name             | fedora                               |
    | owner            | fc7c56953d114e5db556b927b0268fb2     |
    | protected        | False                                |
    | size             | 9761280                              |
    | status           | active                               |
    | updated_at       | 2013-07-16T06:49:14                  |
    +------------------+--------------------------------------+

*Observant folk will note the size does not match the image. You caught me out, I was using a smaller test image and have simply changed the names to be more useful to "normal folk". Names have been changed to protect the innocent.*

## Step 6. Create and Import SSH Key

More standard fare. Creating an SSH key allows you to have it set in a VM when you boot it, making it easier to login with SSH. You *can* skip this part, but some images might make life a little difficult if the SSH configuration has password authentication disabled. Getting around this would then require VNC access, etc. If for no other reason it is included here for consistency with every other configuration guide.

    nova keypair-add rdokey > rdokey.key
    cat rdokey.key
    -----BEGIN RSA PRIVATE KEY-----
    MIIEogIBAAKCAQEAtKsD/4INjPCfbuvE8wAXN1u9nqxLxYRtquCRfiLlzyEeY8E3
    0qd0bniatjzkinGi/1tKNBH0jDecg0B0RMxY6xRkj6dpTDgTSJ0JKlg2GgCQfTGr
    HNK6SFU7GbdVZyx8TgQTyBJHj8dptnk7lOz7BBb3UFz5M5ccdVWde99cjIiam+sK
    nrFpQivzU01R7VJjZ17c6B9FwDsD4iYbFE/y1MYS/IDet9pMjCZ1zDJunIsVzDIy
    r2rzwdd36lKTQabakgijwnMPZ/FW2tLoJ2JRejxvsGLjxvizo3MDdQUBZ4pacngM
    cwy11jGNKaZ1gkLXGpTuWhONESWQJDz0BBuzTQIBIwKCAQEAoAUvbUdN1Jqb10Xa
    U5JdtLBXfekP6XVLMPLKAgGm+Uk4LHfvnVJ9EWOBt1qBR2v2xOp07Epq4pen4fdC
    aNJAIKuphoz23Ru5TvF9JYFUfW421Uk/yRJqepSiD3Z+17mv7VQRhVIE3m7LWHoB
    kojBEkA6Ipt9orkKk898224QJLIDQ6TGe7lKrwXjGgO39IyRSazgiNSA1iNri0Nu
    ZXCsyoGmMjRFTWghMKjOfqCqU+N5CozU7m+qMmuqfmC6d/9BD3NC+R4SmRLVxwih
    VXIv0e8T43oJ/SyR3nBHH4Bx9awpJI966kBhHKImYX1uVeTyJpCuGvAT2g7w17Av
    ZX8kNwKBgQDqR+d1r6rRsIzr1jhK1PuM72aXFUXCmTr7flJZct11txvvmuoHa5co
    WnOiIOYS6CcZ2cEtSVssa4jnHWiojbsJwqDr/ppDKcNqjcULyh08CfZQ7pl/FCIx
    hkHyIyGvN4Tikl+7BlJrAdTUhqUVb96WPyGBr4SuzYSCTPta5nIVVwKBgQDFar0o
    c9qNkjVJJeeJ+/oybxxQkzPpbwmXOjULLusEWg+Ag77sJmp6l6nqh6+8bnOtGBQU
    /gVRgHorJXRzAyZ21rxLHjK3PsYTtqlHPtzv9t1a4f2K+BfM6D6wgObyjkMX4Bt8
    U7vttAi+2hjrwe4nNAnh5vuvE6CzmWopzBoR+wKBgBQUyrJQ4sGEKVYLDCOr2wwU
    hSLkkPNsOEFxOkIuasDycBvaFA9DvH/NPRyGeh7gsuT1aFRWvqwJN57IAagMJfmF
    tgWZeu/QYTUE1mAYo2uL00jD/oc8PXH1kJ+53lDY34EifTvqmVmhEj4aK2g8ye+f
    At867h2cllRPvcX2fs6hAoGASVOIFlbqxt6I0gbDtuiQIVx4Oy9cbKWV2RWerGHi
    Q3HogDDvJINMHufgBqdtKLtPiW9X6oo8fVubF1cN/tVIzQ3uKoePLh6hV8eAtBAI
    62pSN7MGZtEtaV2ToKToEPMC+j1MCZtxsA+rehZ+SPBCg5b8WziJXkkebpgRfT0u
    QTECgYEAye3zoyDKSXJKTFgU3A/kSjzAn1jWUTBFBAHDdFZottMLn8fVfGO1+j7e
    HEO22iWmH7bcJMvyo5CoZG7KlZEEloQnNAGN96kq1nAVatsCdDNYPAYrpN+6g0hp
    LdtsYpE3BGFh8IzcsZiZmQGZM83KZotn75NY++aKpTiv6gBJ5rM=
    -----END RSA PRIVATE KEY-----

## Step 7. Create Security Group Rules

Forgetting to create security group rules can cause a great deal of frustration. These rules map to iptables filter table rules that control access to and from your VMs. Creating them now allows you to to test your new VMs as soon as possible after they are booted.

    # quantum security-group-rule-create --protocol [protocol type] --direction [ingress|egress] --port-range-min [minimum port range] \
    #    --port-range-max [maximum port range] default
    quantum security-group-rule-create --protocol icmp --direction ingress default
    +-------------------+--------------------------------------+
    | Field             | Value                                |
    +-------------------+--------------------------------------+
    | direction         | ingress                              |
    | ethertype         | IPv4                                 |
    | id                | 7f712814-7624-4246-9a31-10414a8ff8bc |
    | port_range_max    |                                      |
    | port_range_min    |                                      |
    | protocol          | icmp                                 |
    | remote_group_id   |                                      |
    | remote_ip_prefix  |                                      |
    | security_group_id | d777eab9-8669-4f1f-a218-1ef443bcc846 |
    | tenant_id         | 1b45f7d3e99f49ebb764851457a0755b     |
    +-------------------+--------------------------------------+

    quantum security-group-rule-create --protocol tcp --port-range-min 22 --port-range-max 22 --direction ingress default
    +-------------------+--------------------------------------+
    | Field             | Value                                |
    +-------------------+--------------------------------------+
    | direction         | ingress                              |
    | ethertype         | IPv4                                 |
    | id                | f3188128-9b4d-4947-8998-aa64aea744ff |
    | port_range_max    | 22                                   |
    | port_range_min    | 22                                   |
    | protocol          | tcp                                  |
    | remote_group_id   |                                      |
    | remote_ip_prefix  |                                      |
    | security_group_id | d777eab9-8669-4f1f-a218-1ef443bcc846 |
    | tenant_id         | 1b45f7d3e99f49ebb764851457a0755b     |
    +-------------------+--------------------------------------+

    quantum security-group-rule-list
    +--------------------------------------+----------------+-----------+----------+------------------+--------------+
    | id                                   | security_group | direction | protocol | remote_ip_prefix | remote_group |
    +--------------------------------------+----------------+-----------+----------+------------------+--------------+
    | 3f7bcde0-81d5-478a-a2e9-1cec4238bd9f | default        | ingress   |          |                  | default      |
    | 712d2c6c-70a3-4dd1-8255-502a815f3f6b | default        | ingress   |          |                  | default      |
    | 7f712814-7624-4246-9a31-10414a8ff8bc | default        | ingress   | icmp     |                  |              |
    | f3188128-9b4d-4947-8998-aa64aea744ff | default        | ingress   | tcp      |                  |              |
    +--------------------------------------+----------------+-----------+----------+------------------+--------------+

## Step 8. Boot the VM

For a lot of people, this is justifiably the moment of truth. If you have everything configured properly, your new instance will boot, have a network interface **with** an IP address and, thanks to already having the security group rules in place, you can ping it and SSH to it.

    nova boot --flavor 1 --image 26edf158-8c36-4627-9ce1-7a612065e5a9 --key-name rdokey lookit
    +-----------------------------+--------------------------------------+
    | Property                    | Value                                |
    +-----------------------------+--------------------------------------+
    | status                      | BUILD                                |
    | updated                     | 2013-07-19T05:37:04Z                 |
    | OS-EXT-STS:task_state       | scheduling                           |
    | key_name                    | rdokey                               |
    | image                       | fedora                               |
    | hostId                      |                                      |
    | OS-EXT-STS:vm_state         | building                             |
    | flavor                      | m1.tiny                              |
    | id                          | 2e108e64-2833-4915-8761-c9b2abac8fe8 |
    | security_groups             | [{u'name': u'default'}]              |
    | user_id                     | 1d6cc3e03e66484a847ba8b4a6e765f8     |
    | name                        | lookit                               |
    | adminPass                   | o5wpKZknpsA3                         |
    | tenant_id                   | 1b45f7d3e99f49ebb764851457a0755b     |
    | created                     | 2013-07-19T05:37:03Z                 |
    | OS-DCF:diskConfig           | MANUAL                               |
    | metadata                    | {}                                   |
    | accessIPv4                  |                                      |
    | accessIPv6                  |                                      |
    | progress                    | 0                                    |
    | OS-EXT-STS:power_state      | 0                                    |
    | OS-EXT-AZ:availability_zone | nova                                 |
    | config_drive                |                                      |
    +-----------------------------+--------------------------------------+

Depending on the speed of your host system, this can take anywhere from less than one to several minutes. If you are the patient sort, wait around 20-30 seconds and check how things are going.

    nova list
    +--------------------------------------+-----------+--------+--------------------------------------------+
    | ID                                   | Name      | Status | Networks                                   |
    +--------------------------------------+-----------+--------+--------------------------------------------+
    | 2e108e64-2833-4915-8761-c9b2abac8fe8 | lookit    | ACTIVE | rdonet=192.168.90.2                        |
    +--------------------------------------+-----------+--------+--------------------------------------------+

Status might be something other than ACTIVE, but basically anything other than ERROR is a good sign. If the output has a value in the "Networks" column and it is consistent with how you configured your private network, things are shiny.

NOW is a great time to take a look around. We are going to take a different approach this time, starting from the VM and working our way back. It is the first time some of these commands appear in this document and we will not be discussing them in depth, but you are encouraged to do a bit of extra research on them as they are valuable parts of your diagnostic and troubleshooting toolbox.

We start with getting information from libvirt about the VM. You will need to be root or use sudo for this part.

    virsh list
     Id    Name                           State
    ----------------------------------------------------
     1     instance-00000001              running

    virsh dumpxml instance-00000001
    <domain type='qemu' id='1'>
      <name>instance-00000001</name>
      <uuid>2e108e64-2833-4915-8761-c9b2abac8fe8</uuid>
      <memory unit='KiB'>524288</memory>
      <currentMemory unit='KiB'>524288</currentMemory>
      <vcpu placement='static'>1</vcpu>
      <sysinfo type='smbios'>
        <system>
          <entry name='manufacturer'>Red Hat Inc.</entry>
          <entry name='product'>OpenStack Nova</entry>
          <entry name='version'>2013.1.2-1.el6</entry>
          <entry name='serial'>e2e26c6a-f0ab-f494-f985-830bb79f69f2</entry>
          <entry name='uuid'>2e108e64-2833-4915-8761-c9b2abac8fe8</entry>
        </system>
      </sysinfo>
      <os>
        <type arch='x86_64' machine='rhel6.4.0'>hvm</type>
        <boot dev='hd'/>
        <smbios mode='sysinfo'/>
      </os>
      <features>
        <acpi/>
        <apic/>
      </features>
      <clock offset='utc'/>
      <on_poweroff>destroy</on_poweroff>
      <on_reboot>restart</on_reboot>
      <on_crash>destroy</on_crash>
      <devices>
        <emulator>/usr/libexec/qemu-kvm</emulator>
        <disk type='file' device='disk'>
          <driver name='qemu' type='qcow2' cache='none'/>
          <source file='/var/lib/nova/instances/2e108e64-2833-4915-8761-c9b2abac8fe8/disk'/>
          <target dev='vda' bus='virtio'/>
          <alias name='virtio-disk0'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x0'/>
        </disk>
        <controller type='usb' index='0'>
          <alias name='usb0'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x2'/>
        </controller>
        <interface type='bridge'>
          <mac address='fa:16:3e:1c:0b:36'/>
          <source bridge='qbr2c1f85af-d7'/>
          <target dev='tap2c1f85af-d7'/>
          <model type='virtio'/>
          <driver name='qemu'/>
          <alias name='net0'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
        </interface>
        <serial type='file'>
          <source path='/var/lib/nova/instances/2e108e64-2833-4915-8761-c9b2abac8fe8/console.log'/>
          <target port='0'/>
          <alias name='serial0'/>
        </serial>
        <serial type='pty'>
          <source path='/dev/pts/0'/>
          <target port='1'/>
          <alias name='serial1'/>
        </serial>
        <console type='file'>
          <source path='/var/lib/nova/instances/2e108e64-2833-4915-8761-c9b2abac8fe8/console.log'/>
          <target type='serial' port='0'/>
          <alias name='serial0'/>
        </console>
        <input type='tablet' bus='usb'>
          <alias name='input0'/>
        </input>
        <input type='mouse' bus='ps2'/>
        <graphics type='vnc' port='5900' autoport='yes' listen='192.168.122.134' keymap='en-us'>
          <listen type='address' address='192.168.122.134'/>
        </graphics>
        <video>
          <model type='cirrus' vram='9216' heads='1'/>
          <alias name='video0'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0'/>
        </video>
        <memballoon model='virtio'>
          <alias name='balloon0'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>
        </memballoon>
      </devices>
      <seclabel type='dynamic' model='selinux' relabel='yes'>
        <label>system_u:system_r:svirt_t:s0:c101,c299</label>
        <imagelabel>system_u:object_r:svirt_image_t:s0:c101,c299</imagelabel>
      </seclabel>
    </domain>

*If you pick through that output you may notice that there are some inconsistencies with the previous step. Please ignore them for now. I have been playing around with my demo system and some of the values may have changed.*

Take note of the interface description part:

        <interface type='bridge'>
          <mac address='fa:16:3e:1c:0b:36'/>
          <source bridge='qbr2c1f85af-d7'/>
          <target dev='tap2c1f85af-d7'/>
          <model type='virtio'/>
          <driver name='qemu'/>
          <alias name='net0'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
        </interface>

This indicates that an interface named tap2c1f85af-d7 is created which is the host side of the primary network interface in the VM. tap2c1f85af-d7 is immediately added to the linux bridge named qbr2c1f85af-d7. If we are using Open vSwitch, why does use a linux bridge? If you are familiar with libvirt, you know that it natively supports Open vSwitch bridges. The reason is that the iptables rules manipulated by security groups does not work with Open vSwitch, so Neutron uses a linux bridge/Open vSwitch hybrid bridge to connect VMs to the integration bridge. While we are on the topic of linux bridges:

    brctl show 
    bridge name         bridge id           STP enabled interfaces
    qbr2c1f85af-d7      8000.c6b118a3dbc8   no          qvb2c1f85af-d7
                                                        tap2c1f85af-d7

So there's the aforementioned bridge, qbr2c1f85af-d7 and the tap2c1f85af-d7 interface for the VM. So what about qvb2c1f85af-d7? We can look at it:

    ifconfig qvb2c1f85af-d7
    qvb2c1f85af-d7 Link encap:Ethernet  HWaddr C6:B1:18:A3:DB:C8  
              inet6 addr: fe80::c4b1:18ff:fea3:dbc8/64 Scope:Link
              UP BROADCAST RUNNING PROMISC MULTICAST  MTU:1500  Metric:1
              RX packets:12447 errors:0 dropped:0 overruns:0 frame:0
              TX packets:20214 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:2218555 (2.1 MiB)  TX bytes:4101811 (3.9 MiB)

Cool, but that does not tell us much. What about Open vSwitch?

    ovs-vsctl show
    74613231-71bb-4bc9-81ab-22f2bc04d53a
        Bridge br-int
            Port "tapc328b9a9-3c"
                tag: 1
                Interface "tapc328b9a9-3c"
           Port "qvo2c1f85af-d7"
                tag: 1
                Interface "qvo2c1f85af-d7"
            Port br-int
                Interface br-int
                    type: internal
            Port "tap95c9c6a6-cb"
                tag: 1
                Interface "tap95c9c6a6-cb"
       Bridge br-ex
            Port "tap0f7a05c3-8c"
                Interface "tap0f7a05c3-8c"
            Port br-ex
                Interface br-ex
                    type: internal
        ovs_version: "1.10.0"

Mmmm.. close, but wait! We are looking for qvb2c1f85af-d7 and ovs-vsctl does not show an interface of that name, but if you look at the one new interface that is there you will notice that qvo2c1f85af-d7 shares everything but the first three letters. This is because qvb2c1f85af-d7 and qvb2c1f85af-d7 are two ends of *veth pair*. The qvo prefix stands for *quantum veth Open vSwitch side* and the qvb prefix stands for *quantum veth linux bridge side*. Nice! You will also notice that from the virtual machine's VIF right down to interface and port added to the br-int integration bridge, everything shares the same "suffix", e.g. 2c1f85af-d7. Once you have one, you know what to look for in Open vSwitch, the linux bridge list, the interface lists and libvirt! That is the entire chain of connecting a VM to the integration bridge!

But wait! There is more! This is DHCP enabled subnet, so how does that work? Neutron uses dnsmasq for DHCP so looking for it in the process table may tell us something.

    ps ax | grep dnsmasq
    7490 ?        S      0:04 dnsmasq --no-hosts --no-resolv --strict-order --bind-interfaces --interface=ns-c328b9a9-3c --except-interface=lo --pid-file=/var/lib/quantum/dhcp/51ccbe0f-11fd-4fbf-894a-ac1ee1809b75/pid --dhcp-hostsfile=/var/lib/quantum/dhcp/51ccbe0f-11fd-4fbf-894a-ac1ee1809b75/host --dhcp-optsfile=/var/lib/quantum/dhcp/51ccbe0f-11fd-4fbf-894a-ac1ee1809b75/opts --dhcp-script=/usr/bin/quantum-dhcp-agent-dnsmasq-lease-update --leasefile-ro --dhcp-range=tag0,192.168.90.0,static,120s --conf-file= --domain=openstacklocal
    7491 ?        S      0:01 dnsmasq --no-hosts --no-resolv --strict-order --bind-interfaces --interface=ns-c328b9a9-3c --except-interface=lo --pid-file=/var/lib/quantum/dhcp/51ccbe0f-11fd-4fbf-894a-ac1ee1809b75/pid --dhcp-hostsfile=/var/lib/quantum/dhcp/51ccbe0f-11fd-4fbf-894a-ac1ee1809b75/host --dhcp-optsfile=/var/lib/quantum/dhcp/51ccbe0f-11fd-4fbf-894a-ac1ee1809b75/opts --dhcp-script=/usr/bin/quantum-dhcp-agent-dnsmasq-lease-update --leasefile-ro --dhcp-range=tag0,192.168.90.0,static,120s --conf-file= --domain=openstacklocal

Dissecting the output, we find clues that tell us how dnsmasq is run and how each instance maps to Neutron. First start with the UUID that appears everywhere: 51ccbe0f-11fd-4fbf-894a-ac1ee1809b75. If we look at the network list:

    quantum net-list
    +--------------------------------------+---------+-------------------------------------------------------+
    | id                                   | name    | subnets                                               |
    +--------------------------------------+---------+-------------------------------------------------------+
    | 1c211b3b-dcf9-4731-8827-47d14d59e4ee | extnet  | c4e92c69-1621-4acc-9196-899e2989c1b1                  |
    | 51ccbe0f-11fd-4fbf-894a-ac1ee1809b75 | rdonet  | 113f6dd2-f751-4eb4-85f1-0a107beb51a8 192.168.90.0/24  |
    +--------------------------------------+---------+-------------------------------------------------------+

There it is! The id for rdonet.

The --dhcp-range obviously matches the subnet, so that makes sense. Now take a look at the --interface option. The interface name is ns-c328b9a9-3c, what happens if run ifconfig?

    ifconfig ns-c328b9a9-3c 
    ns-c328b9a9-3c: error fetching interface information: Device not found

Okay so it appears not to exist, but leave that alone for a minute and revisit the Open vSwitch database.

    ovs-vsctl show
    74613231-71bb-4bc9-81ab-22f2bc04d53a
        Bridge br-int
            Port "tapc328b9a9-3c"
                tag: 1
                Interface "tapc328b9a9-3c"
            Port "qvo2c1f85af-d7"
                tag: 1
                Interface "qvo2c1f85af-d7"
            Port br-int
                Interface br-int
                    type: internal
            Port "tap95c9c6a6-cb"
                tag: 1
                Interface "tap95c9c6a6-cb"
        Bridge br-ex
            Port "tap0f7a05c3-8c"
                Interface "tap0f7a05c3-8c"
            Port br-ex
                Interface br-ex
                    type: internal
        ovs_version: "1.10.0"

The first entry on the br-int integration bridge is tapc328b9a9-3c which, once again, differs from the interface we are looking for but only by the first three characters. So by Neutron convention we can expect that they are related, but where is ns-c328b9a9-3c? Checking the namespaces gives us a new clue.

    ip netns
    qrouter-6e6f71df-cca2-4959-bdc5-ff97adf8fc8e
    qdhcp-51ccbe0f-11fd-4fbf-894a-ac1ee1809b75

A new namespace and it has dhcp **and** the UUID of the network we are looking at in its name!

    ip netns exec qdhcp-51ccbe0f-11fd-4fbf-894a-ac1ee1809b75 ifconfig
    lo        Link encap:Local Loopback  
              inet addr:127.0.0.1  Mask:255.0.0.0
              inet6 addr: ::1/128 Scope:Host
              UP LOOPBACK RUNNING  MTU:16436  Metric:1
              RX packets:0 errors:0 dropped:0 overruns:0 frame:0
              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

    ns-c328b9a9-3c Link encap:Ethernet  HWaddr FA:16:3E:73:5C:8E  
              inet addr:192.168.90.3  Bcast:192.168.90.255  Mask:255.255.255.0
              inet6 addr: fe80::f816:3eff:fe73:5c8e/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:19567 errors:0 dropped:0 overruns:0 frame:0
              TX packets:10119 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:4006741 (3.8 MiB)  TX bytes:2005045 (1.9 MiB)

And there it is! It has the proper name and proper subnet and exists in a namespace with name that strong implicates that this is what we are looking for. If it is out here in the namespace and dnsmasq is configured to only use this interface, how does it work? Remember the tapc328b9a9-3c interface registered on the br-int integration bridge in Open vSwitch? ns-c328b9a9-3c and tapc328b9a9-3c are directly linked network interfaces. Packets appearing on one, appear on the other. So in the case of DHCP, the VM sends a DHCP Request packet through its chain of connections to the integration bridge, it is broadcasted to all all associated interfaces on the integration bridge (let's ignore VLANs and they part the play in isolating networks and broadcasts for now). The packet appears on tapc328b9a9-3c which is directly linked to ns-c328b9a9-3c which is what dnsmasq is listening on. The DHCP Reply packet goes back the same way. If you run tcpdump on any of these interfaces, you can watch it happen.

If for some reason your VM did not get its address, then some part of the process of making all of the connections most likely failed. If you are having trouble with DHCP, examining this chain is an excellent place to start.

We can often link the information we get from running ifconfig, etc with information available from Neutron itself. We have already seen how id's are often used in naming. Another example is the Neutron's port list.

    quantum port-list
    +--------------------------------------+------+-------------------+--------------------------------------------------------------------------------------+
    | id                                   | name | mac_address       | fixed_ips                                                                            |
    +--------------------------------------+------+-------------------+--------------------------------------------------------------------------------------+
    | 2c1f85af-d798-49f6-863f-722b963cf271 |      | fa:16:3e:1c:0b:36 | {"subnet_id": "113f6dd2-f751-4eb4-85f1-0a107beb51a8", "ip_address": "192.168.90.2"}  |
    | c328b9a9-3cb0-4e46-ab22-7c0d27eb5b2f |      | fa:16:3e:73:5c:8e | {"subnet_id": "113f6dd2-f751-4eb4-85f1-0a107beb51a8", "ip_address": "192.168.90.3"}  |
    +--------------------------------------+------+-------------------+--------------------------------------------------------------------------------------+

The last entry matches the MAC and IP address of ns-c328b9a9-3c, the first entry matches the MAC address of the VMs interface.

That is a lot to digest, but we have one more thing to do. We want our new VM to have a public IP address associated with it as well.

    nova list
    +--------------------------------------+---------+--------+------------------------------------+
    | ID                                   | Name    | Status | Networks                           |
    +--------------------------------------+---------+--------+------------------------------------+
    | 2e108e64-2833-4915-8761-c9b2abac8fe8 | lookit  | ACTIVE | rdonet=192.168.90.2                |
    +--------------------------------------+---------+--------+------------------------------------+

    # quantum port-list -- --device_id [ID for VM]
    quantum port-list -- --device_id 2e108e64-2833-4915-8761-c9b2abac8fe8
    +--------------------------------------+------+-------------------+-------------------------------------------------------------------------------------+
    | id                                   | name | mac_address       | fixed_ips                                                                           |
    +--------------------------------------+------+-------------------+-------------------------------------------------------------------------------------+
    | 2c1f85af-d798-49f6-863f-722b963cf271 |      | fa:16:3e:1c:0b:36 | {"subnet_id": "113f6dd2-f751-4eb4-85f1-0a107beb51a8", "ip_address": "192.168.90.2"} |
    +--------------------------------------+------+-------------------+-------------------------------------------------------------------------------------+

    # quantum floatingip-create [network name]
    quantum floatingip-create extnet
    +---------------------+--------------------------------------+
    | Field               | Value                                |
    +---------------------+--------------------------------------+
    | fixed_ip_address    |                                      |
    | floating_ip_address | 192.168.21.11                        |
    | floating_network_id | 1c211b3b-dcf9-4731-8827-47d14d59e4ee |
    | id                  | c8f42335-6832-477a-96d2-e817cb0e389c |
    | port_id             |                                      |
    | router_id           |                                      |
    | tenant_id           | 1b45f7d3e99f49ebb764851457a0755b     |
    +---------------------+--------------------------------------+

    # quantum floatingip-associate [floating IP id] [port id]
    quantum floatingip-associate c8f42335-6832-477a-96d2-e817cb0e389c 2c1f85af-d798-49f6-863f-722b963cf271

    # quantum floatingip-show [floating IP id]
    quantum floatingip-show c8f42335-6832-477a-96d2-e817cb0e389c
    +---------------------+--------------------------------------+
    | Field               | Value                                |
    +---------------------+--------------------------------------+
    | fixed_ip_address    | 192.168.90.2                         |
    | floating_ip_address | 192.168.21.11                        |
    | floating_network_id | 1c211b3b-dcf9-4731-8827-47d14d59e4ee |
    | id                  | c8f42335-6832-477a-96d2-e817cb0e389c |
    | port_id             | 2c1f85af-d798-49f6-863f-722b963cf271 |
    | router_id           | 6e6f71df-cca2-4959-bdc5-ff97adf8fc8e |
    | tenant_id           | 1b45f7d3e99f49ebb764851457a0755b     |
    +---------------------+--------------------------------------+

    nova list
    +--------------------------------------+------+--------+------------------------------------+
    | ID                                   | Name | Status | Networks                           |
    +--------------------------------------+------+--------+------------------------------------+
    | 2e108e64-2833-4915-8761-c9b2abac8fe8 | gee  | ACTIVE | rdonet=192.168.90.2, 192.168.21.11 |
    +--------------------------------------+------+--------+------------------------------------+

As you might come to except, when you do things with the network there are discernable changes! Start with Open vSwitch

    ovs-vsctl show
    74613231-71bb-4bc9-81ab-22f2bc04d53a
        Bridge br-int
            Port "tapc328b9a9-3c"
                tag: 1
                Interface "tapc328b9a9-3c"
            Port "qvo2c1f85af-d7"
                tag: 1
                Interface "qvo2c1f85af-d7"
            Port br-int
                Interface br-int
                    type: internal
            Port "tap95c9c6a6-cb"
                tag: 1
                Interface "tap95c9c6a6-cb"
        Bridge br-ex
            Port "tap0f7a05c3-8c"
                Interface "tap0f7a05c3-8c"
            Port br-ex
                Interface br-ex
                    type: internal
        ovs_version: "1.10.0"

Nothing new there! The IP address might be a clue. It is reasonable to expect that an interface with an IP from a private subnet can only be found in a VM, but this is a public address so there should be an interface with it somewhere in the system. If you run ifconfig with no arguments and grep for the address, you will not find it there either.

    ifconfig | grep 192.168.21.11 | wc -l
    0

This is an address associated with a network that *routes* to the external network, so check the router namespace.

    ip netns
    qrouter-6e6f71df-cca2-4959-bdc5-ff97adf8fc8e
    qdhcp-51ccbe0f-11fd-4fbf-894a-ac1ee1809b75

    ip netns exec qrouter-6e6f71df-cca2-4959-bdc5-ff97adf8fc8e ifconfig
    lo        Link encap:Local Loopback  
              inet addr:127.0.0.1  Mask:255.0.0.0
              inet6 addr: ::1/128 Scope:Host
              UP LOOPBACK RUNNING  MTU:16436  Metric:1
              RX packets:44 errors:0 dropped:0 overruns:0 frame:0
              TX packets:44 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:4554 (4.4 KiB)  TX bytes:4554 (4.4 KiB)

    qg-0f7a05c3-8c Link encap:Ethernet  HWaddr FA:16:3E:56:BB:E8  
              inet addr:192.168.21.10  Bcast:192.168.21.255  Mask:255.255.255.0
              inet6 addr: fe80::f816:3eff:fe56:bbe8/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:1082 errors:0 dropped:0 overruns:0 frame:0
              TX packets:12 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:71484 (69.8 KiB)  TX bytes:720 (720.0 b)

    qr-95c9c6a6-cb Link encap:Ethernet  HWaddr FA:16:3E:32:96:1B  
              inet addr:192.168.90.1  Bcast:192.168.90.255  Mask:255.255.255.0
              inet6 addr: fe80::f816:3eff:fe32:961b/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:2105 errors:0 dropped:0 overruns:0 frame:0
              TX packets:9 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:424450 (414.5 KiB)  TX bytes:594 (594.0 b)

Nope, it is not there either. Sorry, wild goose chase! You can look for an interface all day, but you won't find it. It does not actually exist. Associating a floating IP address with a VM creates a *mapping* from one to the other and produces network address translation (NAT) rules to do source and destination translation on communications on the external network. Since this is a routing function, examine the iptables in the router namespace.

    ip netns exec qrouter-6e6f71df-cca2-4959-bdc5-ff97adf8fc8e iptables-save
    # Generated by iptables-save v1.4.7 on Fri Jul 19 14:48:09 2013
    *filter
    :INPUT ACCEPT [1403:249136]
    :FORWARD ACCEPT [0:0]
    :OUTPUT ACCEPT [0:0]
    :quantum-filter-top - [0:0]
    :quantum-l3-agent-FORWARD - [0:0]
    :quantum-l3-agent-INPUT - [0:0]
    :quantum-l3-agent-OUTPUT - [0:0]
    :quantum-l3-agent-local - [0:0]
    -A INPUT -j quantum-l3-agent-INPUT 
    -A FORWARD -j quantum-filter-top 
    -A FORWARD -j quantum-l3-agent-FORWARD 
    -A OUTPUT -j quantum-filter-top 
    -A OUTPUT -j quantum-l3-agent-OUTPUT 
    -A quantum-filter-top -j quantum-l3-agent-local 
    -A quantum-l3-agent-INPUT -d 127.0.0.1/32 -p tcp -m tcp --dport 9697 -j ACCEPT 
    COMMIT
    # Completed on Fri Jul 19 14:48:09 2013
    # Generated by iptables-save v1.4.7 on Fri Jul 19 14:48:09 2013
    *nat
    :PREROUTING ACCEPT [740:227920]
    :POSTROUTING ACCEPT [0:0]
    :OUTPUT ACCEPT [0:0]
    :quantum-l3-agent-OUTPUT - [0:0]
    :quantum-l3-agent-POSTROUTING - [0:0]
    :quantum-l3-agent-PREROUTING - [0:0]
    :quantum-l3-agent-float-snat - [0:0]
    :quantum-l3-agent-snat - [0:0]
    :quantum-postrouting-bottom - [0:0]
    -A PREROUTING -j quantum-l3-agent-PREROUTING 
    -A POSTROUTING -j quantum-l3-agent-POSTROUTING 
    -A POSTROUTING -j quantum-postrouting-bottom 
    -A OUTPUT -j quantum-l3-agent-OUTPUT 
    1 => -A quantum-l3-agent-OUTPUT -d 192.168.21.11/32 -j DNAT --to-destination 192.168.90.2   
    2 => -A quantum-l3-agent-POSTROUTING ! -i qg-0f7a05c3-8c ! -o qg-0f7a05c3-8c -m conntrack ! --ctstate DNAT -j ACCEPT 
    -A quantum-l3-agent-PREROUTING -d 169.254.169.254/32 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 9697 
    3 => -A quantum-l3-agent-PREROUTING -d 192.168.21.11/32 -j DNAT --to-destination 192.168.90.2 
    4 => -A quantum-l3-agent-float-snat -s 192.168.90.2/32 -j SNAT --to-source 192.168.21.11 
    -A quantum-l3-agent-snat -j quantum-l3-agent-float-snat 
    5 => -A quantum-l3-agent-snat -s 192.168.90.0/24 -j SNAT --to-source 192.168.21.10 
    -A quantum-postrouting-bottom -j quantum-l3-agent-snat 
    COMMIT
    # Completed on Fri Jul 19 14:48:09 2013
    # Generated by iptables-save v1.4.7 on Fri Jul 19 14:48:09 2013
    *mangle
    :PREROUTING ACCEPT [12277:1946878]
    :INPUT ACCEPT [9346:1658758]
    :FORWARD ACCEPT [2781:276800]
    :OUTPUT ACCEPT [140:11986]
    :POSTROUTING ACCEPT [2921:288786]
    COMMIT
    # Completed on Fri Jul 19 14:48:09 2013

I messed up the output a little bit and prefixed the relevant lines with '=>' to highlight the ones worth mentioning. The first highlighted rule converts packets that are at the end of the rule chain that addressed to 192.168.21.11, the floating IP address allocated to lookit, and translates it 192.168.90.2, the private IP. The regular network rules will take care of the rest after that. The second highlighted rule allows any communication between any interface other than the routers gateway. The third highlighted rule translates the floating IP for lookit to the private IP before routing rules are applied. The fourth rule translates the source address for packets coming from lookit, but going out onto the external network to the floating IP address so the return path is to a publicly accessible address. Finally the fifth rule translates the source address from ANY VM on the same subnet as lookit to have a publicly addressible return path. The implication here is that a VM does not need a floating IP to communicate with the public network, just the other way around.

You could say that a lot goes on when you boot a VM!

## Step 10. Getting VMs to Communicate with the Outside World

Chances are you want to be able to do things with these VMs, like communicate with other hosts, etc. While we technically have followed the steps of setting up external communications, we have only been dealing with an external network as a conceptual entity. Unfortunately getting access to the public network we have defined as if it were an actual external network is problematic. Making it so those VMs can communicate with the outside world through that public network is straightforward, if a little hackish.

### NAT Trick

To allow communications to occur between your Neutron public network and your host network as well as all of the networks outside of the host network, you basically need to configure a NAT based router. Some simple rules are all that is required. However, first verify that IP forwarding is actually enabled.

    sysctl -w net.ipv4.ip_forward = 1

To make it persistent, edit the /etc/sysctl.conf file and change it there as well.

Now add iptables rules to allow forwarding in and out of the br-ex interface.

    iptables -I FORWARD -i br-ex -j ACCEPT
    iptables -I FORWARD -o br-ex -j ACCEPT

Finally, to ensure a valid reverse-path, add a MASQUERADE rule so that any connections from the Neutron public network will appear as though they came from the host system.

    iptables -t nat -I POSTROUTING -s 192.168.21.0/24 ! -d 192.168.21.0/24 -j MASQUERADE

You should now be able to SSH and ping from your VMs to the outside world!

## Conclusion and Next Steps

While not a production deployment, this exercise provided a useful evaluation system as well as unravelled some of the details and mystery of what Neutron does when it configures networking. Hopefully this will help people using Neutron for the first time, particularly with packstack, get more comfortable with configuring networks as enough background to get started on creating something more like a real production deployment.

A follow up to configuring the all-in-one setup, [Packstack with Multiple Compute nodes](Packstack with Multiple Compute nodes) works through connecting br-ex and br-int to actual networks. Cross node data networks are discussed as well as VLANs. [Floating IPs on the Lab Network](Floating IPs on the Lab Network) describes a "hack" to use floating IPs that are on the same subnet as your local network to allow you to access Openstack instances directly from other computers on your local network. [Dumb Tricks with Neutron](Dumb Tricks with Neutron) explores configurations that are not **quite** in the scope of cloud networking but may inspire solutions to non-obvious integration problems or possibly even techniques that are directly useful!

<Category:Documentation>
