---
title: MidoNet 5.4 Integration with RHOSP 10 (Newton) on RHEL 7
---

# MidoNet 5.4 Integration with RHOSP 10 (Newton) on RHEL 7


This guide covers the basic steps for the integration of [MidoNet][midonet]
5.4 into a RHOSP 10 deployment using RHEL 7, assuming basic knowledge about
RHOSP 10 and its [composable services][composable-services-docs].

## Initial configuration

Follow the [RHOSP 10][rhosp-10-docs] documentation until you have an Undercloud
installed. Stop at the _Obtaining Images for Overcloud Nodes_ section. We're
going to build our own images with the necessary components to run MidoNet.

## Building the base images

Download RHEL 7 guest images and place them inside a folder. Let's assume the
working directory will be `/home/stack/custom-images/`.

Then export these variables (filling in the necessary values) in order to be
able to build the image . If you're using Red Hat Satellite, set the 
`REG_SAT_URL` `REG_SAT_URL` and `REG_ORG` environment variables as described
in the [TripleO documentation][tripleo-deployment] instead.

```
# Base variables
export DIB_LOCAL_IMAGE=YOUR_RHEL_IMAGE_PATH
export ELEMENTS_PATH="/home/stack/custom-images/tripleo-puppet-elements/elements:/usr/share/instack-undercloud:/usr/share/tripleo-image-elements:/usr/bin/../share/diskimage-builder/elements"
export DIB_NO_TMPFS=1

# RH Openstack subscription details
export REG_METHOD=portal
export REG_USER="YOUR_USERNAME"
export REG_PASSWORD="YOUR_PASSWORD"
export REG_POOL_ID="YOUR_POOL_ID"
export REG_REPOS="rhel-7-server-rpms rhel-7-server-optional-rpms rhel-7-server-extras-rpms \
    rhel-ha-for-rhel-7-server-rpms rhel-7-server-openstack-10-rpms \
    rhel-7-server-rhceph-2-tools-rpms rhel-7-server-rhceph-2-mon-rpms"

# MidoNet specific variables
export DIB_MIDONET_stage=stable
export DIB_MIDONET_version="5.4"
export DIB_MIDONET_openstack_version=newton
```

As you can see above, we will be installing MidoNet 5.4 from its stable branch,
for the Newton release. Then clone these two repositories from the MidoNet
GitHub organization (while the patches are being reviewed upstream) and place
them inside `/home/stack/custom-images/`. Then checkout the
`stable/newton_midonet` branch, as it's the branch that contains all changes.

* [tripleo-puppet-elements][midonet-tpe]
* [tripleo-heat-templates][midonet-tht]

To see a full list of the `DIB_MIDONET` environment variables that can be set
check the file at `/home/stack/custom-images/tripleo-puppet-elements/elements/overcloud-network-midonet/environment.d/02-midonet-envs.bash`.

Finally, proceed to build the base image with the following command:

```
openstack overcloud image build --type overcloud-full --elements-path $ELEMENTS_PATH --builder-extra-args overcloud-network-midonet
```

If for whatever reason the process of building the image fails, refer to the
[TripleO documentation on the topic][tripleo-images].

## Upload the images

Just as you would normally do following the RHOSP documentation, unpack the IPA
base images at `/usr/share/rhosp-director-images/ironic-python-agent-*.tar`
inside `/home/stack/custom-images/`. Finally upload these images using:

```
openstack overcloud image upload
```

## Configure MidoNet composable services

### What services does MidoNet define?

The MidoNet Heat templates define the following composable services:

| `midonet_agent`   | This service ensures that the Agent is installed and configured. It also registers the host in the host registry.
| `midonet_cluster` | Used to install and configure the MidoNet Cluster.
| `midonet_config`  | Creates the edge router as well as a basic set of initial networks.
| `midonet_gateway` | Configure the uplink on a gateway node.
| `midonet_nsdb`    | Install and configure Zookeeper and Cassandra.

Distribute these services as you need to on the nodes you are planning on
deploying. These services and more are defined in the file `roles_data.yaml`,
inside the previously cloned `tripleo-heat-templates` folder.

### Set environment variables

Now that the images have been built and uploaded successfully it's time to
prepare the MidoNet deployment. Depending on the type of uplink that needs to
be set up (BGP or static) you will need to define a certain set of variables.
It is recommended to set these in an environment file.

Whether you are configuring a static or a BGP uplink these base variables need
to be defined:

| `MidonetVersion`            | Set to `oss` to install the MidoNet open source version.
| `MidonetAgentMaxHeapSize`   | Amount of heap memory to be used by the JVM running the MidoNet Agent (e.g. `4096M`).
| `MidonetClusterMaxHeapSize` | Amount of heap memory to be used by the JVM running the MidoNet Cluster (e.g. `4096M`).
| `MidonetClusterHeapNewSize` | Size of the heap for the young generation running the MidoNet Cluster (e.g. `2048M`).
| `NeutronCorePlugin`         | Needs to be `midonet_v2_ext`.
| `NeutronServicePlugins`     | Needs to be set to `midonet_l3_ext,midonet.neutron.services.firewall.plugin.MidonetFirewallPlugin,qos,neutron_lbaas.services.loadbalancer.plugin.LoadBalancerPluginv2,vpnaas,midonet_logging_resource`.
| `UplinkType`                | Can be set either to `static` or `bgp`.

As the service `midonet_config` configures the edge router and sets up a basic
set of networks and subnets, these variables too have to be defined:

| `NetworkConfigFipCidr`            | CIDR of the floating IP network used by the VMs (e.g. `10.0.0.0/16`).
| `NetworkConfigFipGatewayIp`       | IP on the floating IP range that will be assigned to the edge router (e.g. `10.0.0.1`).
| `NetworkConfigFipAllocationPools` | Floating IP range that can be assigned to VMs (e.g. `["start=10.0.0.20,end=10.0.255.254"]`).
| `NetworkConfigPortPhysicalName`   | Name of the physical interface to which the edge router port will be bound to (e.g. `veth1`).
| `NetworkConfigPortPhysicalCidr`   | Network on which the physical interface that is bound to the edge router port is (e.g. `172.19.0.2/26`).
| `NetworkConfigPortPhysicalIp`     | IP address that the physical interface has assigned (e.g. `172.19.0.1`).

Further customization of the deployment can be done through the use of
additional parameters. All these parameters are described with detail inside the
files `puppet/services/network/midonet*.yaml`, inside the `tripleo-heat-templates`
folder.

Also these resources need to be mapped accordingly (check how this is done by
seeing the `environments/neutron-midonet.yaml` inside the `tripleo-heat-templates`
folder).

| `OS::TripleO::Services::NeutronCorePlugin`      | `OS::TripleO::Services::MidonetConfig`
| `OS::TripleO::Services::NeutronDhcpAgent`       | `OS::Heat::None`
| `OS::TripleO::Services::NeutronL3Agent`         | `OS::Heat::None`
| `OS::TripleO::Services::NeutronMetadataAgent`   | `OS::Heat::None`
| `OS::TripleO::Services::NeutronOvsAgent`        | `OS::Heat::None`
| `OS::TripleO::Services::ComputeNeutronOvsAgent` | `OS::Heat::None`

### Fake static uplink

In order to set up a static uplink you can set the values just as they are set
in the table above, or check the file `environments/neutron-midonet.yaml` inside
the `tripleo-heat-templates` folder. Only one more parameter needs to be set:

| `StaticUplinkVeth1Ip` | IP address the second virtual interface pair. This IP address must be in the same network as NetworkConfigPortPhysicalCidr (e.g. `172.19.0.2`).

For more information on setting up a fake static uplink check the
[MidoNet documentation][midonet-static].

### BGP uplink

Setting up a BGP uplink requires setting four additional environment variables.
For a real-life example please check `environments/neutron-midonet-bgp.yaml`
inside the `tripleo-heat-templates` folder.

| `BgpUplinkLocalASNumber`      | Local AS number, which must be a string (e.g. `65497`).
| `BgpUplinkNeighborsIps`       | Array containing the IPs of the BGP neighbors (e.g. `["10.88.88.5"]`).
| `BgpUplinkNeighborsAsns`      | Array containing the ASNs of the BGP neighbors (e.g. `["65535"]`).
| `BgpUplinkNeighborsNetworks`  | Array containing the CIDR of the networks in which the BGP neighbors are (e.g. `["10.88.88.0/29"]`).
| `BgpUplinkAdvertisedNetworks` | Floating IP networks that the gateway is going to advertise (e.g. `172.16.0.0/12`).

For more information on setting up a BGP uplink please check the
[MidoNet documentation][midonet-bgp].


### Configure a nameserver

Before actually deploying the overcloud let's assign a DNS server to the network
on which these nodes will be deployed:

```
neutron subnet-list
neutron subnet-update [subnet-uuid] --dns-nameserver [nameserver-ip]
```

## Deploy the overcloud

Now just as you would normally do, deploy the overcloud with the following
command:

```
openstack overcloud deploy --templates /home/stack/custom-images/tripleo-heat-templates -e [your_environment_file]
```


[midonet]: https://www.midonet.org/
[composable-services-docs]: http://docs.openstack.org/developer/tripleo-docs/developer/tht_walkthrough/tht_walkthrough.html
[rhosp-10-docs]: https://access.redhat.com/documentation/en/red-hat-openstack-platform/10/paged/director-installation-and-usage/
[tripleo-images]: http://tripleo.org/troubleshooting/troubleshooting-image-build.html
[tripleo-deployment]: http://tripleo.org/basic_deployment/basic_deployment_cli.html#get-images
[midonet-tpe]: https://github.com/midonet/tripleo-puppet-elements
[midonet-tht]: https://github.com/midonet/tripleo-heat-templates
[midonet-static]: https://docs.midonet.org/docs/latest-en/operations-guide/content/static_setup.html
[midonet-bgp]: https://docs.midonet.org/docs/latest-en/operations-guide/content/bgp_setup.html
