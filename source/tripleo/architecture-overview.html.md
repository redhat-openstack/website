---
title: TripleO Architecture Overview
authors: athomas, chrisw
wiki_title: TripleO Architecture Overview
wiki_revision_count: 16
wiki_last_updated: 2015-04-08
---

# TripleO Architecture Overview

## QuickStart

This document lists the main components of TripleO, and gives some description of how each component is used. There are links to additional sources of information throughout the document. For those wishing to start actually using TripleO, the current installation documentation is here - <https://repos.fedorapeople.org/repos/openstack-m/rdo-manager-docs/liberty/introduction/introduction.html>

## Introduction - TripleO

TripleO is a set of tools for deploying, and managing OpenStack - <https://wiki.openstack.org/wiki/TripleO>

The name TripleO refers to three related things:

*   A design pattern, where an underlying OpenStack instance is used to deploy and then to manage another, usually more complex, OpenStack instance.
*   A set of configuration files and scripts which contain OS image building rules and service configuration rules
*   The upstream program within the OpenStack project which develops the various scripts and utilities which are combined to deliver the complete software solution.

The design pattern, where a sophisticated, general-purpose OpenStack instance is created by, and then runs on top of, a simpler, single-purpose deployment instance of OpenStack, is what gives TripleO its name. It is short for *OpenStack On OpenStack*.

## Benefits

Using TripleO’s combination of OpenStack components, and their APIs, as the infrastructure to deploy and operate OpenStack itself delivers several benefits:

*   TripleO’s APIs \*are\* the OpenStack APIs. They’re well maintained, well documented, and come with client libraries and command line tools. Users who invest time in learning about TripleO’s APIs are also learning about OpenStack itself, and users who are already familiar with OpenStack will find a great deal in TripleOthat they already understand.
*   Using the OpenStack components allows more rapid feature development of TripleO than might otherwise be the case; TripleO automatically inherits all the new features which are added to Glance, Heat etc., even when the developer of the new feature didn’t explicitly have TripleO and TripleO in mind.
*   The same applies to bug fixes and security updates. When OpenStack developers fix bugs in the common components, those fixes are inherited by TripleO
*   Users’ can invest time in integrating their own scripts and utilities with TripleO’s APIs with some confidence. Those APIs are cooperatively maintained and developed by the OpenStack community. They’re not at risk of being suddenly changed or retired by a single controlling vendor.
*   For developers, tight integration with the openstack APIs provides a solid architecture, which has gone through extensive community review.

It should be noted that not everything in TripleO is a reused OpenStack element. The Tuskar API, for example (which lets users design the workload cloud that they want to deploy), is found in TripleO but not, so far at least, in a typical Openstack instance. The Tuskar API is described in more detail below.

## Deploying the workload cloud with TripleO

To begin using TripleO, it is necessary to install the deployment cloud (sometimes referred to as the *undercloud*). The deployment cloud is a working instance of OpenStack, typically on a single machine. It is somewhat limited, because it only really exists for a single purpose: to deploy, and then manage, the workload cloud (sometimes referred to as the *overcloud*).

In TripleO, installing and configuring the deployment cloud is done using a script called instack. Detailed instructions are included in the QuickStart link at the head of this document.

The setup that instack carries out includes:

*   Installing the required software to run the deployment cloud and configuring services
*   Populating the Tuskar DB with default roles
*   Setting a flavor management policy for the installation
*   Downloading, or building, OS images
*   Uploading those images into Glance.

When instack has set up the deployment cloud, the user has a single machine which is running a collection of core OpenStack services, and a couple of other services. The easiest way to understand all of these is to walk through the process of using them to define, prepare for, then deploy and monitor, the workload cloud.

## Hardware discovery

Deploying the workload cloud requires suitable hardware. The first task is to register the available hardware with Ironic, OpenStack’s equivalent of a hypervisor for managing baremetal servers. The sequence of events is pictured below.

![](Hw_discovery_seq.jpg "Hw_discovery_seq.jpg")

*   The user, via the TripleO UI, the command-line tools, or through direct API calls, registers the power management credentials for a node with Ironic.
*   The user then instructs Ironic to reboot the node
*   Because the node is new, and not already fully registered, there are no specific PXE-boot instructions for it. In that case, the default action is to boot into a discovery ramdisk
*   The discovery ramdisk probes the hardware on the node and gathers facts, including the number of CPU cores, the local disk size and the amount of RAM.
*   The ramdisk posts the facts to the discoverd API
*   Discoverd matches the hardware facts it has received with the node whose power management details are already registered with Ironic, and updates the Ironic DB, completing the registration of the node.

## Understanding roles

Roles are stored in the Tuskar DB, and are used through interaction with the Tuskar API. A role brings together three things:

*   An image; the software to be installed on a node
*   A flavor; the size of node suited to the role
*   A set of heat templates; instructions on how to configure the node for its task

In the case of the “Compute” role:

*   the image must contain all the required software to boot an OS and then run the KVM hypervisor and the Nova compute service
*   the flavor (at least for a deployment which isn’t a simple proof of concept), should specify that the machine has enough CPU capacity and RAM to host several VMs concurrently
*   the Heat templates will take care of ensuring that the Nova service is correctly configured on each node when it first boots.

The roles in the current version of TripleO aren’t intended to be very customisable. The associated image can be updated, to allow for newer images with bug fixes, and the associated flavors can be changed (unless the deployment is only a proof of concept - see below), but the Heat templates which configure a node for its role cannot easily be altered, neither can roles be added or removed.

In principle, a user might create their own role definition which did just about anything; they could even be used to deploy something other than an OpenStack workload cloud. However, the inter-related OS images (composed from TripleO image elements) and instance configuration rules (contained in TripleO Heat templates) are complex. A small amount of changes could prevent them from adding up to an operational workload cloud. Roles are used when the user designs the workload cloud they wish to deploy, which is described in a later section.

## Managing flavors

When users are creating virtual machines (VMs) in an OpenStack cloud, the flavor that they choose specifies the capacity of the VM which should be created. The flavor defines the CPU count, the amount of RAM, the amount of disk space etc.. As long as the cloud has enough capacity to grant the user’s wish, and the user hasn’t reached their quota limit, the flavor acts as a set of instructions on exactly what kind of VM to create on the user’s behalf.

In the deployment cloud, where the machines are usually physical rather than virtual (or, at least, pre-existing, rather than created on demand), flavors have a slightly different effect. Essentially, they act as a constraint. Of all of the discovered hardware, only nodes which match a specified flavor are suitable for a particular role. This can be used to ensure that the large machines with a great deal of RAM and CPU capacity are used to run Nova in the workload cloud, and the smaller machines run less demanding services, such as Keystone.

The version of TripleO included in TripleO is capable of handling flavors in two different modes. The simpler PoC (Proof of Concept) mode is intended to enable new users to experiment, without worrying about matching hardware profiles. In the mode, there’s one single, global flavor, and any hardware can match it. That effectively removes flavor matching. Users can use whatever hardware they wish.

For the second mode, named Scale because it is suited to larger scale workload cloud deployments, flavor matching is in full effect. A node will only be considered suitable for a given role if the role is associated with a flavor which matches the capacity of the node. Nodes without a matching flavor are effectively unusable.

This second mode allows users to ensure that their different hardware types end up running their intended role, though it takes some extra effort to configure.

## Preparing the deployment plan

Tuskar exposes a REST API and allows users to define, or update, a deployment plan. That plan contains the details of the roles to be assigned, and the service configuration parameters to be deployed. When the user is satisfied that their deployment plan is correct, then can extract it from Tuskar, and pass it to Heat, which orchestrates the deployment of the actual cloud, based on the plan.

Updating a deployed cloud follows a similar process: The deployment plan is Tuskar is amended to that, for example, it includes an increased number of Nova Compute nodes. That amended plan is then passed to Heat.

There are notes here which described how to interact directly with the Tuskar API to retrieve and update a deployment plan. <https://rdoproject.org/Tuskar-API>

For many users, the simplest way to read and update a deployment plan will be via the TripleO UI.

In a default installation of TripleO, there’s a single pre-loaded deployment plan in Tuskar. The details can be retrieved with this command on the deployment cloud node:

`curl -v -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' `[`http://0.0.0.0:8585/v2/plans/`](http://0.0.0.0:8585/v2/plans/)

There’s a large amount of output, the majority of which is the array of parameters which the deployment plans contain, these cover multiple passwords, some usernames, networking options, the name of the flavor to request when creating an instance of a particular role etc..

On the command line, the complete set of details of a plan, including all the parameters, can be seen by first, retrieving the plan ID:

      [stack@localhost ~]$ tuskar plan-list
      +--------------------------------------+-----------+-------------+----------------------------------------------------+
      | uuid                                 | name      | description | roles                                              |
      +--------------------------------------+-----------+-------------+----------------------------------------------------+
      | 193f7d1d-a1a9-4605-a54f-2c4ead45a7ab | overcloud | None        | controller, swift-storage, compute, cinder-storage |
      +--------------------------------------+-----------+-------------+----------------------------------------------------+

and then by using the uuid for the default plan to run:

      [stack@localhost ~]$ tuskar plan-show 193f7d1d-a1a9-4605-a54f-2c4ead45a7ab

That command lists a lot of output, including all the plan’s set of parameters.

It is possible to alter the parameters associated with a plan, via the command line, or via the REST API. The following command increases the number of instances of the “compute” role which the plan will deploy to 6:

      tuskar plan-patch -A compute-1::count=6 193f7d1d-a1a9-4605-a54f-2c4ead45a7ab

Once the deployment plan is complete, it’s ready to be passed to Heat, the service which actually launches the workload cloud. The command-line tools for Heat consume yaml files. Those yaml files, containing the whole deployment, can be output from Tuskar with this command:

      [stack@localhost tmp]$ tuskar plan-templates -O /tmp 193f7d1d-a1a9-4605-a54f-2c4ead45a7ab
      Following templates has been written:
      /tmp/plan.yaml
      /tmp/environment.yaml
      /tmp/provider-swift-storage-1.yaml
      /tmp/provider-cinder-storage-1.yaml
      /tmp/provider-controller-1.yaml
      /tmp/provider-compute-1.yaml

## Deploying the workload cloud

Bringing the deployment cloud into existence, by parsing the deployment plan from Tuskar and orchestrating the deployment of multiple nodes with images that their roles dictate, and with the required service parameters, is the role of Heat, OpenStack’s orchestration engine.

Heat exposes a Rest API ( <http://developer.openstack.org/api-ref-orchestration-v1.html> ) and also has a client CLI. As in many cases, the simplest way to use create a deployment cloud may well be to use the TripleO web UI.

Heat’s own term for the applications that it creates is stack. The workload cloud, in Heat terms, is a particularly complex instance of a stack.

Creating the stack with the CLI can be done like this:

      [stack@localhost tmp]$ heat stack create -f tuskar_templates/plan.yaml -e tuskar_templates/environment.yaml

In order to the stack to be deployed, Heat makes successive calls to Nova, OpenStack’s compute service controller. Nova depends upon Ironic,which, as described above has acquired an inventory of discovered hardware by this stage in the process

It is at this point that the flavors act as a constraint on the range of machines which can be scheduled onto. For each request to deploy a new node with a specific role, Nova filters the of available nodes, ensuring that the selected nodes meets the hardware requirements.

Once the target node has been selected, Ironic does the actual provisioning of the node, Ironic retrieves the OS image associated with the role from Glance, causes the node to boot a deployment ramdisk and then, in the typical case, exports the node’s local disk over iSCSI so that the disk can be partitioned and the have the OS image written onto it by the Ionic Conductor.

Once the nodes are booted, Heat also manages passing parameters to the newly launched OS in order to complete the configuration of services on the node.

The status of the deploying stack, and the completion of the deployment can be seen with this command:

      [stack@localhost ~]$ heat stack-list
      +--------------------------------------+------------+-----------------+----------------------+
      | id                                   | stack_name | stack_status    | creation_time        |
      +--------------------------------------+------------+-----------------+----------------------+
      | 5b5dc570-c62c-4026-aa70-098c1ac383cb | overcloud  | CREATE_COMPLETE | 2015-03-12T20:15:16Z |
      +--------------------------------------+------------+-----------------+----------------------+

“heat stack-show” will return a complete description of the state of the cloud.

After the deployment of the workload cloud, there’s a set of steps which are required to initialise the keystone service, to register service endpoints, and to complete the configuration of Neutron.

Those capabilities are integrated into the TripleO UI. From the command line, they are all encapsulated in the instack-deploy-overcloud script, which in turn calls init-keystone tripleo setup-endpoints and setup-neutron.

## Monitoring the workload cloud

When the workload cloud is deployed, Ceilometer can be configured to track a set of OS metrics for each node (system load, CPU utilization, swap usage etc.) These metrics are graphed in the TripleO UI, both for individual nodes, and for groups of nodes, such as the collection of nodes which are all delivering a particular role.

Additionally, Ironic exports IPMI metrics for nodes, which can also be stored in Ceilometer. This enables checks on hardware state such as fan operation/failure and internal chassis temperatures.

The metrics which Ceilometer gathers can be queried for Ceilometer's REST API, or by using the command line client, as in the following example:

The first stage is to get the Instance UUID which will be used to identify the node we want to report on:

      [stack@localhost ~]$ ironic node-list
      +--------------------------------------+--------------------------------------+-------------+--------------------+-------------+
      | UUID                                 | Instance UUID                        | Power State | Provisioning State | Maintenance |
      +--------------------------------------+--------------------------------------+-------------+--------------------+-------------+
      | 15739d49-90ab-4a42-9620-fe140f5bdcb5 | 9282131d-5e25-495c-82ce-dcbcd34158f7 | power on    | active             | False       |
      | 3fb4021c-5a79-47ca-af39-f0dcde7109a4 | 31fac73a-90d0-44ef-b3ef-014b43f735e8 | power on    | active             | False       |
      | 4c9915f1-8f6e-4110-85e3-6dcb8539f51d | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | power on    | active             | False       |
      | 3ef1e9e9-9f6b-4bbd-aab1-dd0941fb1ae1 | 0a00e394-be74-45b2-9046-1d81dac3d4a4 | power on    | active             | False       |
      +--------------------------------------+--------------------------------------+-------------+--------------------+-------------+

Having looked up the nodes, we can then look up the available meters for that node:

      [stack@localhost ~]$ ceilometer meter-list --query resource=d52ebd4f-a28b-49cf-8adc-61847e6bb525
      +------------------------------------------+------------+-----------+--------------------------------------+---------+------------+
      | Name                                     | Type       | Unit      | Resource ID                          | User ID | Project ID |
      +------------------------------------------+------------+-----------+--------------------------------------+---------+------------+
      | hardware.cpu.load.15min                  | gauge      | process   | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | None    | None       |
      | hardware.cpu.load.1min                   | gauge      | process   | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | None    | None       |
      | hardware.cpu.load.5min                   | gauge      | process   | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | None    | None       |
      | hardware.memory.swap.avail               | gauge      | B         | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | None    | None       |
      | hardware.memory.swap.total               | gauge      | B         | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | None    | None       |
      | hardware.memory.total                    | gauge      | B         | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | None    | None       |
      | hardware.memory.used                     | gauge      | B         | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | None    | None       |
      | hardware.network.ip.incoming.datagrams   | cumulative | datagrams | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | None    | None       |
      | hardware.network.ip.outgoing.datagrams   | cumulative | datagrams | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | None    | None       |
      | hardware.system_stats.cpu.idle           | gauge      | %         | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | None    | None       |
      | hardware.system_stats.cpu.util           | gauge      | %         | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | None    | None       |
      | hardware.system_stats.io.incoming.blocks | cumulative | blocks    | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | None    | None       |
      | hardware.system_stats.io.outgoing.blocks | cumulative | blocks    | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | None    | None       |
      +------------------------------------------+------------+-----------+--------------------------------------+---------+------------+

Retrieving the actual performance metrics for a node involves a query to return a set of samples:

      [stack@localhost ~]$ ceilometer sample-list --meter hardware.cpu.load.5min -q 'resource_id=d52ebd4f-a28b-49cf-8adc-61847e6bb525'
      +--------------------------------------+------------------------+-------+--------+---------+---------------------+
      | Resource ID                          | Name                   | Type  | Volume | Unit    | Timestamp           |
      +--------------------------------------+------------------------+-------+--------+---------+---------------------+
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.32   | process | 2015-03-13T11:02:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.09   | process | 2015-03-13T10:52:28 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.2    | process | 2015-03-13T10:42:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.07   | process | 2015-03-13T10:32:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.26   | process | 2015-03-13T10:22:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.02   | process | 2015-03-13T10:12:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.14   | process | 2015-03-13T10:02:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.26   | process | 2015-03-13T09:52:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.09   | process | 2015-03-13T09:42:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.65   | process | 2015-03-13T09:32:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.17   | process | 2015-03-13T09:22:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.39   | process | 2015-03-13T09:12:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.13   | process | 2015-03-13T09:02:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.28   | process | 2015-03-13T08:52:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.05   | process | 2015-03-13T08:42:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.2    | process | 2015-03-13T08:32:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.03   | process | 2015-03-13T08:22:27 |
      | d52ebd4f-a28b-49cf-8adc-61847e6bb525 | hardware.cpu.load.5min | gauge | 4.14   | process | 2015-03-13T08:12:27 |

Further information on using the Ceilometer to is available here: <https://www.rdoproject.org/CeilometerQuickStart>

## Scaling out the workload cloud

This page ( <https://www.rdoproject.org/TripleO-CLI#Post-Deployment> ) contains a description of scaling out a deployed workload cloud. The process involves two stages:

*   Updating the plan managed by Tuskar, as described in the “Preparing the deployment plan” section above
*   Calling heat stack-update, to apply the set of changes to Heat’s stack; the workload cloud.

As in the case of the original deployment of the overcloud via Heat, that status of the update can be checked by running heat stack-list.

It's also possible to see a history of the events associated with a stack with this command:

      [stack@localhost ~]$ heat event-list overcloud
      +-----------------------------------+--------------------------------------+------------------------+--------------------+----------------------+
      | resource_name                     | id                                   | resource_status_reason | resource_status    | event_time           |
      +-----------------------------------+--------------------------------------+------------------------+--------------------+----------------------+
      | CephStorageNodesPostDeployment    | 72670265-5145-4bae-b445-f920ccc9aa64 | state changed          | CREATE_COMPLETE    | 2015-03-12T20:19:40Z |
      | CephStorageNodesPostDeployment    | b41db82a-6e17-4eb6-8666-0d5f60a234f9 | state changed          | CREATE_IN_PROGRESS | 2015-03-12T20:19:37Z |
      | ControllerNodesPostDeployment     | f91ede39-f2b8-44b2-8644-072a04d619f0 | state changed          | CREATE_COMPLETE    | 2015-03-12T20:19:37Z |
      | ComputeNodesPostDeployment        | 80912537-d95c-44a6-9975-9ce43d739f8b | state changed          | CREATE_COMPLETE    | 2015-03-12T20:17:58Z |
      | ControllerNodesPostDeployment     | eadbef1a-e932-4f60-a94d-417007ae6578 | state changed          | CREATE_IN_PROGRESS | 2015-03-12T20:17:38Z |
      | ControllerCephDeployment          | 47482901-69a7-4699-973d-c507e762dce8 | state changed          | CREATE_COMPLETE    | 2015-03-12T20:17:38Z |
      | ControllerAllNodesDeployment      | 44436938-71e5-452e-a37f-956f3c8cec8e | state changed          | CREATE_COMPLETE    | 2015-03-12T20:17:38Z |
      | ComputeNodesPostDeployment        | 4ac03e96-b9e3-437a-b0bb-a21774069abc | state changed          | CREATE_IN_PROGRESS | 2015-03-12T20:17:13Z |
      | ComputeAllNodesDeployment         | 253244ba-aae4-4cb0-8d85-968699425217 | state changed          | CREATE_COMPLETE    | 2015-03-12T20:17:13Z |
      | BlockStorageNodesPostDeployment   | cbc1a747-f683-4b74-bbc0-72a8095c8af1 | state changed          | CREATE_COMPLETE    | 2015-03-12T20:17:09Z |
