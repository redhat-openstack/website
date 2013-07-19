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

Some preamble before we begin:

### Quantum vs. Neutron

Neutron is simply the component-formerly-known-as-Quantum. While the commands and configuration files refer to Quantum, the documentation refers to Neutron. The name transition in software will be complete in the upcoming Havana release.

### Conventions

#### OpenStack Commands

Running OpenStack commands are described in three parts:

*   A reference line prefixed with a '#' that provides the general form of the command. Parameters that are variable relative to the discussion are enclosed in square brackets where required parameter values are unadorned. Feel free to use values different than the ones used in the examples, but remember to keep track of them. Keep an eye out for slip-ups where we may have forgotten to put square brackets around something too! If there are no optional arguments at all, the reference line is omitted.
*   An example line.
*   Example output.

***packstack*' is the exception to this convention. The general form of the command is not relevant and the volume of output is quite large.**

#### Non-OpenStack Commands

Regular system commands are typically described in one or, if the output is relevant, two parts:

*   The command with options values consistent with the context of this document.
*   Example output.

#### Checkpoints

Some steps include one or more sets of suggestions for optional steps aimed at verifying the health of the system and success of the steps just completed. Trying these steps will increase your knowledge of the system, your ability to detect and analyze issues and provide a convenient point of reference if something **has** gone wrong and you seek assistance on the mailing list or IRC. Checkpoints are subsections with titles that begin with "Checkpoint" and have body text with slightly different formatting. For example.

#### Checkpoint: OpenStack Guru Health Check

<div style="background-color:#f0f0f0; left:2em">
Visually confirm your pants are not on fire. Evident combustion indicates a time critical condition. Due to potential time zone variability and general apathy of core developers and PTLs, seeking assistance on the mailing lists or IRC is not recommended. Suggested courses of action include: immediate immersion in a NON-flammable fluid; or immediate cessation of forward locomation, adoption of a prone position followed by vigorous twisting of the body on a NON-flammable surface. Vocalizations including expletives, entreaties for immediate assistance from nearby entities corporeal or otherwise, or long strings of vowels are recommended, but optional.

</div>
### General Pro-tips

If you have available screen real estate, you may want to tail the log files in the /var/log/quantum directory after you have run packstack, possibly piping through grep with 'ERROR' as a search string. If you are log file hound, you might try keeping track of the time before running steps to help identify "before" and "after" when analyzing the files. If you are really into keeping track of what you have done, try running `screen` and logging (C-a H)everything you are entering and seeing. Combined with running `date` at key points, it is hard to get a better record of forensics. You might want to be careful to use that \*only\* for running the commands and small operations like examining the state of Open vSwitch, the interfaces, etc.

*Talk about wishing you followed your own advice: screen/logging would have the command line/result aspect of this document a lot easier to write!*

### Before Starting

... some words of encouragement! Not many people would argue that configuring Neutron the first time is intuitive or easy. However, the OpenStack community has endeavored to produce tools for software defined networking (SDN) that do not add unnecessary complexity. That being said, SDN \*is\* meant to tackle difficult problems and, like any tool that can handle an enormous variety of problems, SDN solutions often seem more complex than what is necessary for a simple single network deployment. If you run packstack and try to piece together instructions to setup a working network from the information available on the Internet and end up feeling that everything is magic and shrouded in mystery, you are not alone. If you are familiar with Nova Networking, the precursor to Quantum/Neutron, and you have tried and failed to get a Neutron network up and running, you may even be of the opinion that it is broken. At this point, you are probably wondering where those "words of encouragement" are... well, here they are: once you see what Neutron does and someone dispells some of the mystery for you, managing networks with Neutron is going to be \*easy\*. Furthermore, as you progress to creating more complicated network topologies, the abstractions that Neutron gives you to work with will readily map to the problem domain and feel quite natural. Follow up guides that describe deploying multiple compute nodes and experimenting with weird network integration trick should convince you that this learning curve is well worth it.

Upcoming updates to Packstack all-in-one will actually take of these steps for you in the future. When that day comes, you can either walk through these steps and create separate networks, etc. or you run Packstack without the "--all-in-one" option to pick the deployment options interactively.

## Initial Setup

If you have not already done so, run through the steps on the [Quickstart](Quickstart) page **EXCEPT** for the final step on that page: "**Step 3: Run Packstack to install OpenStack**". This currently describes configuring OpenStack with Nova Networking instead of Neutron, so you need to run it a little differently. However, before running packstack, one of our goals is to help illustrate the changes openstack makes to your system. Run the following commands and take note of the output before running packstack.

    ifconfig
    ip netns

If this is a relatively clean system that has never had OpenStack installed on it, you will probably see a few network devices for the first command. They will most likely have names like "eth0", "lo" or "p1p1". You may have a "virbr0" as well. In any case, there might be 4 or 5 interfaces displayed. If you like the short, tidyness of this output with all of the nice short names, assigned IP addresses, etc. and take comfort in that kind of thing: take a good last, fond look. If all goes well, this is the last time it will be like that. In contrast, ` ip netns ` probably displays nothing or an error.

Now, let's setup our baseline OpenStack install with Neutron enabled

    packstack --allinone --os-quantum-install=y

or simply:

    packstack --allinone

It is recommended that you run Packstack from a regular user account and not as 'root'. You will be prompted for the root account password when Packstack needs it. The installation may take awhile. Once completed, Packstack may have installed kernel updates requiring a reboot. These updates are critical so it is best that you do not skip the reboot step. It's okay, we'll wait for you at Step 1.

## Step 1. Verify and Modify Neutron Configuration

### Checkpoint: Check Service Health and Logs

<div style="background-color:#f0f0f0; left:2em">
Using your favorite method, make sure that the l3 and dhcp agents are still running after restarting. Now is a good time to look for unusual errors in your log files. Any of the the log files in the /var/log/quantum directory are relevant, but the dhcp-agent.log, l3-agent.log, and openvswitch-agent.log files are directly relevant to this stage. `grep -i error *.log` works well, but be mindful of the timestamps. Errors that were logged before starting these steps are not necessarily relevant.

</div>
Network namespaces create new "virtual" network environments that are isolated from each other. Each network namespace has its own network devices, IP addresses, routing tables, ports, etc.. Neutron uses network namespaces to isolate network devices (including VIFs), DHCP and routing services for different networks and tenants. Neutron also uses something called a *veth pair*. A veth pair is two ethernet interfaces connected back-to-back and simplifies connecting things together that cannot be connected directly. We examine how veth pairs and namespaces are used we make our way through the steps. For now it is important to verify that Neutron was configured to enable these features. Your version of Packstack may or may not have modified the configuration files properly. It is better to be safe and check them before proceeding. Since we are modifying configuration files, please be careful not to accidentally modify configuration. You will need root or sudo access to modify them. You could use your favorite text editor to modify the files, but we'll use the openstack-config tool for simplicity.

    #openstack-config --set [config file name] [config file section] [config variable name] [value]
    openstack-config --set /etc/quantum/dhcp_agent.ini DEFAULT ovs_use_veth True
    openstack-config --set /etc/quantum/l3_agent.ini DEFAULT ovs_use_veth True

### Checkpoint: Other Namespace Related Configuration

<div style="background-color:#f0f0f0; left:2em">
Packstack should have configured the other namespace related variables, but if you want to see for yourself check the `DEFAULT` section in `dhcp_agent.ini` for `enable_isolated_metadata` and `use_namespaces`, both of which should be `True`. You can also verify that `interface_driver` is `quantum.agent.linux.interface.OVSInterfaceDriver`. In `l3_agent.ini`, check that `use_namespaces` is `True` and `external_network_bridge` is `br-ex` and `interface_driver` is `quantum.agent.linux.interface.OVSInterfaceDriver`.

</div>
You need to restart the services to pick up the new settings so run:

    service quantum-dhcp-agent restart
    Stopping quantum-dhcp-agent:                               [  OK  ]
    Starting quantum-dhcp-agent:                               [  OK  ]

    service quantum-l3-agent restart
    Stopping quantum-l3-agent:                                 [  OK  ]
    Starting quantum-l3-agent:                                 [  OK  ]

### Checkpoint: Check Service Health and Logs

<div style="background-color:#f0f0f0; left:2em">
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

Now we have what we need to set the gatway:

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

This is actually a little boring and is not specific to Neutron, so we will just barrell through and not worry too much about side-effects. Not to say Keystone is boring, it is not! It is actually really cool and is such a shockingly fundamental part of the OpenStack system... well, it really is too much to go into. So remember, this \*part\* is boring, not Keystone.

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

This is run-of-the-mill OpenStack stuff so we will bull through it pretty much like we did when creating the new tenant.

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

Forgetting to create security group rules can cause a great deal of frustration. These rules control the network filter tables that allow or prevent access to and from your VMs. Create them now so you can test access to your new VMs as soon as possible after they are booted.

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

## Step 8. Boot the VM

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

nova list ip netns ifconfig brctl show ip netns exec qdhcp-51ccbe0f-11fd-4fbf-894a-ac1ee1809b75 iptables-save ip netns exec qdhcp-51ccbe0f-11fd-4fbf-894a-ac1ee1809b75 ifconfig

</pre>
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
