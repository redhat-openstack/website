---
title: MEM 5.0 Integration with RHOSP Liberty on RHEL 7 using Director
---

# MEM 5.0 Integration with RHOSP Liberty on RHEL 7 using Director

This guide covers the basic steps for the integration of [Midokura Enterprise
MidoNet (MEM)][mem] 5.0 into a Director-based RHOSP Liberty OpenStack
installation on RHEL 7.

It does not cover topics like BGP uplink configuration or the MEM Manager and
MEM Insights components.

Please see the "Quick Start Guides" and the "Operations Guide" at the
[MEM Documentation][mem-docs] web site for advanced installation and
configuration instructions.

In case that you find an issue with this guide, please report it to the
[Midokura Customer Support][mem-support].

## Conventions

This guide uses the following variables, which have to be replaced with the
corresponding values from the target environment:

| `<CONTROLLER_HOST>`   | The host name or IP address of the Controller node.
| `<NSDB-1_HOST>`       | The host name or IP address of the 1st NSDB server.
| `<NSDB-2_HOST>`       | The host name or IP address of the 2nd NSDB server.
| `<NSDB-3_HOST>`       | The host name or IP address of the 3rd NSDB server.
| `<KEYSTONE_IP>`       | The IP address of the Keystone service.
| `<ADMIN_TOKEN>`       | The Keystone admin token.
| `<ADMIN_PASS>`        | The Keystone `admin` user's password.
| `<MIDONET_PASS>`      | The Keystone `midonet` user's password.
| `<MDP_SHARED_SECRET>` | The Metadata Proxy's shared secret.
| `<NEUTRON_DB_PASS>`   | The password for the Neutron database.

## Prerequisites

Deploy the Overcloud according to the [RHOSP 8 Director Installation and Usage
documentation][rhosp8-docs].

_**Note**: Do not yet perform the [Tasks after Overcloud Creation]
[rhosp8-docs-oc-tasks], (e.g. tenant network creation). This will be done after
the MidoNet integration has been completed._

This guide assumes that the Overcloud uses isolated networks on a single NIC
with tagged VLANs. Depending on the used environment, the network configuration
steps below may differ.

Additionally to the deployed Overcloud nodes, MidoNet requires at least one node
for it's Network state Database (NSDB), a cluster of servers that utilize
ZooKeeper and Cassandra to store MidoNet configuration, run-time state, and
statistics data.

The NSDB is not part of the Director-based Overcloud deployment and has to be
installed manually.

For production-level environments it is advised to use at least three NSDB
nodes. For a small demo or PoC environment a single NSDB node may be sufficient.

## Repository Configuration

### NSDB Nodes

On the NSDB nodes, enable the Datastax repository:

Create the `/etc/yum.repos.d/datastax.repo` file and edit it to contain the
following:

```
# DataStax (Apache Cassandra)
[datastax]
name = DataStax Repo for Apache Cassandra
baseurl = http://rpm.datastax.com/community
enabled = 1
gpgcheck = 1
gpgkey = https://rpm.datastax.com/rpm/repo_key
```

### Controller Node

On the Controller node, enable the RHOSP repository:

```
# subscription-manager repos --enable=rhel-7-server-openstack-8-rpms
```

### Controller and Compute Nodes

On the Controller and Compute node, enable the MEM repository:

Create the `/etc/yum.repos.d/midokura.repo` file and edit it to contain the
following:

```
[mem]
name=MEM
baseurl=http://username:password@repo.midokura.com/mem-5/stable/el7/
enabled=1
gpgcheck=1
gpgkey=https://repo.midokura.com/midorepo.key

[mem-openstack-integration]
name=MEM OpenStack Integration
baseurl=http://repo.midokura.com/openstack-liberty/stable/el7/
enabled=1
gpgcheck=1
gpgkey=https://repo.midokura.com/midorepo.key

[mem-misc]
name=MEM 3rd Party Tools and Libraries
baseurl=http://repo.midokura.com/misc/stable/el7/
enabled=1
gpgcheck=1
gpgkey=https://repo.midokura.com/midorepo.key
```

_**Note**: Replace `username` and `password` with the login credentials
provided by Midokura._

## OpenStack Installation

Deploy the Overcloud:

```
# openstack overcloud deploy ...
```

_**Note**: Do not yet perform the [Tasks after Overcloud Creation]
[rhosp8-docs-oc-tasks], (e.g. tenant network creation). This will be done after
the MidoNet integration has been completed._

## OpenStack Integration

### Open vSwitch Removal

MidoNet conflicts with the installed Open vSwitch (OVS) components. Thus they
are going to be removed and the existing network configuration recreated.

_**Note**: If you do not have physical access to the servers, ensure that you
access them via a management network interface that is not controlled by OVS._

Preform the following steps on the Controller and Compute nodes.

1. Backup existing network settings

   Create backups of the configuration files in `/etc/sysconfig/network-scripts`
   and save the output of the following commands for later reference:

   ```
   # ifconfig -a
   # ovs-vsctl show
   ```

2. Reconfigure VLANs

   The VLANs created by the Director deployment have to be reconfigured to not
   use the Open vSwitch bridge, but instead be configured directly on the
   physical NIC interface.

   The following examples assume a single physical interface `eth0` with an Open
   vSwitch bridge `br-ex` that is used by the VLANs.

   Modify the VLAN interface configuration files:
   `/etc/sysconfig/network-scripts/ifcfg-vlan*`

   Remove the following OVS-related settings from all `ifcfg-vlan*` files:

   ```
   DEVICETYPE=ovs
   TYPE=OVSIntPort
   OVS_BRIDGE=br-ex
   OVS_OPTIONS="tag=XX"
   ```

   And instead tie the VLANs to the physical interface:

   ```
   PHYSDEV=eth0
   VLAN=yes
   VLAN_NAME_TYPE=VLAN_PLUS_VID_NO_PAD
   VLAN_ID=XX
   ```

   Example:

   ```
   DEVICE=vlan99
   PHYSDEV=eth0
   ONBOOT=yes
   HOTPLUG=no
   NM_CONTROLLED=no
   PEERDNS=NO
   BOOTPROTO=static
   IPADDR=203.0.113.99
   NETMASK=255.255.255.0
   VLAN=yes
   VLAN_NAME_TYPE=VLAN_PLUS_VID_NO_PAD
   VLAN_ID=99
   ```

3. Reconfigure physical interface

   The IP settings from the OVS bridge have to be configured on the physical
   interface.

   Get the OVS bridge's IP configuration (from `ifcfg-br-ex`):

   ```
   BOOTPROTO=static
   IPADDR=192.0.2.13
   NETMASK=255.255.255.0
   DNS1=8.8.8.8
   DNS2=8.8.4.4
   ```

   Edit the physical interface's configuration (`ifcfg-eth0`) and remove the
   following OVS-related entries:

   ```
   DEVICETYPE=ovs
   TYPE=OVSPort
   OVS_BRIDGE=br-ex
   ```

   Afterwards add the IP configuration entries:

   ```
   BOOTPROTO=static
   IPADDR=192.0.2.13
   NETMASK=255.255.255.0
   DNS1=8.8.8.8
   DNS2=8.8.4.4
   ```

3. Remove OVS components

   Remove the OVS bridges:

   ```
   # ovs-vsctl del-br br-tun 
   # ovs-vsctl del-br br-int 
   # ovs-vsctl del-br br-ex 
   ```

   ```
   # rm /etc/sysconfig/network-scripts/ifcfg-br-ex
   ```

   Stop OVS services:

   ```
   # systemctl stop openvswitch.service
   # systemctl stop openvswitch-nonetwork.service
   ```

   Erase OVS packages:

   ```
   # yum erase openvswitch openstack-neutron-openvswitch python-openvswitch
   ```

   Apply modified configuration:

   ```
   # ifdown eth0
   # ifup eth0
   # ifup vlan10
   # ifup vlan20
   ...
   # ifup vlanXX
   ```

### Keystone Integration

1. Create MidoNet API Service

   As Keystone `admin` user, execute the following command:

   ```
   # openstack service create --name midonet --description "MidoNet API Service" midonet
   ```

2. Create MidoNet Administrative User

   As Keystone `admin` user, execute the following commands:

   ```
   # openstack user create --project services --password-prompt midonet
   # openstack role add --project services --user midonet admin
   ```

### Neutron Integration

#### Neutron Server Configuration

Perform the following steps on the Controller node.

1. Install the MidoNet Plug-in

   ```
   # yum install python-networking-midonet
   ```

2. Edit the `/etc/neutron/neutron.conf` file and configure the following
   parameters:

   ```
   [DEFAULT]
   core_plugin = midonet.neutron.plugin_v2.MidonetPluginV2

   service_plugins = lbaas,midonet.neutron.services.firewall.plugin.MidonetFirewallPlugin,midonet.neutron.services.l3.l3_midonet.MidonetL3ServicePlugin

   dhcp_agent_notification = False

   allow_overlapping_ips = True
   ```

3. Edit the `/etc/neutron/neutron_lbaas.conf` file and configure the following
   parameters:

   ```
   [service_providers]
   service_provider = LOADBALANCER:Midonet:midonet.neutron.services.loadbalancer.driver.MidonetLoadbalancerDriver:default
   ```

3. Create the directory for the MidoNet plugin configuration:

   ```
   # mkdir /etc/neutron/plugins/midonet
   ```

4. Create the `/etc/neutron/plugins/midonet/midonet.ini` file and edit it to
   contain the following:

   ```
   [DATABASE]
   sql_connection = mysql://neutron:<NEUTRON_DB_PASS>@<CONTROLLER_HOST>/neutron

   [MIDONET]
   # MidoNet API URL
   midonet_uri = http://<CONTROLLER_HOST>:8181/midonet-api
   # MidoNet administrative user in Keystone
   username = midonet
   password = <MIDONET_PASS>
   # MidoNet administrative user's tenant
   project_id = services
   ```

5. Update the `/etc/neutron/plugin.ini` symlink to point Neutron to the MidoNet
   configuration:

   ```
   # ln -sfn /etc/neutron/plugins/midonet/midonet.ini /etc/neutron/plugin.ini
   ```

#### Neutron Database Upgrade

Run the `midonet-db-manage` utility to upgrade the Neutron database.

1. Stop Neutron service

   ```
   # systemctl stop neutron-server
   ```

2. Upgrade Neutron database

   ```
   # midonet-db-manage upgrade head
   ```

3. Restart Neutron service

   ```
   # systemctl start neutron-server
   ```

### Horizon Integration

To enable firewalling in the Horizon Dashboard, change the `enable_firewall`
option to `True` in the `/etc/openstack-dashboard/local_settings` file:

```
OPENSTACK_NEUTRON_NETWORK = {
   ...
   'enable_firewall': True,
   ...
}
```

To enable load balancing in the Horizon Dashboard, change the `enable_lb` option
to `True` in the `/etc/openstack-dashboard/local_settings` file:

```
OPENSTACK_NEUTRON_NETWORK = {
   ...
   'enable_lb': True,
   ...
}
```

### Libvirt Configuration

On the Compute nodes, change the Libvirt configuration as follows.

1. Edit the `/etc/libvirt/qemu.conf` file to contain the following:

   ```
   user = "root"
   group = "root"

   [...]

   cgroup_device_acl = [
       "/dev/null", "/dev/full", "/dev/zero",
       "/dev/random", "/dev/urandom",
       "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
       "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
       "/dev/net/tun"
   ]
   ```

2. Restart Libvirt:

   ```
   # systemctl restart libvirtd
   ```

## MidoNet Installation

### MidoNet Network State Database

The MidoNet Network State Database (NSDB) is a cluster of servers that utilizes
ZooKeeper and Cassandra to store MidoNet configuration, run-time state, and
statistics data.

The NSDB is not part of the Director-based Overcloud deployment and has to be
installed manually.

For a production-level environment it is advised to use at least three NSDB
nodes. For a small demo or PoC environment a single NSDB node may be sufficient.

On the NSDB nodes, perform the following steps.

#### ZooKeeper Installation

1. Install ZooKeeper packages:

   ```
   # yum install java-1.7.0-openjdk-headless
   # yum install zookeeper zkdump nmap-ncat
   ```

2. Edit the `/etc/zookeeper/zoo.cfg` file to contain the following:

   ```
   server.1=<NSDB-1_HOST>:2888:3888
   server.1=<NSDB-2_HOST>:2888:3888
   server.1=<NSDB-3_HOST>:2888:3888
   autopurge.snapRetainCount=10
   autopurge.purgeInterval=12
   ```

3. Create data directory:

   ```
   # mkdir /var/lib/zookeeper/data
   # chown zookeeper:zookeeper /var/lib/zookeeper/data
   ```

4. Create the `/var/lib/zookeeper/data/myid` file and edit it to contain the
   host's ID.

   On node 1:

   ```
   # echo 1 > /var/lib/zookeeper/data/myid
   ```

   On node 2:

   ```
   # echo 2 > /var/lib/zookeeper/data/myid
   ```

   On node 3:

   ```
   # echo 3 > /var/lib/zookeeper/data/myid
   ```

5. Create Java Symlink

   ```
   # mkdir -p /usr/java/default/bin/
   # ln -s /usr/lib/jvm/jre-1.7.0-openjdk/bin/java /usr/java/default/bin/java
   ```

6. Enable and start ZooKeeper

   ```
   # systemctl enable zookeeper
   # systemctl start zookeeper
   ```

7. Verify ZooKeeper Operation

   A basic check can be done by executing the `ruok` (Are you ok?) command on
   each node. This will reply with `imok` (I am ok.) if the server is running in
   a non-error state:

   ```
   $ echo ruok | nc 127.0.0.1 2181
   imok
   ```

#### Cassandra Installation

1. Install the Cassandra package:

   ```
   # yum install dsc22
   ```

2. Configure the cluster.

   Edit the `/etc/cassandra/conf/cassandra.yaml` to contain the following.

   On all nodes:

   ```
   # The name of the cluster.
   cluster_name: 'midonet'

   [...]

   # Addresses of hosts that are deemed contact points.
   seed_provider:
       - class_name: org.apache.cassandra.locator.SimpleSeedProvider
         parameters:
             - seeds: "<NSDB-1_HOST>,<NSDB-2_HOST>,<NSDB-3_HOST>"
   ```

   On node 1:

   ```
   # Address to bind to and tell other Cassandra nodes to connect to.
   listen_address: <NSDB-1_HOST>

   [...]

   # The address to bind the Thrift RPC service.
   rpc_address: <NSDB-1_HOST>
   ```

   On node 2:

   ```
   # Address to bind to and tell other Cassandra nodes to connect to.
   listen_address: <NSDB-2_HOST>

   [...]

   # The address to bind the Thrift RPC service.
   rpc_address: <NSDB-2_HOST>
   ```

   On node 3:

   ```
   # Address to bind to and tell other Cassandra nodes to connect to.
   listen_address: <NSDB-3_HOST>

   [...]

   # The address to bind the Thrift RPC service.
   rpc_address: <NSDB-3_HOST>
   ```

3. Edit the service's init script

   On installation, the `/var/run/cassandra` directory is created, but in case
   it is located on a temporary file system it will be lost after system reboot.
   As a result it is not possible to stop or restart the Cassandra service
   anymore.

   To avoid this, edit the `/etc/init.d/cassandra` file to create the directory
   on service start:

   ```
   [...]
   case "$1" in
       start)
           # Cassandra startup
           echo -n "Starting Cassandra: "
           mkdir -p /var/run/cassandra
           chown cassandra:cassandra /var/run/cassandra
           su $CASSANDRA_OWNR -c "$CASSANDRA_PROG -p $pid_file" > $log_file 2>&1
           retval=$?
   [...]
   ```

4. Enable and start Cassandra

   ```
   # systemctl enable cassandra
   # systemctl start cassandra
   ```

5. Verify Cassandra Operation

   A basic check can be done by executing the `nodetool status` command. This
   will reply with `UN` (Up / Normal) in the first column if the nodes are
   running in a non-error state:

   ```
   $ nodetool --host 127.0.0.1 status
   [...]
   Status=Up/Down
   |/ State=Normal/Leaving/Joining/Moving
   --  Address  Load      Tokens  Owns    Host ID  Rack
   UN  ...      46.14 KB  256     100.0%  ...      rack1
   UN  ...      46.14 KB  256     100.0%  ...      rack1
   UN  ...      46.14 KB  256     100.0%  ...      rack1
   ```

### MidoNet Cluster Installation

Perform the following steps on the Controller node.

1. Install MidoNet Cluster package

   ```
   # yum install midonet-cluster
   ```

2. Set up mn-conf

   Edit `/etc/midonet/midonet.conf` to point the Cluster to ZooKeeper:

   ```
   [zookeeper]
   zookeeper_hosts = <NSDB-1_HOST>:2181,<NSDB-2_HOST>:2181,<NSDB-3_HOST>:2181
   ```

3. Configure access to the NSDB

   Run the following command to set the cloud-wide values for the ZooKeeper and
   Cassandra server addresses:

   ```
   # cat << EOF | mn-conf set -t default
   zookeeper {
       zookeeper_hosts = "<NSDB-1_HOST>:2181,<NSDB-2_HOST>:2181,<NSDB-3_HOST>:2181"
   }

   cassandra {
       servers = "<NSDB-1_HOST>,<NSDB-2_HOST>,<NSDB-3_HOST>"
   }
   EOF
   ```

4. Configure Keystone access

   Set up access to Keystone for the MidoNet Cluster node:

   ```
   # cat << EOF | mn-conf set -t default
   cat << EOF | mn-conf set -t default
   cluster.auth {
      provider_class = "org.midonet.cluster.auth.keystone.KeystoneService"
      admin_role = "admin"
      keystone.tenant_name = "admin"
      keystone.admin_token = "<ADMIN_TOKEN>"
      keystone.host = <KEYSTONE_IP>
      keystone.port = 35357
   }
   EOF
   ```

5. Start the MidoNet Cluster

   ```
   # systemctl enable midonet-cluster
   # systemctl start midonet-cluster
   ```

### MidoNet CLI Installation

Perform the following steps on the Controller node.

1. Install MidoNet CLI package

   ```
   # yum install python-midonetclient
   ```

2. Configure MidoNet CLI

   Create the `~/.midonetrc` file and edit it to contain the following:

   ```
   [cli]
   api_url = http://<CONTROLLER_HOST>:8181/midonet-api
   username = admin
   password = <ADMIN_PASS>
   project_id = admin
   ```

### MidoNet Agent (Midolman) Installation

Perform the following steps on the Compute and Gateway nodes.

1. Install Midolman package:

   ```
   # yum install midolman
   ```

2. Set up mn-conf

   Edit `/etc/midolman/midolman.conf` to point the MidoNet Agent to ZooKeeper:

   ```
   [zookeeper]
   zookeeper_hosts = <NSDB-1_HOST>:2181,<NSDB-2_HOST>:2181,<NSDB-3_HOST>:2181
   ```

3. Configure MidoNet Metadata Proxy

   Run the following commands to set the cloud-wide values for the MidoNet
   Metadata Proxy:

   ```
   # echo "agent.openstack.metadata.nova_metadata_url : \"http://<NOVA_MDP_IP>:8775\"" | mn-conf set -t default
   # echo "agent.openstack.metadata.shared_secret : <MDP_SHARED_SECRET>" | mn-conf set -t default
   # echo "agent.openstack.metadata.enabled : true" | mn-conf set -t default
   ```

   _**Note**: This step has to be run only once on a single node._

4. Enable and start MidoNet Agent

   ```
   # systemctl enable midolman
   # systemctl start midolman
   ```

### MidoNet Tunnel Zone Creation and Host Registration

Create a Tunnel Zone in the Midonet CLI and register the MidoNet Agents agent to
it.

1. Launch the MidoNet CLI:

   ```
   # midonet-cli
   midonet>
   ```

2. Create Tunnel Zone:

   ```
   midonet> tunnel-zone create name tz type vxlan
   tzone0

   midonet> list tunnel-zone
   tzone tzone0 name tz type vxlan
   ```

3. Add host to Tunnel Zone:

   ```
   midonet> list host
   host host0 name [...] alive true addresses [...] flooding-proxy-weight 1
   host host1 name [...] alive true addresses [...] flooding-proxy-weight 1
   ...

   midonet> tunnel-zone tzone0 add member host host0 address <HOST_IP>
   zone tzone0 host host0 address <HOST_IP>

   midonet> tunnel-zone tzone0 add member host host1 address <HOST_IP>
   zone tzone0 host host1 address <HOST_IP>

   ...

   midonet> exit
   ```

## Initial Networks Creation

1. Create an external network

   As Keystone `admin` user, execute the following commands:

   ```
   # neutron net-create ext-net --router:external

   # neutron subnet-create \
      ext-net 203.0.113.0/24 \
      --name ext-subnet \
      --allocation-pool start=203.0.113.101,end=203.0.113.200 \
      --disable-dhcp \
      --gateway 203.0.113.1
   ```

2. Create network for the tenants:

   As Keystone tenant user, execute the following commands:

   ```
   # neutron net-create tenant-net

   # neutron subnet-create \
      tenant-net 192.168.1.0/24 \
      --name tenant-subnet \
      --dns-nameserver 8.8.8.8 \
      --gateway 192.168.1.1

   # neutron router-create tenant-router

   # neutron router-interface-add tenant-router tenant-subnet

   # neutron router-gateway-set tenant-router ext-net
   ```

[mem]: http://www.midokura.com/midonet-enterprise/ "Midokura Enterprise MidoNet (MEM)"
[mem-docs]: http://docs.midokura.com/ "Midokura Enterprise MidoNet (MEM) Documentation"
[mem-support]: http://www.midokura.com/customer-support/ "Midokura Customer Support"
[mem-qsg-nsdb]: http://docs.midokura.com/docs/latest-en/quick-start-guide/rhel-7_liberty-osp/content/_nsdb_nodes.html
[rhosp8-docs]: https://access.redhat.com/documentation/en/red-hat-openstack-platform/8/director-installation-and-usage/director-installation-and-usage
[rhosp8-docs-oc-tasks]: https://access.redhat.com/documentation/en/red-hat-openstack-platform/8/director-installation-and-usage/chapter-8-performing-tasks-after-overcloud-creation
