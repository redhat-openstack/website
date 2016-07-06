---
title: MEM 5.0 Integration with RHOSP Liberty on RHEL 7 using Packstack
---

# MEM 5.0 Integration with RHOSP Liberty on RHEL 7 using Packstack

This guide covers the basic steps for the integration of
[Midokura Enterprise MidoNet (MEM)][mem] 5.0 into an RHOSP Liberty Packstack
All-in-One installation on RHEL 7.

It does not cover topics like the installation of a multi-node environment, BGP
uplink configuration or the MEM Manager and MEM Insights components.

Please see the "Quick Start Guides" and the "Operations Guide" at the
[MEM Documentation][mem-docs] web site for advanced installation and
configuration instructions, or if you are not using a Packstack-based
installation.

In case that you find an issue with this guide, please report it to the
[Midokura Customer Support][mem-support].

## Conventions

This guide uses the following variables, which have to be replaced with the
corresponding values from the target environment:

| `<HOST_NAME>`         | The host name of the server.
| `<HOST_IP>`           | The IP address of the server.
| `<ADMIN_TOKEN>`       | The Keystone admin token.
| `<ADMIN_PASS>`        | The Keystone `admin` user's password.
| `<MIDONET_PASS>`      | The Keystone `midonet` user's password.
| `<MDP_SHARED_SECRET>` | The Metadata Proxy's shared secret.
| `<NEUTRON_DB_PASS>`   | The password for the Neutron database.

## Prerequisites

For ease of configuration, this guide assumes that SELinux is set to permissive
mode, as well as the firewall being disabled.

1. Disable SELinux

   To change the mode, execute the following command:

   ```
   # setenforce Permissive
   ```

   To permanently change the SELinux configuration, edit the
   `/etc/selinux/config` file accordingly:

   ```
   SELINUX=permissive
   ```

2. Disable firewall

   If installed, disable the firewall service:

   ```
   # systemctl stop firewalld
   # systemctl disable firewalld
   ```

   ```
   # systemctl stop iptables
   # systemctl disable iptables
   ```

## Repository Configuration

1. Enable Red Hat base repositories

   ```
   # subscription-manager repos --enable=rhel-7-server-rpms
   # subscription-manager repos --enable=rhel-7-server-extras-rpms
   ```

2. Enable Red Hat OSP repository

   ```
   # subscription-manager repos --enable=rhel-7-server-openstack-8-rpms
   ```

3. Enable DataStax repository

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

2. Enable MEM repositories

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

3. Install available updates

   ```
   # yum clean all
   # yum upgrade
   ```

4. If necessary, reboot the system

   ```
   # reboot
   ```

## OpenStack Installation

1. Install Packstack

   ```
   # yum install openstack-packstack
   ```

2. Install OpenStack

   ```
   # packstack --allinone
   ```

### OpenStack Installation Clean-up

1. Remove Open vSwitch packages

   ```
   # yum erase openstack-neutron-openvswitch openvswitch python-openvswitch
   ```

2. Remove ML2 Plug-in

   ```
   # yum erase openstack-neutron-ml2
   ```

3. Stop and disable Neutron Agents

   ```
   # systemctl stop neutron-dhcp-agent
   # systemctl disable neutron-dhcp-agent
   # systemctl stop neutron-l3-agent
   # systemctl disable neutron-l3-agent
   # systemctl stop neutron-metadata-agent
   # systemctl disable neutron-metadata-agent
   ```

## OpenStack Integration

### Keystone Integration

1. Create MidoNet API Service

   As Keystone `admin` user, execute the following command:

   ```
   # openstack service create --name midonet --description "MidoNet API Service" midonet
   ```

2. Create MidoNet Administrative User

   As Keystone `admin` user, execute the following commands:

   ```
   $ keystone user-create --name midonet --pass <MIDONET_PASS> --tenant services
   $ keystone user-role-add --user midonet --role admin --tenant services
   ```

### Neutron Integration

#### Neutron Server Configuration

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
   sql_connection = mysql://neutron:<NEUTRON_DB_PASS>@<HOST_NAME>/neutron

   [MIDONET]
   # MidoNet API URL
   midonet_uri = http://<HOST_NAME>:8181/midonet-api
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

#### Neutron Database Rebuild

Packstack already created some Neutron networks that have to be removed 

1. Stop Neutron service

   ```
   # systemctl stop neutron-server
   ```

2. Rebuild Neutron database

   ```
   # mysql -e 'drop database neutron'
   # mysql -e 'create database neutron'

   # neutron-db-manage \
      --config-file /usr/share/neutron/neutron-dist.conf \
      --config-file /etc/neutron/neutron.conf \
      --config-file /etc/neutron/plugin.ini \
      upgrade head

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

#### ZooKeeper Installation

1. Install ZooKeeper packages:

   ```
   # yum install java-1.7.0-openjdk-headless
   # yum install zookeeper zkdump nmap-ncat
   ```

2. Edit the `/etc/zookeeper/zoo.cfg` file to contain the following:

   ```
   server.1=<HOST_NAME>:2888:3888
   autopurge.snapRetainCount=10
   autopurge.purgeInterval=12
   ```

3. Create data directory:

   ```
   # mkdir /var/lib/zookeeper/data
   # chown zookeeper:zookeeper /var/lib/zookeeper/data
   ```

4. Create the `/var/lib/zookeeper/data/myid` file and edit it to contain the
   host's ID:

   ```
   # echo 1 > /var/lib/zookeeper/data/myid
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
   the node. This will reply with `imok` (I am ok.) if the server is running in
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

   Edit the `/etc/cassandra/conf/cassandra.yaml` to contain the following:

   ```
   # The name of the cluster.
   cluster_name: 'midonet'

   [...]

   # Addresses of hosts that are deemed contact points.
   seed_provider:
       - class_name: org.apache.cassandra.locator.SimpleSeedProvider
         parameters:
             - seeds: "<HOST_NAME>"

   # Address to bind to and tell other Cassandra nodes to connect to.
   listen_address: <HOST_NAME>

   [...]

   # The address to bind the Thrift RPC service.
   rpc_address: <HOST_NAME>
   ```

3. Edit the service's init script

   On installation, the `/var/run/cassandra` directory is created, but because
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
   will reply with `UN` (Up / Normal) in the first column if the server is
   running in a non-error state:

   ```
   $ nodetool --host 127.0.0.1 status
   [...]
   Status=Up/Down
   |/ State=Normal/Leaving/Joining/Moving
   --  Address    Load      Tokens  Owns    Host ID                               Rack
   UN  192.0.2.1  46.14 KB  256     100.0%  11111111-2222-3333-4444-555555555555  rack1
   ```

### Midonet Cluster Installation

1. Install MidoNet Cluster package

   ```
   # yum install midonet-cluster
   ```

2. Set up mn-conf

   Edit `/etc/midonet/midonet.conf` to point the Cluster to ZooKeeper:

   ```
   [zookeeper]
   zookeeper_hosts = <HOST_NAME>:2181
   ```

3. Configure access to the NSDB

   Run the following command to set the cloud-wide values for the ZooKeeper and
   Cassandra server addresses:

   ```
   # cat << EOF | mn-conf set -t default
   zookeeper {
       zookeeper_hosts = "<HOST_NAME>:2181"
   }

   cassandra {
       servers = "<HOST_NAME>"
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
      keystone.host = <HOST_NAME>
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

1. Install MidoNet CLI package

   ```
   # yum install python-midonetclient
   ```

2. Configure MidoNet CLI

   Create the `~/.midonetrc` file and edit it to contain the following:

   ```
   [cli]
   api_url = http://<HOST_NAME>:8181/midonet-api
   username = admin
   password = <ADMIN_PASS>
   project_id = admin
   ```

### MidoNet Agent (Midolman) Installation

1. Install Midolman package:

   ```
   # yum install midolman
   ```

2. Set up mn-conf

   Edit `/etc/midolman/midolman.conf` to point the MidoNet Agent to ZooKeeper:

   ```
   [zookeeper]
   zookeeper_hosts = <HOST_NAME>:2181
   ```

3. Configure MidoNet Metadata Proxy

   Run the following commands to set the cloud-wide values for the MidoNet
   Metadata Proxy:

   ```
   # echo "agent.openstack.metadata.nova_metadata_url : \"http://<HOST_NAME>:8775\"" | mn-conf set -t default
   # echo "agent.openstack.metadata.shared_secret : <MDP_SHARED_SECRET>" | mn-conf set -t default
   # echo "agent.openstack.metadata.enabled : true" | mn-conf set -t default
   ```

4. Enable and start MidoNet Agent

   ```
   # systemctl enable midolman
   # systemctl start midolman
   ```

### MidoNet Tunnel Zone Creation and Host Registration

We first need to create a Tunnel Zone in the Midonet CLI and then register the Midolman agent to it. This will allow the Midolman agent to send packets and communicate to the Midonet API.

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

   midonet> tunnel-zone tzone0 add member host host0 address <HOST_IP>
   zone tzone0 host host0 address 192.0.2.1

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

2. Create a network for the `demo` tenant:

   As Keystone `demo` user, execute the following commands:

   ```
   # neutron net-create demo-net

   # neutron subnet-create \
      demo-net 192.168.1.0/24 \
      --name demo-subnet \
      --dns-nameserver 8.8.8.8 \
      --gateway 192.168.1.1

   # neutron router-create demo-router

   # neutron router-interface-add demo-router demo-subnet

   # neutron router-gateway-set demo-router ext-net
   ```

[mem]: http://www.midokura.com/midonet-enterprise/ "Midokura Enterprise MidoNet (MEM)"
[mem-docs]: http://docs.midokura.com/ "Midokura Enterprise MidoNet (MEM) Documentation"
[mem-support]: http://www.midokura.com/customer-support/ "Midokura Customer Support"
